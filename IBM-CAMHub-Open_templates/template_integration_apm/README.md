# APM Agent Installation Template
Copyright IBM Corp. 2018, 2018
This code is released under the Apache 2.0 License.

## Description

This template will install the IBM Application Performance Management Agent on a target host. The agents enabled is dependant on the apm_agents parameter, only those that are automatically configured will be configured. A seperate Integration Template must be called to configure specific agents such as was.

## Integration Method

Script Remote, executes on the remote host.

## Orchestration Reccomendation

This template must be executed after the successful creation of a Virtual Machine via a Terraform Template.

## Methods Implemented

- **on_create** Installs and registers the APM Agent.
- **on_delete** Not implemented.

## Prerequisites

- An installed APM Server, the location details should be pre-filled in the APMADV_Agent_Install.tar file.
- The APMADV_Agent_Install.tar file or equivalent, stored on a URL reachable location, for example, a HTTP Server. This file may be generate from the Server or distributed with an SAAS APM Offering.
- The target server must be able to reach APM Server.
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
    <td>apm_method</td>
    <td>URI type for download, http reccomended.</td>
  </tr>
  <tr>
    <td>apm_location</td>
    <td>Source for the APM Agent installer, eg http://IP_ADDRESS:8888/apm-agent/APMADV_Agent_Install.tar</td>
  </tr>
  <tr>
    <td>apm_source_subdir</td>
    <td>Name of the subdir within the tar file that the installer is located in, eg, APMADV_Agent_Install_8.1.4.0.1</td>
  </tr>
  <tr>
    <td>apm_dir</td>
    <td>APM Installation Directory, default = /opt/ibm/apm/agent.</td>
  </tr>
  <tr>
    <td>apm_agents</td>
    <td>List of APM agents to install, eg, os.</td>
  </tr>
</table>
