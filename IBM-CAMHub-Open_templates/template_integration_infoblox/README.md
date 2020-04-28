# Infoblox Integration Template

This repo contains a Module to interact with an Infoblox server to get and return a IP address from the IPAM service.
[Infoblox](https://www.infoblox.com) is an industry leader in DNS, DHCP, and IP address management

## License

This code is released under the Apache 2.0 License. Please see [LICENSE](https://github.com/CAMHub-Open-Development/template_integration_infoblox) for more details.

Copyright IBM Corp. 2018


## Description

This template gets and returns an IP address from Infoblox via camc_scriptpackage. This template should be used to generated an IP Address for a Virtual Machine prior to creation.

## Integration Method

Local to the terraform container.

## Orchestration Reccomendation

This script should be executed before the a Virtual Machine is created

## Methods Implemented

- **on_create** Get an IP Address.
- **on_delete** Release an IP Address.

## Prerequisites

- A working version of  Infoblox addressable from the Terraform Engine.
- The Terraform container requires the **infoblox** module installed.
- The Terraform container requires that **python 2.7** is installed.

## Input Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>hostname</td>
    <td>The hostname to associate with the requested IP address.</td>
  </tr>
  <tr>
    <td>domain</td>
    <td>The domain name to associate with the host names on the requested IP address.</td>
  </tr>
  <tr>
    <td>infoblox_ip_address</td>
    <td>The IP address of the Infoblox server.</td>
  </tr>
  <tr>
    <td>infoblox_user</td>
    <td>The user name to access the Infoblox server.</td>
  </tr>
  <tr>
    <td>infoblox_user_password</td>
    <td>The user password to access the Infoblox server.</td>
  </tr>
  <tr>
    <td>network</td>
    <td>The network defined in Infoblox from which to get an IP address.</td>
  </tr>
</table>

## Output Parameters

<table>
  <tr>
    <th>Variable</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>assigned_ip_address</td>
    <td>The IP address assigned from Infoblox IPAM.</td>
  </tr>
  <tr>
    <td>associated_domain</td>
    <td>The domain associated with the assigned IP address.</td>
  </tr>
  <tr>
    <td>associated_hostname</td>
    <td>The hostname associated with the assigned IP address..</td>
  </tr>
</table>
