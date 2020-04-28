# Template - MySQL DB Deployment V5.7 on a single virtual machine
Template Version - 2.1

## Description

This template deploys Oracle MySQL V5.7 on a Linux virtual machine.<br>

## Features

### Clouds

 Amazon<br>
<br>
### Operating Systems Supported

Red Hat Enterprise Linux 7<br>
Ubuntu 16.04<br>
<br>
### Topology

1 virtual machine:<br>
  MySQL database<br>
<br>
### Software Deployed

Oracle MySQL V5.7<br>
<br>
### Default Virtual Machine Settings

 t2.medium, vCPU 2, Mem (GiB) 4, EBS (GB) 100<br>
<br>
### Usage and Special Notes

1. The user is responsible for obtaining appropriate software licenses and downloads prior to template deployment.<br>
2. Detailed system requirements for Oracle Database V5.7 - <a href=\"https://dev.mysql.com/doc/refman/5.7/en/\" target=\"_blank\">https://dev.mysql.com/doc/refman/5.7/en/</a><br>
<br>


## Overview

### License and Maintainer

Copyright IBM Corp. 2017, 2018

### Target Cloud Type

Amazon EC2

### Software Deployed

- Oracle MySQL

### Major Versions

- Oracle MySQL 5.7


### Minor Versions

- Oracle MySQL 5.7.17


*Note, these represent base versions only, explicit fixpacks may also be added.*

### Platforms Supported

The following Operating Systems are supported for software defined in this template.

- RHEL 6.x
- RHEL 7.x
- Ubuntu 14.0.x
- Ubuntu 16.0.x


### Nodes Description

The following table describes the nodes and relevant software component deployed on each node.

<table>
  <tr>
    <th>Node Name</th>
    <th>Component</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>MySQLNode01</code></td>
    <td>oracle_mysql_base</code></td>
    <td>Base install of Oracle Mysql</code></td>
  </tr>
</table>


### Autoscaling Support

Nil

## Software Resource Minimal Requirements

The following is a summary of the minimal requirements available to the base operating system to support a successful deployment.

### Oracle MySQL
<table>
  <tr>
    <td>Internal Firewall</td>
    <td>off</td>
  </tr>
  <tr>
    <td>Min Disk</td>
    <td>20GB</td>
  </tr>
  <tr>
    <td>Min CPU</td>
    <td>1</td>
  </tr>
  <tr>
    <td>Remote Root Access</td>
    <td>yes</td>
  </tr>
  <tr>
    <td>Min Memory</td>
    <td>1024</td>
  </tr>
</table>



## Disk Requirements

The following lists on a per-product basis the minimal reccomended disk required for each product installed.

### Oracle MySQL
<table>
  <tr>
    <td>/tmp/ibm_cloud</td>
    <td>512</td>
  </tr>
  <tr>
    <td>/var/lib/mysql</td>
    <td>512</td>
  </tr>
  <tr>
    <td>/var</td>
    <td>512</td>
  </tr>
  <tr>
    <td>/tmp</td>
    <td>512</td>
  </tr>
</table>



## Software Repository Libraries

The following standard operating system libraries are required in the relevant Operating System library for each Operating System.

### Oracle MySQL
<table>
  <tr>
    <td>debian</td>
    <td>x86_64</td>
    <td>libmecab, libaio1</td>
  </tr>
  <tr>
    <td>redhat</td>
    <td>x86_64</td>
    <td>libmecab, libaio1</td>
  </tr>
</table>



## Network Connectivity and Security Groups

Network connectivity is required from the deployed nodes to standard infrastructure. The following is a description of the network Ports required on each node based on the software deployed on that node.

### Oracle MySQL
<table>
  <tr>
    <td>MySQL Port</td>
    <td>3306</td>
  </tr>
</table>



# Software Repository Requirements

The following files are neccessary on the Software Repository to successfully install this product. Please refer to the document on managing software repositories for the correct method to load  and manage files on the Software Repository.


## Oracle MySQL

### Installation
<table>
  <tr>
    <th>Version</th>
    <th>Arch</th>
    <th>Repository Root</th>
    <th>File</th>
  </tr>
  <tr>
    <td>5.7.17</td>
    <td>RHEL 6.x</td>
    <td>/oracle/mysql/v5.7.17/base</td>
    <td><br>mysql-5.7.17-1.el6.x86_64.rpm-bundle.tar</br></td>
  </tr>
  <tr>
    <td>5.7.17</td>
    <td>RHEL 7.x</td>
    <td>/oracle/mysql/v5.7.17/base</td>
    <td><br>mysql-5.7.17-1.el7.x86_64.rpm-bundle.tar</br></td>
  </tr>
  <tr>
    <td>5.7.17</td>
    <td>Ubuntu 14.x</td>
    <td>/oracle/mysql/v5.7.17/base</td>
    <td><br>mysql-server_5.7.17-1ubuntu14.04_amd64.deb-bundle.tar</br></td>
  </tr>
  <tr>
    <td>5.7.17</td>
    <td>Ubuntu 16.x</td>
    <td>/oracle/mysql/v5.7.17/base</td>
    <td><br>mysql-server_5.7.17-1ubuntu16.10_amd64.deb-bundle.tar</br></td>
  </tr>
</table>


# Cloud Specific Requirements

The following is required prior to deploying the template on the target cloud. These details will either be required by the deployer or injected by the platform at runtime.

<table>
  <tr>
    <th>Terraform Provider Variable</th>
    <th>Terraform Provider Variable Description.</th>
  </tr>
  <tr>
    <td>access_key</td>
    <td>The AWS API access key used to connect to Amazon EC2</td>
  </tr>
  <tr>
    <td>secret_key</code></td>
    <td>The AWS Secret Key associated with the API User</td>
  </tr>
  <tr>
    <td>region</code></td>
    <td>The AWS region which you wish to connect to.</td>
  </tr>
</table>

These variables are typically defined when creating a Cloud Connection.
