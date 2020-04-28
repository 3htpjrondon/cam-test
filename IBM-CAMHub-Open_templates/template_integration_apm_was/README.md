# APM Agent Installation Template
Copyright IBM Corp. 2018, 2018
This code is released under the Apache 2.0 License.

## Description

This template will configure IBM APM agents for WAS on a target node. APM Agents must have already been installed on this node with a minimal of the was and os agents installed. This template will configure the was agent on the target node.

## Integration Method

Script Remote, executes on the remote host.

## Orchestration Reccomendation

This template must be executed after the successful creation of a Virtual Machine via a Terraform Template.

## Methods Implemented

- **on_create** Configures the was agent, restarts all WebSphere Servers.
- **on_delete** Not implemented.

## Prerequisites

- The APM Agent must be pre-installed and the was agent enabled.
- WebSphere Application Server Administrtive server must be running.

## Input Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>ip_address</td>
    <td>IP Address of the HOST to install the APM Agent.</td>
  </tr>
  <tr>
    <td>user</td>
    <td>Userid to install the APM Agent, root reccomended.</td>
  </tr>
  <tr>
    <td>password</td>
    <td>Password of the installation user.</td>
  </tr>
  <tr>
    <td>private_key</td>
    <td>Private key of the installation user. This value should be base64 encoded.</td>
  </tr>
  <tr>
    <td>was_profile</td>
    <td>Default WebSphere Profile Name.</td>
  </tr>
  <tr>
    <td>was_home</td>
    <td>Base directory for the WebSphere Installation, eg, /opt/IBM/WebSphere/AppServer</td>
  </tr>
  <tr>
    <td>was_cell</td>
    <td>WebSphere Cell Name.</td>
  </tr>
  <tr>
    <td>was_node</td>
    <td>WebSphere Node Name.</td>
  </tr>
  <tr>
    <td>was_user</td>
    <td>Websphere run_as user.</td>
  </tr>
  <tr>
    <td>apm_dir</td>
    <td>APM Installation Directory, default = /opt/ibm/apm/agent.</td>
  </tr>
</table>
