<!---
Copyright IBM Corp. 2018, 2018
--->

# IBM Cloud Private Node

The IBM Cloud Private Node Terraform template and inline modules will provision several virtual machines, install prerequisites and add node to existing IBM Cloud Private product within you vmWare Hypervisor environment.

This template will install and configure the IBM Cloud Private in an HA topology.

The components of a IBM Cloud Private deployment include:

- Worker/Management/Proxy Nodes (1 to n Nodes)

For more infomation on IBM Cloud Private Nodes, please reference the Knowledge Center: <https://www.ibm.com/support/knowledgecenter/en/SSBS6K_2.1.0/getting_started/architecture.html>

## IBM Cloud Private Versions

| ICP Version | GitTag Reference|
|------|:-------------:|
| 2.1.0.3| 1.0|
| 3.1.0  | 1.0|
| 3.1.1  | 1.1|

<https://github.com/IBM-CAMHub-Open/template_icp_node>

## System Requirements

### Hardware requirements

IBM Cloud Private nodes must meet the following requirements:
<https://www.ibm.com/support/knowledgecenter/en/SSBS6K_3.1.0/supported_system_config/hardware_reqs.html>

This template will setup the following hardware minimum requirements:

| Node Type | CPU Cores | Memory (mb) | Disk 1 | Disk 2 | Number of hosts |
|------|:-------------:|:----:|:-----:|:-----:|:-----:|
| Worker  | 16 | 16384 | 200 | 300 | 1 |
| Management | 4 | 16384 | 200 | n/a | 1 |
| Proxy | 2 | 8192 | 200 | n/a | 1 |
| VA | 4 | 8192 | 100 | n/a | 1, 3 or 5 |

***Notes***
Disk 1: Base Disk Size on virtual machine
Disk 2: Additonal Disk on virtual Machine

- Worker Disk is for internal GlusterFS provision
- NFS Disk is for additional File Systems

### Supported operating systems and platforms

The following operating systems and platforms are supported.

***Ubuntu 16.04 LTS***

- VMware Tools must be enabled in the image for VMWare template.
- Ubuntu Repos with correct configuration must be enabled in the images.
- Sudo User and password must exist and be allowed for use.
- Firewall (via iptables) must be disabled.
- SELinux must be disabled.
- The system umask value must be set to 0022.

### Network Requirements

The following network information is required:
Based on the Standard setup:

- IP Address
  - 1 IP Address / node
- Netmask Bit Number eg 24
- Network Gateway
- Interface Name

## Template Variables

The following tables list the template variables.

### Cloud Input Variables

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| vsphere_datacenter |vSphere DataCenter Name| string |  |
| vsphere_resource_pool | vSphere Resource Pool | string |  |
| vm_network_interface_label | vSphere Port Group Name | string | `VM Network` |
| vm_folder | vSphere Folder Name | string |  |

### IBM Cloud Private Template Settings

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| vm_dns_servers | IBM Cloud Private DNS Servers | list | `<list>` |
| vm_dns_suffixes | IBM Cloud Private DNS Suffixes | list | `<list>` |
| vm_domain | IBM Cloud Private Domain Name | string | `ibm.com` |
| vm_os_user | Virtual Machine  Template User Name | string | `root` |
| vm_os_password | Virtual Machine Template User Password | string |  |
| vm_template | Virtual Machine Template Name | string |  |
| vm_disk1_datastore | Virtual Machine Datastore Name - Disk 1 | string |  |
| vm_disk2_datastore | Virtual Machine Datastore Name - Disk 2 | string |  |

### IBM Cloud Private add Worker Node Settings

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| worker_prefix_name | Worker Node Hostname Prefix | string | `ICPWorker` |
| worker_memory | Worker Node Memory Allocation (mb) | string | `16384` |
| worker_vcpu | Worker Node vCPU Allocation | string | `16` |
| worker_vm_disk1_size | Worker Node Disk Size (GB) | string | `200` |
| worker_vm_disk2_enable | Worker Node Enable - Disk 2 | string | `true` |
| worker_vm_disk2_size | Worker Node Disk Size (GB) - Disk 2 (Gluster FS) | string | `50` |
| worker_vm_ipv4_address | Worker Nodes IP Address's | list | `<list>` |
| worker_vm_ipv4_gateway |Worker Node IP Gateway  | string |  |
| worker_vm_ipv4_prefix_length | Worker Node IP Netmask (CIDR) | string | `24` |

### IBM Cloud Private add Management Node Input Settings

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| boot_prefix_name | Management Node Hostname Prefix | string | `ICPBoot` |
| boot_memory |  Management Node Memory Allocation (mb) | string | `16384` |
| boot_vcpu | Management Node vCPU Allocation | string | `4` |
| boot_vm_disk1_size | Management Node Disk Size (GB) | string | `200` |
| boot_vm_ipv4_address | Management Nodes IP Address | list | `<list>` |
| boot_vm_ipv4_gateway | Management Node IP Gateway | string |  |
| boot_vm_ipv4_prefix_length | Management Node IP Netmask (CIDR) | string | `24` |

### IBM Cloud Private add Proxy Node Input Settings

| Name | Description | Type | Default |
|------|-------------|:----:|:-----:|
| proxy_prefix_name | Proxy Node Hostname Prefix | string | `ICPProxy` |
| proxy_memory | Proxy Node Memory Allocation (mb) | string | `8192` |
| proxy_vcpu | Proxy Node vCPU Allocation | string | `2` |
| proxy_vm_disk1_size | Proxy Node Disk Size (GB) | string | `200` |
| proxy_vm_ipv4_address | Proxy Nodes IP Address's | list | `<list>` |
| proxy_vm_ipv4_gateway | Proxy Node IP Gateway | string |  |
| proxy_vm_ipv4_prefix_length | Proxy Node IP Netmask (CIDR)  | string | `24` |

## Template Output Variables

| Name | Description |
|------|-------------|
| ibm_cloud_private_admin_url | IBM Cloud Private Cluster URL |
