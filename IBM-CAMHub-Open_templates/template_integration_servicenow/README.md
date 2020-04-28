# ServiceNow CMDB Configuration Template
Copyright IBM Corp. 2018, 2018
This code is released under the Apache 2.0 License.


## Description

ServiceNow CMDB configuration record to add and remove CMDB records on create and delete of a server. This integration template is responsible for the create of a ServiceNow CMDB record and is designed to be chained after the creation of a server. Upon deletion of a server, the template will delete the CMDB record from ServiceNow.

## Integration Method

Local to the terraform container.

## Orchestration Recommendation

This script should be executed after the successful execution of a Terraform Template to register the Server Assets in CMDB.

## Methods Implemented

- **on_create** Create the CMDB Record or update the CMDB record if an existing record already exists.
- **on_delete** Delete the CMDB Record.

NOTE: On Plan/Apply, the on_delete method will not be executed.

## Prerequisites

- A working version of ServiceNow addressable from the Terraform Engine.
- The Terraform container requires the **servicenow** module installed.
- The Terraform container requires that **python 2.7** is installed.

## Input Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>cmdb_pass</td>
    <td>User to connect to ServiceNow</td>
  </tr>
  <tr>
    <td>cmdb_user</td>
    <td>Administrative user password.</td>
  </tr>
  <tr>
    <td>cmdb_instance</td>
    <td>Target ServiceNow instance.</td>
  </tr>
  <tr>
    <td>cmdb_key</td>
    <td>Key value for the Server, this may be the host name. THis field will realte to the cmdb_ci_server name field.</td>
  </tr>
  <tr>
    <td>cmdb_key</td>
    <td>Key value for the Server, this may be the host name. THis field will realte to the cmdb_ci_server name field.</td>
  </tr>
  <tr>
    <td>cmdb_record</td>
    <td>A MAP of values that constitute the CMDB Record. The structure is user defined and should follow the fields describe in the ServiceNow ci_cmdb_server record. The only mandatory value is the name field.</td>
  </tr>
</table>
