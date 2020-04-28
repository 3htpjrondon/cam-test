# IBM Cloud App Management Agent Installation Template
Copyright IBM Corp. 2018, 2018
This code is released under the Apache 2.0 License.

## Description

This template will install the IBM Cloud App Management agent on a target host.

## Integration Method

Script Remote, executes on the remote host.

## Orchestration Reccomendation

 - This template must be executed after the successful creation of a Virtual Machine via a Terraform Template. 
 - The agent binaries can be retrieved from an unsecured URL (HTTP server) or secured location (recommended), like artifactory. Secured location credentials need to be provided in a format copatible with `curl -u` syntax, i.e. username:password.
 - The agent binary details (location, credentials to access it over https, internal structure, etc) are captured in a data type named `ibm_cloud_app_management_agent`. A CAM data object implementing this data typs is required for the agent deployment. The data type can be imported by running this POST API:
 `https://<YOUR_CAM_IP>:30000/cam/api/v1/datatypes?tenantId=<YOUR_TENANT_ID>`. The body of the request can be found under other/terraform/datatypes/ibm_cloud_app_management_agent.json . Make sure you replace the tenant_id in the sample body with the actual tenant ID.

## Methods Implemented

- **on_create** Installs and registers the IBM Cloud App Management Agent.
- **on_delete** Uninstalls the IBM Cloud App Management Agent.

## Prerequisites

- An installed IBM Cloud App Management Server, the location details should be pre-filled in the agent .tar file.
- The IBM Cloud App Management Agent tar file (configured_app_mgmt_agents_xlinux_2018.2.0.tar file or equivalent), stored on a URL reachable location, for example artifactory or a HTTP Server. 
- The target server must be able to reach the IBM Cloud App Management Server.
- The target server must have greater than **4GB availible** in /tmp.
- The target server must have remote logins enabled.

## Input Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>ip_address</td>
    <td>IP Address of the target server.</td>
  </tr>
  <tr>
    <td>user</td>
    <td>User on the target server to execute the installation.</td>
  </tr>
  <tr>
    <td>password</td>
    <td>Password of the user.</td>
  </tr>
  <tr>
    <td>private_key</td>
    <td>base64 encoded private key used to connect to the target server. If user/password are provided, the private key is not required.</td>
  </tr>

  <tr>
    <td>icam_agent_location</td>
    <td>Source for the IBM Cloud App Management Agent installer, eg http://IP_ADDRESS:8888/APP_MGMT_Agent_Install_2018.2.0</td>
  </tr>
  
  <tr>
    <td>icam_agent_location_credentials</td>
    <td>IBM Cloud App Management agent location credentials. Credentials need to be provided in a format copatible with `curl -u` syntax, i.e. username:password. Credentials are not required if the agent binary is retreieved from an unsecured location, e.g HTTP server</td>
  </tr>

  <tr>
    <td>icam_agent_source_subdir</td>
    <td>Name of the subdir within the tar file that the installer is located in, eg, APMADV_Agent_Install_8.1.4.0.1</td>
  </tr>
  <tr>
    <td>icam_agent_installation_dir</td>
    <td>IBM Cloud App Management agent installation directory, default = /opt/ibm/apm/agent.</td>
  </tr>
  <tr>
    <td>icam_agent_name</td>
    <td>IBM Cloud App Management agent to install, eg, os.</td>
  </tr>
</table>
