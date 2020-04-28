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
variable "ibm_pm_public_ssh_key_name" {
  description = "Public CAMC SSH key name used to connect to the virtual guest."
}

variable "ibm_pm_private_ssh_key" {
  description = "Private CAMC SSH key (base64 encoded) used to connect to the virtual guest."
}

variable "user_public_ssh_key" {
  type        = "string"
  description = "User defined public SSH key used to connect to the virtual machine. The format must be in openSSH."
  default     = "None"
}

variable "ibm_stack_id" {
  description = "A unique stack id."
}

##############################################################
# Define the ibm provider
##############################################################
#define the ibm provider
provider "ibm" {
  version = "~> 0.7"
}

provider "camc" {
  version = "~> 0.2"
}

##############################################################
# Reference public key in Devices>Manage>SSH Keys in SL console)
##############################################################
data "ibm_compute_ssh_key" "ibm_pm_public_key" {
  label       = "${var.ibm_pm_public_ssh_key_name}"
  most_recent = "true"
}

##############################################################
# Define pattern variables
##############################################################
##### unique stack name #####
variable "ibm_stack_name" {
  description = "A unique stack name."
}

##### CentralNode01 variables #####
#Variable : CentralNode01-image
variable "CentralNode01-image" {
  type        = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default     = "REDHAT_7_64"
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
  default     = "REDHAT_7_64"
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
#Variable : CentralNode01-mgmt-network-public
variable "CentralNode01-mgmt-network-public" {
  type        = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default     = "true"
}

#Variable : LibertyNode01-mgmt-network-public
variable "LibertyNode01-mgmt-network-public" {
  type        = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default     = "true"
}

##### ungrouped variables #####
##### domain name #####
variable "runtime_domain" {
  description = "domain name"
  default     = "cam.ibm.com"
}

#########################################################
##### Resource : CentralNode01
#########################################################

#Parameter : CentralNode01_datacenter
variable "CentralNode01_datacenter" {
  type        = "string"
  description = "IBMCloud datacenter where infrastructure resources will be deployed"
  default     = "dal05"
}

#Parameter : CentralNode01_private_network_only
variable "CentralNode01_private_network_only" {
  type        = "string"
  description = "Provision the virtual machine with only private IP"
  default     = "false"
}

#Parameter : CentralNode01_number_of_cores
variable "CentralNode01_number_of_cores" {
  type        = "string"
  description = "Number of CPU cores, which is required to be a positive Integer"
  default     = "2"
}

#Parameter : CentralNode01_memory
variable "CentralNode01_memory" {
  type        = "string"
  description = "Amount of Memory (MBs), which is required to be one or more times of 1024"
  default     = "4096"
}

#Parameter : CentralNode01_network_speed
variable "CentralNode01_network_speed" {
  type        = "string"
  description = "Bandwidth of network communication applied to the virtual machine"
  default     = "1000"
}

#Parameter : CentralNode01_hourly_billing
variable "CentralNode01_hourly_billing" {
  type        = "string"
  description = "Billing cycle: hourly billed or monthly billed"
  default     = "true"
}

#Parameter : CentralNode01_dedicated_acct_host_only
variable "CentralNode01_dedicated_acct_host_only" {
  type        = "string"
  description = "Shared or dedicated host, where dedicated host usually means higher performance and cost"
  default     = "false"
}

#Parameter : CentralNode01_local_disk
variable "CentralNode01_local_disk" {
  type        = "string"
  description = "User local disk or SAN disk"
  default     = "false"
}

variable "CentralNode01_root_disk_size" {
  type        = "string"
  description = "Root Disk Size - CentralNode01"
  default     = "100"
}

resource "ibm_compute_vm_instance" "CentralNode01" {
  hostname                 = "${var.CentralNode01-name}"
  os_reference_code        = "${var.CentralNode01-image}"
  domain                   = "${var.runtime_domain}"
  datacenter               = "${var.CentralNode01_datacenter}"
  network_speed            = "${var.CentralNode01_network_speed}"
  hourly_billing           = "${var.CentralNode01_hourly_billing}"
  private_network_only     = "${var.CentralNode01_private_network_only}"
  cores                    = "${var.CentralNode01_number_of_cores}"
  memory                   = "${var.CentralNode01_memory}"
  disks                    = ["${var.CentralNode01_root_disk_size}"]
  dedicated_acct_host_only = "${var.CentralNode01_dedicated_acct_host_only}"
  local_disk               = "${var.CentralNode01_local_disk}"
  ssh_key_ids              = ["${data.ibm_compute_ssh_key.ibm_pm_public_key.id}"]

  # Specify the ssh connection
  connection {
    user        = "${var.CentralNode01-os_admin_user}"
    private_key = "${base64decode(var.ibm_pm_private_ssh_key)}"
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

if (( $# != 2 )); then
    echo "usage: arg 1 is user, arg 2 is public key"
    exit -1
fi

userid=$1
ssh_key=$2

if [[ $ssh_key = 'None' ]]; then
  echo "skipping add, 'None' specified"
  exit 0
fi

user_home=$(eval echo "~$userid")
user_auth_key_file=$user_home/.ssh/authorized_keys
if ! [ -f $user_auth_key_file ]; then
  echo "$user_auth_key_file does not exist on this system"
  exit -1
else
  echo "user_home --> $user_home"
fi

echo $ssh_key >> $user_auth_key_file
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
      "bash -c './CentralNode01_add_ssh_key.sh  \"${var.CentralNode01-os_admin_user}\" \"${var.user_public_ssh_key}\">> CentralNode01_add_ssh_key.log 2>&1'",
    ]
  }
}

#########################################################
##### Resource : CentralNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "CentralNode01_chef_bootstrap_comp" {
  depends_on      = ["camc_vaultitem.VaultItem", "ibm_compute_vm_instance.CentralNode01"]
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
  "host_ip": "${var.CentralNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.CentralNode01.ipv4_address_private : ibm_compute_vm_instance.CentralNode01.ipv4_address}",
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
  "host_ip": "${var.CentralNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.CentralNode01.ipv4_address_private : ibm_compute_vm_instance.CentralNode01.ipv4_address}",
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
  "host_ip": "${var.CentralNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.CentralNode01.ipv4_address_private : ibm_compute_vm_instance.CentralNode01.ipv4_address}",
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
  "host_ip": "${var.CentralNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.CentralNode01.ipv4_address_private : ibm_compute_vm_instance.CentralNode01.ipv4_address}",
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

#Parameter : LibertyNode01_datacenter
variable "LibertyNode01_datacenter" {
  type        = "string"
  description = "IBMCloud datacenter where infrastructure resources will be deployed"
  default     = "dal05"
}

#Parameter : LibertyNode01_private_network_only
variable "LibertyNode01_private_network_only" {
  type        = "string"
  description = "Provision the virtual machine with only private IP"
  default     = "false"
}

#Parameter : LibertyNode01_number_of_cores
variable "LibertyNode01_number_of_cores" {
  type        = "string"
  description = "Number of CPU cores, which is required to be a positive Integer"
  default     = "2"
}

#Parameter : LibertyNode01_memory
variable "LibertyNode01_memory" {
  type        = "string"
  description = "Amount of Memory (MBs), which is required to be one or more times of 1024"
  default     = "4096"
}

#Parameter : LibertyNode01_network_speed
variable "LibertyNode01_network_speed" {
  type        = "string"
  description = "Bandwidth of network communication applied to the virtual machine"
  default     = "1000"
}

#Parameter : LibertyNode01_hourly_billing
variable "LibertyNode01_hourly_billing" {
  type        = "string"
  description = "Billing cycle: hourly billed or monthly billed"
  default     = "true"
}

#Parameter : LibertyNode01_dedicated_acct_host_only
variable "LibertyNode01_dedicated_acct_host_only" {
  type        = "string"
  description = "Shared or dedicated host, where dedicated host usually means higher performance and cost"
  default     = "false"
}

#Parameter : LibertyNode01_local_disk
variable "LibertyNode01_local_disk" {
  type        = "string"
  description = "User local disk or SAN disk"
  default     = "false"
}

variable "LibertyNode01_root_disk_size" {
  type        = "string"
  description = "Root Disk Size - LibertyNode01"
  default     = "100"
}

resource "ibm_compute_vm_instance" "LibertyNode01" {
  hostname                 = "${var.LibertyNode01-name}"
  os_reference_code        = "${var.LibertyNode01-image}"
  domain                   = "${var.runtime_domain}"
  datacenter               = "${var.LibertyNode01_datacenter}"
  network_speed            = "${var.LibertyNode01_network_speed}"
  hourly_billing           = "${var.LibertyNode01_hourly_billing}"
  private_network_only     = "${var.LibertyNode01_private_network_only}"
  cores                    = "${var.LibertyNode01_number_of_cores}"
  memory                   = "${var.LibertyNode01_memory}"
  disks                    = ["${var.LibertyNode01_root_disk_size}"]
  dedicated_acct_host_only = "${var.LibertyNode01_dedicated_acct_host_only}"
  local_disk               = "${var.LibertyNode01_local_disk}"
  ssh_key_ids              = ["${data.ibm_compute_ssh_key.ibm_pm_public_key.id}"]

  # Specify the ssh connection
  connection {
    user        = "${var.LibertyNode01-os_admin_user}"
    private_key = "${base64decode(var.ibm_pm_private_ssh_key)}"
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

if (( $# != 2 )); then
    echo "usage: arg 1 is user, arg 2 is public key"
    exit -1
fi

userid=$1
ssh_key=$2

if [[ $ssh_key = 'None' ]]; then
  echo "skipping add, 'None' specified"
  exit 0
fi

user_home=$(eval echo "~$userid")
user_auth_key_file=$user_home/.ssh/authorized_keys
if ! [ -f $user_auth_key_file ]; then
  echo "$user_auth_key_file does not exist on this system"
  exit -1
else
  echo "user_home --> $user_home"
fi

echo $ssh_key >> $user_auth_key_file
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
      "bash -c './LibertyNode01_add_ssh_key.sh  \"${var.LibertyNode01-os_admin_user}\" \"${var.user_public_ssh_key}\">> LibertyNode01_add_ssh_key.log 2>&1'",
    ]
  }
}

#########################################################
##### Resource : LibertyNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "LibertyNode01_chef_bootstrap_comp" {
  depends_on      = ["camc_vaultitem.VaultItem", "ibm_compute_vm_instance.LibertyNode01"]
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
  "host_ip": "${var.LibertyNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.LibertyNode01.ipv4_address_private : ibm_compute_vm_instance.LibertyNode01.ipv4_address}",
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
  "host_ip": "${var.LibertyNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.LibertyNode01.ipv4_address_private : ibm_compute_vm_instance.LibertyNode01.ipv4_address}",
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
  "host_ip": "${var.LibertyNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.LibertyNode01.ipv4_address_private : ibm_compute_vm_instance.LibertyNode01.ipv4_address}",
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
  "host_ip": "${var.LibertyNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.LibertyNode01.ipv4_address_private : ibm_compute_vm_instance.LibertyNode01.ipv4_address}",
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
  "host_ip": "${var.LibertyNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.LibertyNode01.ipv4_address_private : ibm_compute_vm_instance.LibertyNode01.ipv4_address}",
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
  "host_ip": "${var.LibertyNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.LibertyNode01.ipv4_address_private : ibm_compute_vm_instance.LibertyNode01.ipv4_address}",
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
  value = "Private : ${ibm_compute_vm_instance.CentralNode01.ipv4_address_private} & Public : ${ibm_compute_vm_instance.CentralNode01.ipv4_address}"
}

output "CentralNode01_name" {
  value = "${var.CentralNode01-name}"
}

output "CentralNode01_roles" {
  value = "liberty_create_server,liberty_install,liberty_plugin_generate"
}

output "LibertyNode01_ip" {
  value = "Private : ${ibm_compute_vm_instance.LibertyNode01.ipv4_address_private} & Public : ${ibm_compute_vm_instance.LibertyNode01.ipv4_address}"
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
