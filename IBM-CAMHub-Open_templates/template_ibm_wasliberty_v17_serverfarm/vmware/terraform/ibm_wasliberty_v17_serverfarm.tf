# =================================================================
# Copyright 2017 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

# This is a terraform generated template generated from ibm_wasliberty_v17_serverfarm

##############################################################
# Keys - CAMC (public/private) & optional User Key (public)
##############################################################
variable "user_public_ssh_key" {
  type        = "string"
  description = "User defined public SSH key used to connect to the virtual machine. The format must be in openSSH."
  default     = "None"
}

variable "ibm_stack_id" {
  description = "A unique stack id."
}

variable "ibm_pm_public_ssh_key" {
  description = "Public CAMC SSH key value which is used to connect to a guest, used on VMware only."
}

variable "ibm_pm_private_ssh_key" {
  description = "Private CAMC SSH key (base64 encoded) used to connect to the virtual guest."
}

variable "allow_unverified_ssl" {
  description = "Communication with vsphere server with self signed certificate"
  default     = "true"
}

##############################################################
# Define the vsphere provider
##############################################################
provider "vsphere" {
  allow_unverified_ssl = "${var.allow_unverified_ssl}"
  version              = "~> 1.3"
}

provider "camc" {
  version = "~> 0.2"
}

##############################################################
# Define pattern variables
##############################################################
##### unique stack name #####
variable "ibm_stack_name" {
  description = "A unique stack name."
}

##############################################################
# Vsphere data for provider
##############################################################
data "vsphere_datacenter" "CentralNode01_datacenter" {
  name = "${var.CentralNode01_datacenter}"
}

data "vsphere_datastore" "CentralNode01_datastore" {
  name          = "${var.CentralNode01_root_disk_datastore}"
  datacenter_id = "${data.vsphere_datacenter.CentralNode01_datacenter.id}"
}

data "vsphere_resource_pool" "CentralNode01_resource_pool" {
  name          = "${var.CentralNode01_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.CentralNode01_datacenter.id}"
}

data "vsphere_network" "CentralNode01_network" {
  name          = "${var.CentralNode01_network_interface_label}"
  datacenter_id = "${data.vsphere_datacenter.CentralNode01_datacenter.id}"
}

data "vsphere_virtual_machine" "CentralNode01_template" {
  name          = "${var.CentralNode01-image}"
  datacenter_id = "${data.vsphere_datacenter.CentralNode01_datacenter.id}"
}

##############################################################
# Vsphere data for provider
##############################################################
data "vsphere_datacenter" "LibertyNode01_datacenter" {
  name = "${var.LibertyNode01_datacenter}"
}

data "vsphere_datastore" "LibertyNode01_datastore" {
  name          = "${var.LibertyNode01_root_disk_datastore}"
  datacenter_id = "${data.vsphere_datacenter.LibertyNode01_datacenter.id}"
}

data "vsphere_resource_pool" "LibertyNode01_resource_pool" {
  name          = "${var.LibertyNode01_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.LibertyNode01_datacenter.id}"
}

data "vsphere_network" "LibertyNode01_network" {
  name          = "${var.LibertyNode01_network_interface_label}"
  datacenter_id = "${data.vsphere_datacenter.LibertyNode01_datacenter.id}"
}

data "vsphere_virtual_machine" "LibertyNode01_template" {
  name          = "${var.LibertyNode01-image}"
  datacenter_id = "${data.vsphere_datacenter.LibertyNode01_datacenter.id}"
}

##### CentralNode01 variables #####
#Variable : CentralNode01-image
variable "CentralNode01-image" {
  type        = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
}

#Variable : CentralNode01-name
variable "CentralNode01-name" {
  type        = "string"
  description = "Short hostname of virtual machine"
}

#Variable : CentralNode01-os_admin_user
variable "CentralNode01-os_admin_user" {
  type        = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : CentralNode01_ssh_private_key_path
variable "CentralNode01_ssh_private_key_path" {
  type        = "string"
  description = "Absolute path of the Liberty private key"
  default     = "/root/.ssh/CAMkey.pem"
}

#Variable : CentralNode01_was_liberty_base_version
variable "CentralNode01_was_liberty_base_version" {
  type        = "string"
  description = "The release and fixpack level for WebSphere Liberty to be installed. Example formats are 8.5.5.11 or 18.0.2"
  default     = "18.0.2"
}

#Variable : CentralNode01_was_liberty_edition
variable "CentralNode01_was_liberty_edition" {
  type        = "string"
  description = "Indicates which Liberty offering should be installed. Valid values are: base, core, nd"
  default     = "base"
}

#Variable : CentralNode01_was_liberty_farm_central_node
variable "CentralNode01_was_liberty_farm_central_node" {
  type        = "string"
  description = "Hostname/IP of the liberty node which will gather and merge the plugins. Leave empty when deploying the central node itself"
}

#Variable : CentralNode01_was_liberty_farm_logFileName
variable "CentralNode01_was_liberty_farm_logFileName" {
  type        = "string"
  description = "Name of the Liberty farm log file"
  default     = "serverfarm.log"
}

#Variable : CentralNode01_was_liberty_farm_pluginInstallRoot
variable "CentralNode01_was_liberty_farm_pluginInstallRoot" {
  type        = "string"
  description = "pluginInstallRoot"
  default     = "plugin_install_root"
}

#Variable : CentralNode01_was_liberty_farm_sslCertlabel
variable "CentralNode01_was_liberty_farm_sslCertlabel" {
  type        = "string"
  description = "Name of the ssl Cert label which will be added to the keystore"
  default     = "definedbyuser"
}

#Variable : CentralNode01_was_liberty_farm_sslKeyringLocation
variable "CentralNode01_was_liberty_farm_sslKeyringLocation" {
  type        = "string"
  description = "Full path to the liberty farm ssl Keyring, path must not include the name of the Keyring file"
  default     = "/tmp/liberty/sslkeyring"
}

#Variable : CentralNode01_was_liberty_farm_sslStashfileLocation
variable "CentralNode01_was_liberty_farm_sslStashfileLocation" {
  type        = "string"
  description = "Full path to the Liberty farm ssl Stashfile, path must not include the name of the stash file"
  default     = "/tmp/liberty/stashfile"
}

#Variable : CentralNode01_was_liberty_farm_webserverName
variable "CentralNode01_was_liberty_farm_webserverName" {
  type        = "string"
  description = "A descriptive name for the web server"
  default     = "websrv"
}

#Variable : CentralNode01_was_liberty_farm_webserverPort
variable "CentralNode01_was_liberty_farm_webserverPort" {
  type        = "string"
  description = "HTTP Transport port that the webserver is listening on"
  default     = "88"
}

#Variable : CentralNode01_was_liberty_install_dir
variable "CentralNode01_was_liberty_install_dir" {
  type        = "string"
  description = "The installation root directory for the WebSphere Liberty product binaries"
  default     = "/opt/IBM/WebSphere/Liberty"
}

#Variable : CentralNode01_was_liberty_install_grp
variable "CentralNode01_was_liberty_install_grp" {
  type        = "string"
  description = "Operating system group name that will be assigned to the product installation"
  default     = "root"
}

#Variable : CentralNode01_was_liberty_install_user
variable "CentralNode01_was_liberty_install_user" {
  type        = "string"
  description = "Operating system userid that will be used to install the product. Userid will be created if it does not exist"
  default     = "root"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_feature
variable "CentralNode01_was_liberty_liberty_servers_server1_feature" {
  type        = "string"
  description = "Lists the Liberty features that should be included in the feature manager list. For example, webProfile-7.0 adminCenter-1.0"
  default     = "webProfile-7.0 adminCenter-1.0"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_httpport
variable "CentralNode01_was_liberty_liberty_servers_server1_httpport" {
  type        = "string"
  description = "HTTP Transport value that will be set in the defaultHttpEndpoint endpoint in server.xml"
  default     = "9080"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_httpsport
variable "CentralNode01_was_liberty_liberty_servers_server1_httpsport" {
  type        = "string"
  description = "Secure HTTP Transport value that will be set in the defaultHttpEndpoint endpoint in server.xml"
  default     = "9443"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_keystore_id
variable "CentralNode01_was_liberty_liberty_servers_server1_keystore_id" {
  type        = "string"
  description = "Keystore id that will be used when setting up the keyStore attribute in the server.xml"
  default     = "defaultKeyStore"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_keystore_password
variable "CentralNode01_was_liberty_liberty_servers_server1_keystore_password" {
  type        = "string"
  description = "Liberty keystore password used to protect the Liberty keystore id, this value will be stored in Chef Vault"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_name
variable "CentralNode01_was_liberty_liberty_servers_server1_name" {
  type        = "string"
  description = "Name of the initial Liberty server to be created during provisioning"
  default     = "defaultServer"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_name
variable "CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_name" {
  type        = "string"
  description = "Administrative console username used for accessing the console, the associated password is the admin_user password"
  default     = "admin"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_password
variable "CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_password" {
  type        = "string"
  description = "Password for the Liberty administrative user name, this value to be stored in the Chef Vault"
}

#Variable : CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_role
variable "CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_role" {
  type        = "string"
  description = "Liberty role for which administrative users are to be added to, the admin_user will be added to this role by default"
  default     = "admin"
}

#Variable : CentralNode01_was_liberty_runas_user
variable "CentralNode01_was_liberty_runas_user" {
  type        = "string"
  description = "Operating system userid that will be used to run the product. Userid will be created if it does not exist"
  default     = "root"
}

#Variable : CentralNode01_was_liberty_wlp_user_dir
variable "CentralNode01_was_liberty_wlp_user_dir" {
  type        = "string"
  description = "Liberty directory which product configuration will be written"
  default     = "/opt/IBM/WebSphere/Liberty/usr"
}

##### Environment variables #####
#Variable : ibm_im_repo
variable "ibm_im_repo" {
  type        = "string"
  description = "IBM Software  Installation Manager Repository URL (https://<hostname/IP>:<port>/IMRepo) "
}

#Variable : ibm_im_repo_password
variable "ibm_im_repo_password" {
  type        = "string"
  description = "IBM Software  Installation Manager Repository Password"
}

#Variable : ibm_im_repo_user
variable "ibm_im_repo_user" {
  type        = "string"
  description = "IBM Software  Installation Manager Repository username"
  default     = "repouser"
}

#Variable : ibm_pm_access_token
variable "ibm_pm_access_token" {
  type        = "string"
  description = "IBM Pattern Manager Access Token"
}

#Variable : ibm_pm_service
variable "ibm_pm_service" {
  type        = "string"
  description = "IBM Pattern Manager Service"
}

#Variable : ibm_sw_repo
variable "ibm_sw_repo" {
  type        = "string"
  description = "IBM Software Repo Root (https://<hostname>:<port>)"
}

#Variable : ibm_sw_repo_password
variable "ibm_sw_repo_password" {
  type        = "string"
  description = "IBM Software Repo Password"
}

#Variable : ibm_sw_repo_user
variable "ibm_sw_repo_user" {
  type        = "string"
  description = "IBM Software Repo Username"
  default     = "repouser"
}

##### Image Parameters variables #####

##### LibertyNode01 variables #####
#Variable : LibertyNode01-image
variable "LibertyNode01-image" {
  type        = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
}

#Variable : LibertyNode01-name
variable "LibertyNode01-name" {
  type        = "string"
  description = "Short hostname of virtual machine"
}

#Variable : LibertyNode01-os_admin_user
variable "LibertyNode01-os_admin_user" {
  type        = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : LibertyNode01_ssh_private_key_path
variable "LibertyNode01_ssh_private_key_path" {
  type        = "string"
  description = "Absolute path of the Liberty private key"
  default     = "/root/.ssh/CAMkey.pem"
}

#Variable : LibertyNode01_was_liberty_base_version
variable "LibertyNode01_was_liberty_base_version" {
  type        = "string"
  description = "The release and fixpack level for WebSphere Liberty to be installed. Example formats are 8.5.5.11 or 18.0.2"
  default     = "18.0.2"
}

#Variable : LibertyNode01_was_liberty_edition
variable "LibertyNode01_was_liberty_edition" {
  type        = "string"
  description = "Indicates which Liberty offering should be installed. Valid values are: base, core, nd"
  default     = "base"
}

#Variable : LibertyNode01_was_liberty_farm_central_node
variable "LibertyNode01_was_liberty_farm_central_node" {
  type        = "string"
  description = "Hostname/IP of the liberty node which will gather and merge the plugins. Leave empty when deploying the central node itself"
}

#Variable : LibertyNode01_was_liberty_farm_httpd_user
variable "LibertyNode01_was_liberty_farm_httpd_user" {
  type        = "string"
  description = "None"
}

#Variable : LibertyNode01_was_liberty_farm_logFileName
variable "LibertyNode01_was_liberty_farm_logFileName" {
  type        = "string"
  description = "Name of the Liberty farm log file"
  default     = "serverfarm.log"
}

#Variable : LibertyNode01_was_liberty_farm_pluginInstallRoot
variable "LibertyNode01_was_liberty_farm_pluginInstallRoot" {
  type        = "string"
  description = "pluginInstallRoot"
  default     = "plugin_install_root"
}

#Variable : LibertyNode01_was_liberty_farm_sslCertlabel
variable "LibertyNode01_was_liberty_farm_sslCertlabel" {
  type        = "string"
  description = "Name of the ssl Cert label which will be added to the keystore"
  default     = "definedbyuser"
}

#Variable : LibertyNode01_was_liberty_farm_sslKeyringLocation
variable "LibertyNode01_was_liberty_farm_sslKeyringLocation" {
  type        = "string"
  description = "Full path to the liberty farm ssl Keyring, path must not include the name of the Keyring file"
  default     = "/tmp/liberty/sslkeyring"
}

#Variable : LibertyNode01_was_liberty_farm_sslStashfileLocation
variable "LibertyNode01_was_liberty_farm_sslStashfileLocation" {
  type        = "string"
  description = "Full path to the Liberty farm ssl Stashfile, path must not include the name of the stash file"
  default     = "/tmp/liberty/stashfile"
}

#Variable : LibertyNode01_was_liberty_farm_webserverName
variable "LibertyNode01_was_liberty_farm_webserverName" {
  type        = "string"
  description = "A descriptive name for the web server"
  default     = "websrv"
}

#Variable : LibertyNode01_was_liberty_farm_webserverPort
variable "LibertyNode01_was_liberty_farm_webserverPort" {
  type        = "string"
  description = "HTTP Transport port that the webserver is listening on"
  default     = "88"
}

#Variable : LibertyNode01_was_liberty_farm_webserverhost
variable "LibertyNode01_was_liberty_farm_webserverhost" {
  type        = "string"
  description = "Host name of the web server, not this DNS name must be resolvable"
}

#Variable : LibertyNode01_was_liberty_install_dir
variable "LibertyNode01_was_liberty_install_dir" {
  type        = "string"
  description = "The installation root directory for the WebSphere Liberty product binaries"
  default     = "/opt/IBM/WebSphere/Liberty"
}

#Variable : LibertyNode01_was_liberty_install_grp
variable "LibertyNode01_was_liberty_install_grp" {
  type        = "string"
  description = "Operating system group name that will be assigned to the product installation"
  default     = "root"
}

#Variable : LibertyNode01_was_liberty_install_user
variable "LibertyNode01_was_liberty_install_user" {
  type        = "string"
  description = "Operating system userid that will be used to install the product. Userid will be created if it does not exist"
  default     = "root"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_feature
variable "LibertyNode01_was_liberty_liberty_servers_server1_feature" {
  type        = "string"
  description = "Lists the Liberty features that should be included in the feature manager list. For example, webProfile-7.0 adminCenter-1.0"
  default     = "webProfile-7.0 adminCenter-1.0"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_httpport
variable "LibertyNode01_was_liberty_liberty_servers_server1_httpport" {
  type        = "string"
  description = "HTTP Transport value that will be set in the defaultHttpEndpoint endpoint in server.xml"
  default     = "9080"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_httpsport
variable "LibertyNode01_was_liberty_liberty_servers_server1_httpsport" {
  type        = "string"
  description = "Secure HTTP Transport value that will be set in the defaultHttpEndpoint endpoint in server.xml"
  default     = "9443"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_keystore_id
variable "LibertyNode01_was_liberty_liberty_servers_server1_keystore_id" {
  type        = "string"
  description = "Keystore id that will be used when setting up the keyStore attribute in the server.xml"
  default     = "defaultKeyStore"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_keystore_password
variable "LibertyNode01_was_liberty_liberty_servers_server1_keystore_password" {
  type        = "string"
  description = "Liberty keystore password used to protect the Liberty keystore id, this value will be stored in Chef Vault"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_name
variable "LibertyNode01_was_liberty_liberty_servers_server1_name" {
  type        = "string"
  description = "Name of the initial Liberty server to be created during provisioning"
  default     = "defaultServer"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_name
variable "LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_name" {
  type        = "string"
  description = "Administrative console username used for accessing the console, the associated password is the admin_user password"
  default     = "admin"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_password
variable "LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_password" {
  type        = "string"
  description = "Password for the Liberty administrative user name, this value to be stored in the Chef Vault"
}

#Variable : LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_role
variable "LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_role" {
  type        = "string"
  description = "Liberty role for which administrative users are to be added to, the admin_user will be added to this role by default"
  default     = "admin"
}

#Variable : LibertyNode01_was_liberty_runas_user
variable "LibertyNode01_was_liberty_runas_user" {
  type        = "string"
  description = "Operating system userid that will be used to run the product. Userid will be created if it does not exist"
  default     = "root"
}

#Variable : LibertyNode01_was_liberty_wlp_user_dir
variable "LibertyNode01_was_liberty_wlp_user_dir" {
  type        = "string"
  description = "Liberty directory which product configuration will be written"
  default     = "/opt/IBM/WebSphere/Liberty/usr"
}

##### virtualmachine variables #####

#########################################################
##### Resource : CentralNode01
#########################################################

variable "CentralNode01-os_password" {
  type        = "string"
  description = "Operating System Password for the Operating System User to access virtual machine"
}

variable "CentralNode01_folder" {
  description = "Target vSphere folder for virtual machine"
}

variable "CentralNode01_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
}

variable "CentralNode01_domain" {
  description = "Domain Name of virtual machine"
}

variable "CentralNode01_number_of_vcpu" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
  default     = "2"
}

variable "CentralNode01_memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
  default     = "4096"
}

variable "CentralNode01_cluster" {
  description = "Target vSphere cluster to host the virtual machine"
}

variable "CentralNode01_resource_pool" {
  description = "Target vSphere Resource Pool to host the virtual machine"
}

variable "CentralNode01_dns_suffixes" {
  type        = "list"
  description = "Name resolution suffixes for the virtual network adapter"
}

variable "CentralNode01_dns_servers" {
  type        = "list"
  description = "DNS servers for the virtual network adapter"
}

variable "CentralNode01_network_interface_label" {
  description = "vSphere port group or network label for virtual machine's vNIC"
}

variable "CentralNode01_ipv4_gateway" {
  description = "IPv4 gateway for vNIC configuration"
}

variable "CentralNode01_ipv4_address" {
  description = "IPv4 address for vNIC configuration"
}

variable "CentralNode01_ipv4_prefix_length" {
  description = "IPv4 prefix length for vNIC configuration. The value must be a number between 8 and 32"
}

variable "CentralNode01_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
  default     = "vmxnet3"
}

variable "CentralNode01_root_disk_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
}

variable "CentralNode01_root_disk_keep_on_remove" {
  type        = "string"
  description = "Delete template disk volume when the virtual machine is deleted"
  default     = "false"
}

variable "CentralNode01_root_disk_size" {
  description = "Size of template disk volume. Should be equal to template's disk size"
  default     = "100"
}

module "provision_proxy_CentralNode01" {
  source 						= "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//vmware/proxy"
  ip                  = "${var.CentralNode01_ipv4_address}"
  id									= "${vsphere_virtual_machine.CentralNode01.id}"
  ssh_user            = "${var.CentralNode01-os_admin_user}"
  ssh_password        = "${var.CentralNode01-os_password}"
  http_proxy_host     = "${var.http_proxy_host}"
  http_proxy_user     = "${var.http_proxy_user}"
  http_proxy_password = "${var.http_proxy_password}"
  http_proxy_port     = "${var.http_proxy_port}"
  enable							= "${ length(var.http_proxy_host) > 0 ? "true" : "false"}"
}

# vsphere vm
resource "vsphere_virtual_machine" "CentralNode01" {
  name             = "${var.CentralNode01-name}"
  folder           = "${var.CentralNode01_folder}"
  num_cpus         = "${var.CentralNode01_number_of_vcpu}"
  memory           = "${var.CentralNode01_memory}"
  resource_pool_id = "${data.vsphere_resource_pool.CentralNode01_resource_pool.id}"
  datastore_id     = "${data.vsphere_datastore.CentralNode01_datastore.id}"
  guest_id         = "${data.vsphere_virtual_machine.CentralNode01_template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.CentralNode01_template.scsi_type}"

  clone {
    template_uuid = "${data.vsphere_virtual_machine.CentralNode01_template.id}"

    customize {
      linux_options {
        domain    = "${var.CentralNode01_domain}"
        host_name = "${var.CentralNode01-name}"
      }

      network_interface {
        ipv4_address = "${var.CentralNode01_ipv4_address}"
        ipv4_netmask = "${var.CentralNode01_ipv4_prefix_length}"
      }

      ipv4_gateway    = "${var.CentralNode01_ipv4_gateway}"
      dns_suffix_list = "${var.CentralNode01_dns_suffixes}"
      dns_server_list = "${var.CentralNode01_dns_servers}"
    }
  }

  network_interface {
    network_id   = "${data.vsphere_network.CentralNode01_network.id}"
    adapter_type = "${var.CentralNode01_adapter_type}"
  }

  disk {
    label          = "${var.CentralNode01-name}.disk0"
    size           = "${var.CentralNode01_root_disk_size}"
    keep_on_remove = "${var.CentralNode01_root_disk_keep_on_remove}"
  }

  # Specify the connection
  connection {
    type     = "ssh"
    user     = "${var.CentralNode01-os_admin_user}"
    password = "${var.CentralNode01-os_password}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "CentralNode01_add_ssh_key.sh"

    content = <<EOF
# =================================================================
# Copyright 2017 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================
#!/bin/bash

if (( $# != 3 )); then
echo "usage: arg 1 is user, arg 2 is public key, arg3 is CAMC Public Key"
exit -1
fi

userid="$1"
ssh_key="$2"
camc_ssh_key="$3"

user_home=$(eval echo "~$userid")
user_auth_key_file=$user_home/.ssh/authorized_keys
echo "$user_auth_key_file"
if ! [ -f $user_auth_key_file ]; then
echo "$user_auth_key_file does not exist on this system, creating."
mkdir $user_home/.ssh
chmod 700 $user_home/.ssh
touch $user_home/.ssh/authorized_keys
chmod 600 $user_home/.ssh/authorized_keys
else
echo "user_home : $user_home"
fi

if [[ $ssh_key = 'None' ]]; then
echo "skipping user key add, 'None' specified"
else
echo "$user_auth_key_file"
echo "$ssh_key" >> "$user_auth_key_file"
if [ $? -ne 0 ]; then
echo "failed to add to $user_auth_key_file"
exit -1
else
echo "updated $user_auth_key_file"
fi
fi

echo "$camc_ssh_key" >> "$user_auth_key_file"
if [ $? -ne 0 ]; then
echo "failed to add to $user_auth_key_file"
exit -1
else
echo "updated $user_auth_key_file"
fi

EOF
  }

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x CentralNode01_add_ssh_key.sh'",
      "bash -c './CentralNode01_add_ssh_key.sh  \"${var.CentralNode01-os_admin_user}\" \"${var.user_public_ssh_key}\" \"${var.ibm_pm_public_ssh_key}\">> CentralNode01_add_ssh_key.log 2>&1'",
    ]
  }
}

#########################################################
##### Resource : CentralNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "CentralNode01_chef_bootstrap_comp" {
  depends_on      = ["camc_vaultitem.VaultItem", "vsphere_virtual_machine.CentralNode01", "module.provision_proxy_CentralNode01"]
  name            = "CentralNode01_chef_bootstrap_comp"
  camc_endpoint   = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.CentralNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.CentralNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.CentralNode01-name}",
  "node_attributes": {
    "ibm_internal": {
      "stack_id": "${var.ibm_stack_id}",
      "stack_name": "${var.ibm_stack_name}",
      "vault": {
        "item": "secrets",
        "name": "${var.ibm_stack_id}"
      }
    }
  }
}
EOT
}

#########################################################
##### Resource : CentralNode01_liberty_create_server
#########################################################

resource "camc_softwaredeploy" "CentralNode01_liberty_create_server" {
  depends_on      = ["camc_softwaredeploy.LibertyNode01_liberty_install", "camc_softwaredeploy.CentralNode01_liberty_install"]
  name            = "CentralNode01_liberty_create_server"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.CentralNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.CentralNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.CentralNode01-name}",
  "runlist": "role[liberty_create_server]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[liberty_create_server]"
    },
    "was_liberty": {
      "install_dir": "${var.CentralNode01_was_liberty_install_dir}",
      "liberty_servers": {
        "server1": {
          "feature": "${var.CentralNode01_was_liberty_liberty_servers_server1_feature}",
          "httpport": "${var.CentralNode01_was_liberty_liberty_servers_server1_httpport}",
          "httpsport": "${var.CentralNode01_was_liberty_liberty_servers_server1_httpsport}",
          "jvm_params": "-Xms256m -Xmx2048m",
          "keystore_id": "${var.CentralNode01_was_liberty_liberty_servers_server1_keystore_id}",
          "name": "${var.CentralNode01_was_liberty_liberty_servers_server1_name}",
          "users": {
            "admin_user": {
              "name": "${var.CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_name}",
              "role": "${var.CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_role}"
            }
          }
        }
      },
      "wlp_user_dir": "${var.CentralNode01_was_liberty_wlp_user_dir}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "was_liberty": {
        "liberty_servers": {
          "server1": {
            "keystore_password": "${var.CentralNode01_was_liberty_liberty_servers_server1_keystore_password}",
            "users": {
              "admin_user": {
                "password": "${var.CentralNode01_was_liberty_liberty_servers_server1_users_admin_user_password}"
              }
            }
          }
        }
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

#########################################################
##### Resource : CentralNode01_liberty_install
#########################################################

resource "camc_softwaredeploy" "CentralNode01_liberty_install" {
  depends_on      = ["camc_bootstrap.LibertyNode01_chef_bootstrap_comp", "camc_bootstrap.CentralNode01_chef_bootstrap_comp"]
  name            = "CentralNode01_liberty_install"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.CentralNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.CentralNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.CentralNode01-name}",
  "runlist": "role[liberty_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[liberty_install]"
    },
    "was_liberty": {
      "base_version": "${var.CentralNode01_was_liberty_base_version}",
      "edition": "${var.CentralNode01_was_liberty_edition}",
      "install_dir": "${var.CentralNode01_was_liberty_install_dir}",
      "install_grp": "${var.CentralNode01_was_liberty_install_grp}",
      "install_user": "${var.CentralNode01_was_liberty_install_user}",
      "java_version": "8.0",
      "runas_user": "${var.CentralNode01_was_liberty_runas_user}",
      "wlp_user_dir": "${var.CentralNode01_was_liberty_wlp_user_dir}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "im_repo_password": "${var.ibm_im_repo_password}",
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

#########################################################
##### Resource : CentralNode01_liberty_plugin_generate
#########################################################

resource "camc_softwaredeploy" "CentralNode01_liberty_plugin_generate" {
  depends_on      = ["camc_softwaredeploy.LibertyNode01_liberty_plugin_merge_setup"]
  name            = "CentralNode01_liberty_plugin_generate"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.CentralNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.CentralNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.CentralNode01-name}",
  "runlist": "role[liberty_plugin_generate]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[liberty_plugin_generate]"
    },
    "ssh": {
      "private_key": {
        "path": "${var.CentralNode01_ssh_private_key_path}"
      }
    },
    "was_liberty": {
      "farm": {
        "central_node": "${var.CentralNode01_was_liberty_farm_central_node}",
        "logFileName": "${var.CentralNode01_was_liberty_farm_logFileName}",
        "pluginInstallRoot": "${var.CentralNode01_was_liberty_farm_pluginInstallRoot}",
        "sslCertlabel": "${var.CentralNode01_was_liberty_farm_sslCertlabel}",
        "sslKeyringLocation": "${var.CentralNode01_was_liberty_farm_sslKeyringLocation}",
        "sslStashfileLocation": "${var.CentralNode01_was_liberty_farm_sslStashfileLocation}",
        "webserverName": "${var.CentralNode01_was_liberty_farm_webserverName}",
        "webserverPort": "${var.CentralNode01_was_liberty_farm_webserverPort}"
      }
    }
  }
}
EOT
}

#########################################################
##### Resource : LibertyNode01
#########################################################

variable "LibertyNode01-os_password" {
  type        = "string"
  description = "Operating System Password for the Operating System User to access virtual machine"
}

variable "LibertyNode01_folder" {
  description = "Target vSphere folder for virtual machine"
}

variable "LibertyNode01_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
}

variable "LibertyNode01_domain" {
  description = "Domain Name of virtual machine"
}

variable "LibertyNode01_number_of_vcpu" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
  default     = "2"
}

variable "LibertyNode01_memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
  default     = "4096"
}

variable "LibertyNode01_cluster" {
  description = "Target vSphere cluster to host the virtual machine"
}

variable "LibertyNode01_resource_pool" {
  description = "Target vSphere Resource Pool to host the virtual machine"
}

variable "LibertyNode01_dns_suffixes" {
  type        = "list"
  description = "Name resolution suffixes for the virtual network adapter"
}

variable "LibertyNode01_dns_servers" {
  type        = "list"
  description = "DNS servers for the virtual network adapter"
}

variable "LibertyNode01_network_interface_label" {
  description = "vSphere port group or network label for virtual machine's vNIC"
}

variable "LibertyNode01_ipv4_gateway" {
  description = "IPv4 gateway for vNIC configuration"
}

variable "LibertyNode01_ipv4_address" {
  description = "IPv4 address for vNIC configuration"
}

variable "LibertyNode01_ipv4_prefix_length" {
  description = "IPv4 prefix length for vNIC configuration. The value must be a number between 8 and 32"
}

variable "LibertyNode01_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
  default     = "vmxnet3"
}

variable "LibertyNode01_root_disk_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
}

variable "LibertyNode01_root_disk_keep_on_remove" {
  type        = "string"
  description = "Delete template disk volume when the virtual machine is deleted"
  default     = "false"
}

variable "LibertyNode01_root_disk_size" {
  description = "Size of template disk volume. Should be equal to template's disk size"
  default     = "100"
}

module "provision_proxy_LibertyNode01" {
  source 						= "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//vmware/proxy"
  ip                  = "${var.LibertyNode01_ipv4_address}"
  id									= "${vsphere_virtual_machine.LibertyNode01.id}"
  ssh_user            = "${var.LibertyNode01-os_admin_user}"
  ssh_password        = "${var.LibertyNode01-os_password}"
  http_proxy_host     = "${var.http_proxy_host}"
  http_proxy_user     = "${var.http_proxy_user}"
  http_proxy_password = "${var.http_proxy_password}"
  http_proxy_port     = "${var.http_proxy_port}"
  enable							= "${ length(var.http_proxy_host) > 0 ? "true" : "false"}"
}

# vsphere vm
resource "vsphere_virtual_machine" "LibertyNode01" {
  name             = "${var.LibertyNode01-name}"
  folder           = "${var.LibertyNode01_folder}"
  num_cpus         = "${var.LibertyNode01_number_of_vcpu}"
  memory           = "${var.LibertyNode01_memory}"
  resource_pool_id = "${data.vsphere_resource_pool.LibertyNode01_resource_pool.id}"
  datastore_id     = "${data.vsphere_datastore.LibertyNode01_datastore.id}"
  guest_id         = "${data.vsphere_virtual_machine.LibertyNode01_template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.LibertyNode01_template.scsi_type}"

  clone {
    template_uuid = "${data.vsphere_virtual_machine.LibertyNode01_template.id}"

    customize {
      linux_options {
        domain    = "${var.LibertyNode01_domain}"
        host_name = "${var.LibertyNode01-name}"
      }

      network_interface {
        ipv4_address = "${var.LibertyNode01_ipv4_address}"
        ipv4_netmask = "${var.LibertyNode01_ipv4_prefix_length}"
      }

      ipv4_gateway    = "${var.LibertyNode01_ipv4_gateway}"
      dns_suffix_list = "${var.LibertyNode01_dns_suffixes}"
      dns_server_list = "${var.LibertyNode01_dns_servers}"
    }
  }

  network_interface {
    network_id   = "${data.vsphere_network.LibertyNode01_network.id}"
    adapter_type = "${var.LibertyNode01_adapter_type}"
  }

  disk {
    label          = "${var.LibertyNode01-name}.disk0"
    size           = "${var.LibertyNode01_root_disk_size}"
    keep_on_remove = "${var.LibertyNode01_root_disk_keep_on_remove}"
  }

  # Specify the connection
  connection {
    type     = "ssh"
    user     = "${var.LibertyNode01-os_admin_user}"
    password = "${var.LibertyNode01-os_password}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "LibertyNode01_add_ssh_key.sh"

    content = <<EOF
# =================================================================
# Copyright 2017 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================
#!/bin/bash

if (( $# != 3 )); then
echo "usage: arg 1 is user, arg 2 is public key, arg3 is CAMC Public Key"
exit -1
fi

userid="$1"
ssh_key="$2"
camc_ssh_key="$3"

user_home=$(eval echo "~$userid")
user_auth_key_file=$user_home/.ssh/authorized_keys
echo "$user_auth_key_file"
if ! [ -f $user_auth_key_file ]; then
echo "$user_auth_key_file does not exist on this system, creating."
mkdir $user_home/.ssh
chmod 700 $user_home/.ssh
touch $user_home/.ssh/authorized_keys
chmod 600 $user_home/.ssh/authorized_keys
else
echo "user_home : $user_home"
fi

if [[ $ssh_key = 'None' ]]; then
echo "skipping user key add, 'None' specified"
else
echo "$user_auth_key_file"
echo "$ssh_key" >> "$user_auth_key_file"
if [ $? -ne 0 ]; then
echo "failed to add to $user_auth_key_file"
exit -1
else
echo "updated $user_auth_key_file"
fi
fi

echo "$camc_ssh_key" >> "$user_auth_key_file"
if [ $? -ne 0 ]; then
echo "failed to add to $user_auth_key_file"
exit -1
else
echo "updated $user_auth_key_file"
fi

EOF
  }

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'chmod +x LibertyNode01_add_ssh_key.sh'",
      "bash -c './LibertyNode01_add_ssh_key.sh  \"${var.LibertyNode01-os_admin_user}\" \"${var.user_public_ssh_key}\" \"${var.ibm_pm_public_ssh_key}\">> LibertyNode01_add_ssh_key.log 2>&1'",
    ]
  }
}

#########################################################
##### Resource : LibertyNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "LibertyNode01_chef_bootstrap_comp" {
  depends_on      = ["camc_vaultitem.VaultItem", "vsphere_virtual_machine.LibertyNode01", "module.provision_proxy_LibertyNode01"]
  name            = "LibertyNode01_chef_bootstrap_comp"
  camc_endpoint   = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LibertyNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LibertyNode01-name}",
  "node_attributes": {
    "ibm_internal": {
      "stack_id": "${var.ibm_stack_id}",
      "stack_name": "${var.ibm_stack_name}",
      "vault": {
        "item": "secrets",
        "name": "${var.ibm_stack_id}"
      }
    }
  }
}
EOT
}

#########################################################
##### Resource : LibertyNode01_liberty_create_server
#########################################################

resource "camc_softwaredeploy" "LibertyNode01_liberty_create_server" {
  depends_on      = ["camc_softwaredeploy.LibertyNode01_liberty_install", "camc_softwaredeploy.CentralNode01_liberty_install"]
  name            = "LibertyNode01_liberty_create_server"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LibertyNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LibertyNode01-name}",
  "runlist": "role[liberty_create_server]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[liberty_create_server]"
    },
    "was_liberty": {
      "install_dir": "${var.LibertyNode01_was_liberty_install_dir}",
      "liberty_servers": {
        "server1": {
          "feature": "${var.LibertyNode01_was_liberty_liberty_servers_server1_feature}",
          "httpport": "${var.LibertyNode01_was_liberty_liberty_servers_server1_httpport}",
          "httpsport": "${var.LibertyNode01_was_liberty_liberty_servers_server1_httpsport}",
          "jvm_params": "-Xms256m -Xmx2048m",
          "keystore_id": "${var.LibertyNode01_was_liberty_liberty_servers_server1_keystore_id}",
          "name": "${var.LibertyNode01_was_liberty_liberty_servers_server1_name}",
          "users": {
            "admin_user": {
              "name": "${var.LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_name}",
              "role": "${var.LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_role}"
            }
          }
        }
      },
      "wlp_user_dir": "${var.LibertyNode01_was_liberty_wlp_user_dir}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "was_liberty": {
        "liberty_servers": {
          "server1": {
            "keystore_password": "${var.LibertyNode01_was_liberty_liberty_servers_server1_keystore_password}",
            "users": {
              "admin_user": {
                "password": "${var.LibertyNode01_was_liberty_liberty_servers_server1_users_admin_user_password}"
              }
            }
          }
        }
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

#########################################################
##### Resource : LibertyNode01_liberty_install
#########################################################

resource "camc_softwaredeploy" "LibertyNode01_liberty_install" {
  depends_on      = ["camc_bootstrap.LibertyNode01_chef_bootstrap_comp", "camc_bootstrap.CentralNode01_chef_bootstrap_comp"]
  name            = "LibertyNode01_liberty_install"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LibertyNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LibertyNode01-name}",
  "runlist": "role[liberty_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[liberty_install]"
    },
    "was_liberty": {
      "base_version": "${var.LibertyNode01_was_liberty_base_version}",
      "edition": "${var.LibertyNode01_was_liberty_edition}",
      "install_dir": "${var.LibertyNode01_was_liberty_install_dir}",
      "install_grp": "${var.LibertyNode01_was_liberty_install_grp}",
      "install_user": "${var.LibertyNode01_was_liberty_install_user}",
      "java_version": "8.0",
      "runas_user": "${var.LibertyNode01_was_liberty_runas_user}",
      "wlp_user_dir": "${var.LibertyNode01_was_liberty_wlp_user_dir}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "im_repo_password": "${var.ibm_im_repo_password}",
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

#########################################################
##### Resource : LibertyNode01_liberty_plugin_generate
#########################################################

resource "camc_softwaredeploy" "LibertyNode01_liberty_plugin_generate" {
  depends_on      = ["camc_softwaredeploy.LibertyNode01_liberty_plugin_merge_setup"]
  name            = "LibertyNode01_liberty_plugin_generate"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LibertyNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LibertyNode01-name}",
  "runlist": "role[liberty_plugin_generate]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[liberty_plugin_generate]"
    },
    "ssh": {
      "private_key": {
        "path": "${var.LibertyNode01_ssh_private_key_path}"
      }
    },
    "was_liberty": {
      "farm": {
        "central_node": "${var.LibertyNode01_was_liberty_farm_central_node}",
        "logFileName": "${var.LibertyNode01_was_liberty_farm_logFileName}",
        "pluginInstallRoot": "${var.LibertyNode01_was_liberty_farm_pluginInstallRoot}",
        "sslCertlabel": "${var.LibertyNode01_was_liberty_farm_sslCertlabel}",
        "sslKeyringLocation": "${var.LibertyNode01_was_liberty_farm_sslKeyringLocation}",
        "sslStashfileLocation": "${var.LibertyNode01_was_liberty_farm_sslStashfileLocation}",
        "webserverName": "${var.LibertyNode01_was_liberty_farm_webserverName}",
        "webserverPort": "${var.LibertyNode01_was_liberty_farm_webserverPort}"
      }
    }
  }
}
EOT
}

#########################################################
##### Resource : LibertyNode01_liberty_plugin_merge
#########################################################

resource "camc_softwaredeploy" "LibertyNode01_liberty_plugin_merge" {
  depends_on      = ["camc_softwaredeploy.LibertyNode01_liberty_plugin_generate", "camc_softwaredeploy.CentralNode01_liberty_plugin_generate"]
  name            = "LibertyNode01_liberty_plugin_merge"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LibertyNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LibertyNode01-name}",
  "runlist": "role[liberty_plugin_merge]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[liberty_plugin_merge]"
    },
    "ssh": {
      "private_key": {
        "path": "${var.LibertyNode01_ssh_private_key_path}"
      }
    },
    "was_liberty": {
      "farm": {
        "httpd_plugins_dir": {
          "default": "undefined",
          "description": "undefined",
          "descriptive": "undefined",
          "hidden": "undefined",
          "parm_type": "undefined",
          "precedence_level": "undefined",
          "required": "undefined",
          "secret": "undefined",
          "selectable": "undefined",
          "type": "undefined"
        },
        "httpd_user": "${var.LibertyNode01_was_liberty_farm_httpd_user}",
        "logFileName": "${var.LibertyNode01_was_liberty_farm_logFileName}",
        "pluginInstallRoot": "${var.LibertyNode01_was_liberty_farm_pluginInstallRoot}",
        "sslCertlabel": "${var.LibertyNode01_was_liberty_farm_sslCertlabel}",
        "sslKeyringLocation": "${var.LibertyNode01_was_liberty_farm_sslKeyringLocation}",
        "sslStashfileLocation": "${var.LibertyNode01_was_liberty_farm_sslStashfileLocation}",
        "webserverName": "${var.LibertyNode01_was_liberty_farm_webserverName}",
        "webserverPort": "${var.LibertyNode01_was_liberty_farm_webserverPort}",
        "webserverhost": "${var.LibertyNode01_was_liberty_farm_webserverhost}"
      }
    }
  }
}
EOT
}

#########################################################
##### Resource : LibertyNode01_liberty_plugin_merge_setup
#########################################################

resource "camc_softwaredeploy" "LibertyNode01_liberty_plugin_merge_setup" {
  depends_on      = ["camc_softwaredeploy.LibertyNode01_liberty_create_server", "camc_softwaredeploy.CentralNode01_liberty_create_server"]
  name            = "LibertyNode01_liberty_plugin_merge_setup"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LibertyNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LibertyNode01-name}",
  "runlist": "role[liberty_plugin_merge_setup]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[liberty_plugin_merge_setup]"
    },
    "ssh": {
      "private_key": {
        "path": "${var.LibertyNode01_ssh_private_key_path}"
      }
    },
    "was_liberty": {
      "farm": {
        "logFileName": "${var.LibertyNode01_was_liberty_farm_logFileName}",
        "pluginInstallRoot": "${var.LibertyNode01_was_liberty_farm_pluginInstallRoot}",
        "sslCertlabel": "${var.LibertyNode01_was_liberty_farm_sslCertlabel}",
        "sslKeyringLocation": "${var.LibertyNode01_was_liberty_farm_sslKeyringLocation}",
        "sslStashfileLocation": "${var.LibertyNode01_was_liberty_farm_sslStashfileLocation}",
        "webserverName": "${var.LibertyNode01_was_liberty_farm_webserverName}",
        "webserverPort": "${var.LibertyNode01_was_liberty_farm_webserverPort}"
      }
    }
  }
}
EOT
}

#########################################################
##### Resource : VaultItem
#########################################################

resource "camc_vaultitem" "VaultItem" {
  camc_endpoint   = "${var.ibm_pm_service}/v1/vault_item/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "vault_content": {
    "item": "secrets",
    "values": {},
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

output "CentralNode01_ip" {
  value = "VM IP Address : ${vsphere_virtual_machine.CentralNode01.clone.0.customize.0.network_interface.0.ipv4_address}"
}

output "CentralNode01_name" {
  value = "${var.CentralNode01-name}"
}

output "CentralNode01_roles" {
  value = "liberty_create_server,liberty_install,liberty_plugin_generate"
}

output "LibertyNode01_ip" {
  value = "VM IP Address : ${vsphere_virtual_machine.LibertyNode01.clone.0.customize.0.network_interface.0.ipv4_address}"
}

output "LibertyNode01_name" {
  value = "${var.LibertyNode01-name}"
}

output "LibertyNode01_roles" {
  value = "liberty_create_server,liberty_install,liberty_plugin_generate,liberty_plugin_merge,liberty_plugin_merge_setup"
}

output "stack_id" {
  value = "${var.ibm_stack_id}"
}
