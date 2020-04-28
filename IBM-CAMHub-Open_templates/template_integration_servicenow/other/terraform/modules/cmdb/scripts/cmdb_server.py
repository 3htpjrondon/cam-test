#!/usr/bin/python
# =================================================================
# Copyright 2018 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

import sys
import argparse
import json

from servicenow import ServiceNow
from servicenow import Connection
from requests.exceptions import ConnectionError

def get_connection(location, instance, user, password):

    """

    Return a connection object for ServiceNow.

    """

    conn =  Connection.Auth(username=user, password=password, instance=instance, api='JSONv2')
    return conn

def create_cmdb(cmdb_server, cmdb_key, cmdb_record):

    """
    Create a CMDB Record, update if already exists. We assume that the name attribute should be unique
    and that a subsequent create will invoke an update.
    """
    try:
        cmdb_records = cmdb_server.list({'name': cmdb_key})
    except ConnectionError, e:
        sys.stderr.write("cmdb_create: Error Connecting to CMDB: %s\n" %e)
        exit(1)
    except ValueError:
        sys.stderr.write("cmdb_create: Error Connecting to CMDB, likely a user or password issue.\n")
        exit(1)

    if len(cmdb_records['records']) == 0:
        sys.stderr.write("create_cmdb: Record with name: %s does not exist, creating.\n" %cmdb_key)
        try:
            cmdb_response = cmdb_server.create(cmdb_record)
        except:
            sys.stderr.write("create_cmdb: Error creating CMDB Record")
            exit(1)
    else:
        sys.stderr.write("create_cmdb: Record with name: %s already exists, updating.\n" %cmdb_key)
        try:
            cmdb_response = cmdb_server.update({'name': cmdb_key}, cmdb_record)
        except:
            sys.stderr.write("create_cmdb: Error updating CMDB Record")
            exit(1)
    return cmdb_response

def delete_cmdb(cmdb_server, cmdb_key):

    """
    Delete a CMDB Record. Assume name is unique, deletion happens using sys_id.
    """

    try:
        cmdb_records = cmdb_server.list({'name': cmdb_key})
    except ConnectionError, e:
        sys.stderr.write("cmdb_delete: Error Connecting to CMDB: %s\n" %e)
        exit(1)
    except ValueError:
        sys.stderr.write("cmdb_delete: Error Connecting to CMDB, likely a user or password issue.\n")
        exit(1)

    if len(cmdb_records['records']) == 0:
        sys.stderr.write("delete_cmdb: Record with name: %s does not exist, can not delete.\n" %cmdb_key)
        exit(0)
    elif len(cmdb_records['records']) == 1:
        sys.stderr.write("delete_cmdb: Record with name: %s found, deleting.\n" %cmdb_key)
        try:
            cmdb_response = cmdb_server.delete(cmdb_records['records'][0])
        except:
            sys.stderr.write("delete_cmdb: Error deleting CMDB Record")
            exit(1)
    else:
        print "delete_cmdb: Multiple records with name:" + cmdb_key + " found, not deleting."
        exit(1)
    return cmdb_response


def main():

    # Process Command Line Parameters
    parser = argparse.ArgumentParser(
             description='Create a CMDB Server Record in ServiceNow. ',
             epilog='')
    parser.add_argument("-l", "--sn_location", dest="sn_location", default='ALL', required=False)
    parser.add_argument("-u", "--sn_user", dest="sn_user", required=True)
    parser.add_argument("-p", "--sn_pass", dest="sn_pass", required=True)
    parser.add_argument("-i", "--sn_instance", dest="sn_instance", required=True)
    parser.add_argument("-k", "--cmdb_key", dest="cmdb_key", required=True)
    # cmdb record is variable and passed on the command line as a json string
    parser.add_argument("-r", "--cmdb_record", dest="cmdb_record", type=json.loads, required=False)
    # -c to add -d to delete
    group = parser.add_mutually_exclusive_group(required=True)
    group.add_argument('-c', '--create', default=False, action='store_true')
    group.add_argument('-d', '--delete', default=False, action='store_true')

    args = parser.parse_args()

    sn_instance = args.sn_instance
    sn_user = args.sn_user
    sn_pass = args.sn_pass
    sn_location = args.sn_location

    # Get connection object
    cmdb_conn = get_connection(sn_location, sn_instance, sn_user, sn_pass)

    #Get Server Object
    cmdb_server = ServiceNow.Server(cmdb_conn)

    #if not cmdb_server.list({'name': args.cmdb_key}):
    #  sys.stderr.write('cmdb_server: Error Connecting to CMDB.')
    #  exit(1)

    # Process Request
    if args.create:

        cmdb_record = args.cmdb_record
        cmdb_key = args.cmdb_key

        print 'Create CMDB Server Record....'
        print 'SN Instance: ' + args.sn_instance
        print 'SN User: ' + args.sn_user
        print 'SN Pass: ' + '*****'
        print 'CMDB Record Key: ' + cmdb_key
        print 'CMDB Record'

        cmdb_record = args.cmdb_record
        for key in cmdb_record:
            print '    ' + key + ': ' + cmdb_record[key]

        response = create_cmdb(cmdb_server, cmdb_key, cmdb_record)

    elif args.delete:

        cmdb_key = args.cmdb_key

        print 'Delete CMDB Server Record....'
        print 'SN Instance: ' + args.sn_instance
        print 'SN User: ' + args.sn_user
        print 'SN Pass: ' + '*****'
        print 'CMDB Record Key: ' + cmdb_key

        response = delete_cmdb(cmdb_server, cmdb_key)

    if response:
        exit(0)
    else:
        exit(1)

if __name__ == "__main__":
    main()
