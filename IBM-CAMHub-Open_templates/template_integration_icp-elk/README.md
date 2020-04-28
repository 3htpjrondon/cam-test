# ELK Agent Installation Template
Copyright IBM Corp. 2018, 2018
This code is released under the Apache 2.0 License.

## Description

This integration template installs Filebeat on a deployed VM and registers it with the IBM Cloud Private ELK stack. The filebeat agent installer(filebeat-6.2.2-amd64.deb  filebeat-6.2.2-x86_64.rpm) must be available in the evironment and accessible via a URI (http/s, ftp, file). It is assumed that an ELK endpoint has been installed and accessible from the target VM.

## Integration Method

Script Remote, executes on the remote host.

## Orchestration Reccomendation

This template must be executed after the successful creation of a Virtual Machine via a Terraform Template.

## Methods Implemented

- **on_create** Installs and configures the filebeat agent. The agent is started after installation.
- **on_delete** Not implemented.

## Prerequisites

- The filebeat agent must be available and accessible via URI (filebeat-6.2.2-amd64.deb  or filebeat-6.2.2-x86_64.rpm). This value is controlled via the filebeat_source_url parameter.
- The installation occurs in the /tmp directory.

## Input Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>ipv4_address</td>
    <td>IPv4 address for vNIC configuration.</td>
  </tr>
  <tr>
    <td>os_admin_user</td>
    <td>Name of the admin user account in the virtual machine that will be accessed via SSH.</td>
  </tr>
  <tr>
    <td>os_admin_password</td>
    <td>Operating System Password for the Operating System User to access virtual machine.</td>
  </tr>
  <tr>
    <td>os_private_ssh_key</td>
    <td>perating System private key for the Operating System User to access virtual machine. The key should be base64 encoded.</td>
  </tr>
  <tr>
    <td>logstash_server_ip</td>
    <td>Logstash server IP address.</td>
  </tr>
  <tr>
    <td>logstash_server_port</td>
    <td>Logstash server port.</td>
  </tr>
  <tr>
    <td>filebeat_source_url</td>
    <td>HTTP URL of the filebeat installation package.</td>
  </tr>
  <tr>
    <td>filebeat_config_url</td>
    <td>HTTP URL of the filebeat configuration file. One of Filebeat package location and Monitored paths needs to be specified. Example file names, filebeat-6.2.2-amd64.deb  or filebeat-6.2.2-x86_64.rpm.</td>
  </tr>
  <tr>
    <td>monitored_paths</td>
    <td>Websphere run_as user.</td>
  </tr>
  <tr>
    <td>apm_dir</td>
    <td>List of files and directories to monitor with logstash. One of Filebeat package location and Monitored paths needs to be specified.</td>
  </tr>
</table>
