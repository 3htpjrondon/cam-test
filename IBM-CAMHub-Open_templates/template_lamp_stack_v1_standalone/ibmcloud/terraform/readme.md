# Template - LAMP Deployment on a single virtual machine
Template Version - 2.1

## Description

This template deploys Oracle MySQL Database V5.7 and Apache HTTP Server V2.4 on a Linux virtual machine.<br>

## Features

### Clouds

 IBM<br>
<br>
### Operating Systems Supported

Red Hat Enterprise Linux 7<br>
Ubuntu 16.04<br>
<br>
### Topology

1 virtual machine:<br>
 MySQL DB<br>
   odb instance 1, 1 database<br>
 Apache HTTP Server<br>
<br>
### Software Deployed

Apache HTTP Server Version V2.4, with PHP Module<br>
Oracle MySQL V5.7<br>
<br>
### Default Virtual Machine Settings

 Cores 2, RAM (GB) 4, SAN Disk (GB) 100<br>
<br>
### Usage and Special Notes

1. The user is responsible for obtaining appropriate software licenses and downloads prior to template deployment.<br>
2. Detailed system requirements for Oracle Database V5.7 - <a href=\"https://dev.mysql.com/doc/refman/5.7/en/\" target=\"_blank\">https://dev.mysql.com/doc/refman/5.7/en/</a><br>
3. Detailed system requirements for Apache HTTP Server - <a href=\"https://projects.apache.org/project.html?httpd-http_server\" target=\"_blank\">https://projects.apache.org/project.html?httpd-http_server</a><br>
<br>


## Overview

### License and Maintainer

Copyright IBM Corp. 2017, 2018 

### Target Cloud Type

IBM

### Software Deployed

- Oracle MySQL
- Apache HTTPd

### Major Versions

- Oracle MySQL 5.7
- Apache HTTPd 2.4


### Minor Versions

- Oracle MySQL 5.7.17
- Apache HTTPd 2.4.6


*Note, these represent base versions only, explicit fixpacks may also be added.*

### Platforms Supported

The following Operating Systems are supported for software defined in this template.

- RHEL 6.x
- RHEL 7.x
- Ubuntu 14.0.x
- Ubuntu 16.0.x
- RHEL 6.x
- RHEL 7.x
- Ubuntu 14.x
- Ubuntu 16.x


### Nodes Description

The following table describes the nodes and relevant software component deployed on each node.

<table>
  <tr>
    <th>Node Name</th>
    <th>Component</th>
    <th>Description</th>
  </tr>
  <tr>
    <td>LAMPNode01</code></td>
    <td>oracle_mysql_base</code></td>
    <td>Base install of Oracle Mysql</code></td>
  </tr>
  <tr>
    <td>LAMPNode01</code></td>
    <td>httpd24-base-install</code></td>
    <td></code></td>
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

### Apache HTTPd
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

### Apache HTTPd
<table>
  <tr>
    <td>/var</td>
    <td>1024</td>
  </tr>
  <tr>
    <td>/tmp/ibm_cloud</td>
    <td>1024</td>
  </tr>
  <tr>
    <td>/tmp</td>
    <td>1024</td>
  </tr>
  <tr>
    <td>/opt/tomcat</td>
    <td>1024</td>
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

### Apache HTTPd
<table>
  <tr>
    <td>Debian</td>
    <td>x86_64</td>
    <td>python3-openssl, openssl, net-tools</td>
  </tr>
  <tr>
    <td>Redhat</td>
    <td>x86_64</td>
    <td>pyOpenSSL, openssl, net-tools</td>
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

### Apache HTTPd
<table>
  <tr>
    <td>Http Port</td>
    <td>8080</td>
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
    <td><br>mysql-5.7.17-1ubuntu14.04_amd64.deb-bundle.tar</br></td>
  </tr>
  <tr>
    <td>5.7.17</td>
    <td>Ubuntu 16.x</td>
    <td>/oracle/mysql/v5.7.17/base</td>
    <td><br>mysql-5.7.17-1ubuntu16.04_amd64.deb-bundle.tar</br></td>
  </tr>
</table>

## Apache HTTPd

### Installation
<table>
  <tr>
    <th>Version</th>
    <th>Arch</th>
    <th>Repository Root</th>
    <th>File</th>
  </tr>
  <tr>
    <td>2.4</td>
    <td>Redhat X86_64</td>
    <td>Installed from Package Repository</td>
    <td><br>httpd</br><br>httpd-tools</br><br>php</br><br>php-mysql</br></td>
  </tr>
  <tr>
    <td>2.4</td>
    <td>Debian X86_64</td>
    <td>Installed from Package Repository</td>
    <td><br>apache2</br><br>apache2-utils</br><br>php</br><br>libapache2-mod-php</br><br>php-mcrypt</br></td>
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
    <td>softlayer_username</td>
    <td>The API Username used to connect to IBM Softlayer</td>
  </tr>
  <tr>
    <td>softlayer_api_key</code></td>
    <td>The Softlayer API Key associated with the API User</td>
  </tr>
  <tr>
    <td>softlayer_endpoint_url</code></td>
    <td>The URL Associated with the Softlayer connection</td>
  </tr>
</table>

These variables are typically defined when creating a Cloud Connection.

