#!/bin/bash
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

# set -x

# Get script parameters
while test $# -gt 0; do
  [[ $1 =~ ^-u|--user ]] && { PARAM_USER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-p|--password ]] && { PARAM_PASSWORD="${2}"; shift 2; continue; };
  [[ $1 =~ ^-i|--ipamip ]] && { PARAM_IPAMIP="${2}"; shift 2; continue; };
  [[ $1 =~ ^-h|--hostnameip ]] && { PARAM_HOSTNAME_IP="${2}"; shift 2; continue; };
  break;
done

curerespo=`curl -k \
                 -u ${PARAM_USER}:${PARAM_PASSWORD}  \
                 -H 'content-type: application/json' \
                 -X GET "https://${PARAM_IPAMIP}/wapi/v2.6.1/ipv4address?ip_address=${PARAM_HOSTNAME_IP}&_return_as_object=1"`

echo $curerespo
network_ref=`echo $curerespo | jq -r '.result[0] ._ref'`
echo $network_ref

delete_resp=`curl -k \
                 -u ${PARAM_USER}:${PARAM_PASSWORD}  \
                 -H 'content-type: application/json' \
                 -X DELETE "https://${PARAM_IPAMIP}/wapi/v2.6.1/${network_ref}&_return_as_object=1"`
