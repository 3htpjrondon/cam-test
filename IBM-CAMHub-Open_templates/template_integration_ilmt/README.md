# IBM License Metrics Tool Client Installation Template

(C) Copyright IBM Corp. 2018.
This code is released under the Apache 2.0 License.

## Description

This template will install the BigFix Agent and the masthead action site file on a target host.

## Integration Method

Script Remote, executes on the remote host.

## Orchestration Recommendation

This template must be executed after the successful creation of a Virtual Machine via a Terraform Template.

## Methods Implemented

- **on_create** Installs and registers the BigFix Agent.
- **on_delete** Not implemented.

## Prerequisites

- An installed IBM License Metrics Tool (ILMT) Server.
- The target host must be able to reach the ILMT Server.
- Get the URL of the BigFix installation package for your platform. For example, download the BigFix client for the target
  host's operating system from http://support.bigfix.com/bes/install/besclients-nonwindows.html and store it in the software
  repository of your Cloud Automation Manager content runtime at /opt/ibm/docker/software-repo/var/swRepo/public/bigfix.
- Get the actionsite.afxm file from your ILMT server
  (see https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Tivoli+Endpoint+Manager/page/Common+File+Locations)
  and store it at the same location.

## Input Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>IP address</td>
    <td>IP address of the host to install the BigFix Agent.</td>
  </tr>
  <tr>
    <td>Operating system user</td>
    <td>User ID to install the BigFix Agent. It must have sudo NOPASSWD set.</td>
  </tr>
  <tr>
    <td>Operating system password</td>
    <td>Password of the installation user.</td>
  </tr>
  <tr>
    <td>Operating system private key</td>
    <td>Private key of the installation user. It must be base64 encoded.</td>
  </tr>
  <tr>
    <td>BigFix agent source location</td>
    <td>Source for the BigFix Agent installer. For example, https://IP_ADDRESS:9999/bigfix.</td>
  </tr>
  <tr>
    <td>BigFix agent package name</td>
    <td>Name of the BigFix Agent package. Defaults to BESAgent-9.5.9.62-ubuntu10.amd64.deb.</td>
  </tr>
  <tr>
    <td>Name of actionsite file</td>
    <td>Name of the actionsite file. Defaults to actionsite.afxm.</td>
  </tr>
</table>
