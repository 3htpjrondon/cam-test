# Template - IBM DB2 Enterprise Server Edition V11.1 and WebSphere Application Server Network Deployment V9 on a single virtual machine
Template Version - 2.1

## Description

This template deploys IBM DB2 Enterprise Server Edition V11.1 and WebSphere Application Server Network Deployment V9 on a Linux virtual machine.<br>

## Features

### Clouds

 AWS<br>
<br>
### Operating Systems Supported

Red Hat Enterprise Linux 7<br>
Red Hat Enterprise Linux 6<br>
Ubuntu 16.04 LTS<br>
Ubuntu 14.04 LTS<br>
<br>
### Topology

1 virtual machine:<br>
  IBM DB2 Enterprise Server Edition - one instance, one database<br>
  IBM WebSphere Application Server Network Deployment - standalone server<br>
<br>
### Software Deployed

IBM DB2 Enterprise Server Edition V11.1<br>
IBM WebSphere Application Server Network Deployment V9<br>
<br>
### Default Virtual Machine Settings

 t2.large, vCPU 2, Mem (GiB) 8, EBS (GB) 100<br>
<br>
### Usage and Special Notes

1. The user is responsible for obtaining appropriate software licenses and downloads prior to template deployment.<br>
2. Detailed system requirements - <a href=\"https://www.ibm.com/software/reports/compatibility/clarity/index.html\" target=\"_blank\">https://www.ibm.com/software/reports/compatibility/clarity/index.html</a><br>
3. IBM Knowledge Center for DB2 V11.1 - <a href=\"https://www.ibm.com/support/knowledgecenter/en/SSEPGG_11.1.0\" target=\"_blank\">https://www.ibm.com/support/knowledgecenter/en/SSEPGG_11.1.0</a><br>
4. IBM Knowledge Center for WAS ND V9 - <a href=\"https://www.ibm.com/support/knowledgecenter/en/SSAW57_9.0.0\" target=\"_blank\">https://www.ibm.com/support/knowledgecenter/en/SSAW57_9.0.0</a><br>
5. IBM Support Portal - <a href=\"https://www.ibm.com/support/home/\" target=\"_blank\">https://www.ibm.com/support/home/</a><br>
<br>


## Overview

### License and Maintainer

Copyright IBM Corp. 2017, 2018 

### Target Cloud Type

Amazon EC2

### Software Deployed

- IBM DB2 Enterprise Server
- IBM WebSphere 

### Major Versions

- IBM DB2 Enterprise Server 10.5
- IBM DB2 Enterprise Server 11.1
- IBM WebSphere  8.5.5
- IBM WebSphere  9.0.0


### Minor Versions

- IBM DB2 Enterprise Server 10.5.0.3
- IBM DB2 Enterprise Server 10.5.0.9
- IBM DB2 Enterprise Server 11.1.2.2
- IBM WebSphere  8.5.5.12
- IBM WebSphere  9.0.0.4
- IBM WebSphere  9.0.0.6
- IBM WebSphere  9.0.0.8


*Note, these represent base versions only, explicit fixpacks may also be added.*

### Platforms Supported

The following Operating Systems are supported for software defined in this template.

- RHEL 6.x
- RHEL 7.x
- Ubuntu 14.0.4
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
    <td>DB2WASNode01</code></td>
    <td>db2_create_db</code></td>
    <td>Creates a new DB2 instance and database over an existing DB2 installation</code></td>
  </tr>
  <tr>
    <td>DB2WASNode01</code></td>
    <td>db2_v111_install</code></td>
    <td>DB2 v11.1 role for default installation and configuration</code></td>
  </tr>
  <tr>
    <td>DB2WASNode01</code></td>
    <td>was_v9_install</code></td>
    <td>Install WebSphere V9.0.0.x with Java 8 SDK</code></td>
  </tr>
  <tr>
    <td>DB2WASNode01</code></td>
    <td>was_create_standalone</code></td>
    <td>Create the standalone profile and start the server</code></td>
  </tr>
</table>


### Autoscaling Support

Nil

## Software Resource Minimal Requirements

The following is a summary of the minimal requirements available to the base operating system to support a successful deployment.

### IBM DB2 Enterprise Server
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

### IBM WebSphere 
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

### IBM DB2 Enterprise Server
<table>
  <tr>
    <td>/tmp/ibm_cloud</td>
    <td>1536</td>
  </tr>
  <tr>
    <td>/opt/ibm/db2</td>
    <td>500</td>
  </tr>
  <tr>
    <td>/var</td>
    <td>512</td>
  </tr>
  <tr>
    <td>/tmp</td>
    <td>2048</td>
  </tr>
</table>

### IBM WebSphere 
<table>
  <tr>
    <td>/opt/IBM/WebSphere/AppServer</td>
    <td>2048</td>
  </tr>
  <tr>
    <td>/tmp/ibm_cloud</td>
    <td>2048</td>
  </tr>
  <tr>
    <td>/var</td>
    <td>512</td>
  </tr>
  <tr>
    <td>/tmp</td>
    <td>2048</td>
  </tr>
</table>



## Software Repository Libraries

The following standard operating system libraries are required in the relevant Operating System library for each Operating System.

### IBM DB2 Enterprise Server
<table>
  <tr>
    <td>debian</td>
    <td>x86_64</td>
    <td>cpp, compat-libstdc++-33, gcc, gcc-c++, libaio, libstdc++, kernel-devel, ksh, nfs-utils, openssh, openssh-server, pam, redhat-lsb, sg3_utils</td>
  </tr>
  <tr>
    <td>redhat</td>
    <td>x86_64</td>
    <td>cpp, gcc, ksh, openssh-server, rpm, unzip, binutils, libaio1</td>
  </tr>
</table>

### IBM WebSphere 
<table>
  <tr>
    <td>debian</td>
    <td>x86_64</td>
    <td>libxtst6, libgtk2.0-bin, libxft2</td>
  </tr>
  <tr>
    <td>redhat</td>
    <td>x86_64</td>
    <td>compat-libstdc++-33, compat-db, ksh, gtk2, gtk2-engines, pam, rpm-build, elfutils, elfutils-libs, libXft, glibc, libgcc, nss-softokn-freebl, libXp, libXmu, libXtst, openssl, compat-libstdc++-296</td>
  </tr>
</table>



## Network Connectivity and Security Groups

Network connectivity is required from the deployed nodes to standard infrastructure. The following is a description of the network Ports required on each node based on the software deployed on that node.

### IBM DB2 Enterprise Server
<table>
  <tr>
    <td>DB2 Port</td>
    <td>50000</td>
  </tr>
  <tr>
    <td>FCM Port</td>
    <td>60000</td>
  </tr>
  <tr>
    <td>Min CPU</td>
    <td>1</td>
  </tr>
</table>

### IBM WebSphere 
<table>
  <tr>
    <td>CELL DISCOVERY ADDRESS Port</td>
    <td>7277</td>
  </tr>
  <tr>
    <td>DCS UNICASTADDRESS Port</td>
    <td>9352</td>
  </tr>
  <tr>
    <td>DataPowerMgr inbound secure Port</td>
    <td>5555</td>
  </tr>
  <tr>
    <td>OVERLAY TCP LISTENER ADDRESS Port</td>
    <td>11006</td>
  </tr>
  <tr>
    <td>SAS SSL SERVERAUTH LISTENER ADDRESS Port</td>
    <td>9401</td>
  </tr>
  <tr>
    <td>CSIV2 SSL MUTUALAUTH LISTENER ADDRESS Port</td>
    <td>9402</td>
  </tr>
  <tr>
    <td>CSIV2 SSL SERVERAUTH LISTENER ADDRESS Port</td>
    <td>9403</td>
  </tr>
  <tr>
    <td>XDAGENT PORT</td>
    <td>7060</td>
  </tr>
  <tr>
    <td>SOAP CONNECTOR ADDRESS Port</td>
    <td>8879</td>
  </tr>
  <tr>
    <td>WC adminhost Port</td>
    <td>9060</td>
  </tr>
  <tr>
    <td>IPC CONNECTOR ADDRESS Port</td>
    <td>9632</td>
  </tr>
  <tr>
    <td>STATUS LISTENER ADDRESS Port</td>
    <td>9420</td>
  </tr>
  <tr>
    <td>BOOTSTRAP ADDRESS Port</td>
    <td>9809</td>
  </tr>
  <tr>
    <td>ORB LISTENER ADDRESS Port</td>
    <td>9100</td>
  </tr>
  <tr>
    <td>OVERLAY UDP LISTENER ADDRESS Port</td>
    <td>11005</td>
  </tr>
  <tr>
    <td>WC adminhost secure Port</td>
    <td>9043</td>
  </tr>
  <tr>
    <td>Min CPU</td>
    <td>1</td>
  </tr>
</table>



# Software Repository Requirements

The following files are neccessary on the Software Repository to successfully install this product. Please refer to the document on managing software repositories for the correct method to load  and manage files on the Software Repository.


## IBM DB2 Enterprise Server

### Installation
<table>
  <tr>
    <th>Version</th>
    <th>Arch</th>
    <th>Repository Root</th>
    <th>File</th>
  </tr>
  <tr>
    <td>11</td>
    <td>X86_64</td>
    <td>/db2/v111/base</td>
    <td><br>DB2_Svr_11.0.0.0_Linux_linuxx64.tar.gz</br></td>
  </tr>
  <tr>
    <td>10</td>
    <td>X86_64</td>
    <td>/db2/v105/base</td>
    <td><br>DB2_Svr_10.5.0.8_Linux_linuxx64.tar.gz</br></td>
  </tr>
</table>

### Fixpack
<table>
  <tr>
    <th>Fixpack Version</th>
    <th>Arch</th>
    <th>Repository Root</th>
    <th>File</th>
  </tr>
  <tr>
    <td>10.5.0.9</td>
    <td>X86_64</td>
    <td>/db2/v105/maint</td>
    <td><br>DB2_Svr_10.5.0.9_Linux_linuxx64.tar.gz</br></td>
  </tr>
  <tr>
    <td>11.1</td>
    <td>X86_64</td>
    <td>/db2/v111/base</td>
    <td><br>DB2_Svr_11.1.2.2_Linux_linuxx64.tar.gz</br></td>
  </tr>
</table>

## IBM WebSphere 

### Installation
<table>
  <tr>
    <th>Version</th>
    <th>Arch</th>
    <th>Repository Root</th>
    <th>File</th>
  </tr>
  <tr>
    <td>8.5.5</td>
    <td>X86_64</td>
    <td>IM Repository File</td>
    <td><br>com.ibm.websphere.IHS.v85_8.5.5011.20161206_1434</br><br>com.ibm.websphere.ND.v85_8.5.5011.20161206_1434</br><br>com.ibm.websphere.PLG.v85_8.5.5011.20161206_1434</br><br>com.ibm.websphere.WCT.v85_8.5.5011.20161206_1434</br></td>
  </tr>
  <tr>
    <td>9.0.0</td>
    <td>X86_64</td>
    <td>IM Repository File</td>
    <td><br>com.ibm.websphere.BASE.v90_9.0.4.20170523_1327</br><br>com.ibm.websphere.IHS.v90_9.0.4.20170523_1327</br><br>com.ibm.websphere.ND.v90_9.0.4.20170523_1327</br><br>com.ibm.websphere.PLG.v90_9.0.4.20170523_1327</br><br>com.ibm.websphere.WCT.v90_9.0.4.20170523_1327</br></td>
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

