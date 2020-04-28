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

# This is a terraform generated template generated from lamp_stack_v1_standalone

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
data "vsphere_datacenter" "LAMPNode01_datacenter" {
  name = "${var.LAMPNode01_datacenter}"
}

data "vsphere_datastore" "LAMPNode01_datastore" {
  name          = "${var.LAMPNode01_root_disk_datastore}"
  datacenter_id = "${data.vsphere_datacenter.LAMPNode01_datacenter.id}"
}

data "vsphere_resource_pool" "LAMPNode01_resource_pool" {
  name          = "${var.LAMPNode01_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.LAMPNode01_datacenter.id}"
}

data "vsphere_network" "LAMPNode01_network" {
  name          = "${var.LAMPNode01_network_interface_label}"
  datacenter_id = "${data.vsphere_datacenter.LAMPNode01_datacenter.id}"
}

data "vsphere_virtual_machine" "LAMPNode01_template" {
  name          = "${var.LAMPNode01-image}"
  datacenter_id = "${data.vsphere_datacenter.LAMPNode01_datacenter.id}"
}

##### Environment variables #####
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

##### LAMPNode01 variables #####
#Variable : LAMPNode01-image
variable "LAMPNode01-image" {
  type        = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
}

#Variable : LAMPNode01-name
variable "LAMPNode01-name" {
  type        = "string"
  description = "Short hostname of virtual machine"
}

#Variable : LAMPNode01-os_admin_user
variable "LAMPNode01-os_admin_user" {
  type        = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : LAMPNode01_httpd_data_dir_mode
variable "LAMPNode01_httpd_data_dir_mode" {
  type        = "string"
  description = "OS Permisssions of data folders"
  default     = "0755"
}

#Variable : LAMPNode01_httpd_document_root
variable "LAMPNode01_httpd_document_root" {
  type        = "string"
  description = "File System Location of the Document Root"
  default     = "/var/www/html5"
}

#Variable : LAMPNode01_httpd_listen
variable "LAMPNode01_httpd_listen" {
  type        = "string"
  description = "Listening port to be configured in HTTP server"
  default     = "8080"
}

#Variable : LAMPNode01_httpd_log_dir
variable "LAMPNode01_httpd_log_dir" {
  type        = "string"
  description = "Directory where HTTP Server logs will be sent"
  default     = "/var/log/httpd"
}

#Variable : LAMPNode01_httpd_log_level
variable "LAMPNode01_httpd_log_level" {
  type        = "string"
  description = "Log levels of the http process"
  default     = "info"
}

#Variable : LAMPNode01_httpd_os_users_web_content_owner_gid
variable "LAMPNode01_httpd_os_users_web_content_owner_gid" {
  type        = "string"
  description = "Group ID of web content owner to be configured in HTTP server"
  default     = "webmaster"
}

#Variable : LAMPNode01_httpd_os_users_web_content_owner_home
variable "LAMPNode01_httpd_os_users_web_content_owner_home" {
  type        = "string"
  description = "Home directory of web content owner to be configured in HTTP server"
  default     = "/home/webmaster"
}

#Variable : LAMPNode01_httpd_os_users_web_content_owner_ldap_user
variable "LAMPNode01_httpd_os_users_web_content_owner_ldap_user" {
  type        = "string"
  description = "Use LDAP to authenticate Web Content Owner account on Linux HTTP server as well as web site logins"
  default     = "false"
}

#Variable : LAMPNode01_httpd_os_users_web_content_owner_name
variable "LAMPNode01_httpd_os_users_web_content_owner_name" {
  type        = "string"
  description = "User ID of web content owner to be configured in HTTP server"
  default     = "webmaster"
}

#Variable : LAMPNode01_httpd_os_users_web_content_owner_shell
variable "LAMPNode01_httpd_os_users_web_content_owner_shell" {
  type        = "string"
  description = "Default shell configured on Linux server"
  default     = "/bin/bash"
}

#Variable : LAMPNode01_httpd_php_mod_enabled
variable "LAMPNode01_httpd_php_mod_enabled" {
  type        = "string"
  description = "Enable PHP in Apache on Linux by Loading the Module"
  default     = "true"
}

#Variable : LAMPNode01_httpd_server_admin
variable "LAMPNode01_httpd_server_admin" {
  type        = "string"
  description = "Email Address of the Webmaster"
  default     = "webmaster@orpheus.ibm.com"
}

#Variable : LAMPNode01_httpd_server_name
variable "LAMPNode01_httpd_server_name" {
  type        = "string"
  description = "The Name of the HTTP Server, normally the FQDN of server."
  default     = "orpheus.ibm.com"
}

#Variable : LAMPNode01_httpd_version
variable "LAMPNode01_httpd_version" {
  type        = "string"
  description = "Version of HTTP Server to be installed."
  default     = "2.4"
}

#Variable : LAMPNode01_httpd_vhosts_enabled
variable "LAMPNode01_httpd_vhosts_enabled" {
  type        = "string"
  description = "Allow to configure virtual hosts to run multiple websites on the same HTTP server"
  default     = "false"
}

#Variable : LAMPNode01_mysql_config_data_dir
variable "LAMPNode01_mysql_config_data_dir" {
  type        = "string"
  description = "Directory to store information managed by MySQL server"
  default     = "/var/lib/mysql"
}

#Variable : LAMPNode01_mysql_config_databases_database_1_database_name
variable "LAMPNode01_mysql_config_databases_database_1_database_name" {
  type        = "string"
  description = "Create a sample database in MySQL"
  default     = "default_database"
}

#Variable : LAMPNode01_mysql_config_databases_database_1_users_user_1_name
variable "LAMPNode01_mysql_config_databases_database_1_users_user_1_name" {
  type        = "string"
  description = "Name of the first user which is created and allowed to access the created sample database "
  default     = "defaultUser"
}

#Variable : LAMPNode01_mysql_config_databases_database_1_users_user_2_name
variable "LAMPNode01_mysql_config_databases_database_1_users_user_2_name" {
  type        = "string"
  description = "Name of the second user which is created and allowed to access the created sample database "
  default     = "defaultUser2"
}

#Variable : LAMPNode01_mysql_config_databases_database_1_users_user_1_password
variable "LAMPNode01_mysql_config_databases_database_1_users_user_1_password" {
  type        = "string"
  description = "Password of the first user which is created and allowed to access the created sample database"
}

#Variable : LAMPNode01_mysql_config_databases_database_1_users_user_2_password
variable "LAMPNode01_mysql_config_databases_database_1_users_user_2_password" {
  type        = "string"
  description = "Password of the second user"
}

#Variable : LAMPNode01_mysql_config_log_file
variable "LAMPNode01_mysql_config_log_file" {
  type        = "string"
  description = "Log file configured in MySQL"
  default     = "/var/log/mysqld.log"
}

#Variable : LAMPNode01_mysql_config_port
variable "LAMPNode01_mysql_config_port" {
  type        = "string"
  description = "Listen port to be configured in MySQL"
  default     = "3306"
}

#Variable : LAMPNode01_mysql_install_from_repo
variable "LAMPNode01_mysql_install_from_repo" {
  type        = "string"
  description = "Install MySQL from secure repository server or yum repo"
  default     = "true"
}

#Variable : LAMPNode01_mysql_os_users_daemon_gid
variable "LAMPNode01_mysql_os_users_daemon_gid" {
  type        = "string"
  description = "Group ID of the default OS user to be used to configure MySQL"
  default     = "mysql"
}

#Variable : LAMPNode01_mysql_os_users_daemon_home
variable "LAMPNode01_mysql_os_users_daemon_home" {
  type        = "string"
  description = "Home directory of the default OS user to be used to configure MySQL"
  default     = "/home/mysql"
}

#Variable : LAMPNode01_mysql_os_users_daemon_ldap_user
variable "LAMPNode01_mysql_os_users_daemon_ldap_user" {
  type        = "string"
  description = "A flag which indicates whether to create the MQ USer locally, or utilise an LDAP based user."
  default     = "false"
}

#Variable : LAMPNode01_mysql_os_users_daemon_name
variable "LAMPNode01_mysql_os_users_daemon_name" {
  type        = "string"
  description = "User Name of the default OS user to be used to configure MySQL"
  default     = "mysql"
}

#Variable : LAMPNode01_mysql_os_users_daemon_shell
variable "LAMPNode01_mysql_os_users_daemon_shell" {
  type        = "string"
  description = "Default shell configured on Linux server"
  default     = "/bin/bash"
}

#Variable : LAMPNode01_mysql_root_password
variable "LAMPNode01_mysql_root_password" {
  type        = "string"
  description = "The password for the MySQL root user"
}

#Variable : LAMPNode01_mysql_version
variable "LAMPNode01_mysql_version" {
  type        = "string"
  description = "MySQL Version to be installed"
  default     = "5.7.17"
}

##### virtualmachine variables #####

#########################################################
##### Resource : LAMPNode01
#########################################################

variable "LAMPNode01-os_password" {
  type        = "string"
  description = "Operating System Password for the Operating System User to access virtual machine"
}

variable "LAMPNode01_folder" {
  description = "Target vSphere folder for virtual machine"
}

variable "LAMPNode01_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
}

variable "LAMPNode01_domain" {
  description = "Domain Name of virtual machine"
}

variable "LAMPNode01_number_of_vcpu" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
  default     = "2"
}

variable "LAMPNode01_memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
  default     = "4096"
}

variable "LAMPNode01_cluster" {
  description = "Target vSphere cluster to host the virtual machine"
}

variable "LAMPNode01_resource_pool" {
  description = "Target vSphere Resource Pool to host the virtual machine"
}

variable "LAMPNode01_dns_suffixes" {
  type        = "list"
  description = "Name resolution suffixes for the virtual network adapter"
}

variable "LAMPNode01_dns_servers" {
  type        = "list"
  description = "DNS servers for the virtual network adapter"
}

variable "LAMPNode01_network_interface_label" {
  description = "vSphere port group or network label for virtual machine's vNIC"
}

variable "LAMPNode01_ipv4_gateway" {
  description = "IPv4 gateway for vNIC configuration"
}

variable "LAMPNode01_ipv4_address" {
  description = "IPv4 address for vNIC configuration"
}

variable "LAMPNode01_ipv4_prefix_length" {
  description = "IPv4 prefix length for vNIC configuration. The value must be a number between 8 and 32"
}

variable "LAMPNode01_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
  default     = "vmxnet3"
}

variable "LAMPNode01_root_disk_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
}

variable "LAMPNode01_root_disk_keep_on_remove" {
  type        = "string"
  description = "Delete template disk volume when the virtual machine is deleted"
  default     = "false"
}

variable "LAMPNode01_root_disk_size" {
  description = "Size of template disk volume. Should be equal to template's disk size"
  default     = "100"
}

module "provision_proxy" {
  source 						= "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//vmware/proxy"
  ip                  = "${var.LAMPNode01_ipv4_address}"
  id									= "${vsphere_virtual_machine.LAMPNode01.id}"
  ssh_user            = "${var.LAMPNode01-os_admin_user}"
  ssh_password        = "${var.LAMPNode01-os_password}"
  http_proxy_host     = "${var.http_proxy_host}"
  http_proxy_user     = "${var.http_proxy_user}"
  http_proxy_password = "${var.http_proxy_password}"
  http_proxy_port     = "${var.http_proxy_port}"
  enable							= "${ length(var.http_proxy_host) > 0 ? "true" : "false"}"
}

# vsphere vm
resource "vsphere_virtual_machine" "LAMPNode01" {
  name             = "${var.LAMPNode01-name}"
  folder           = "${var.LAMPNode01_folder}"
  num_cpus         = "${var.LAMPNode01_number_of_vcpu}"
  memory           = "${var.LAMPNode01_memory}"
  resource_pool_id = "${data.vsphere_resource_pool.LAMPNode01_resource_pool.id}"
  datastore_id     = "${data.vsphere_datastore.LAMPNode01_datastore.id}"
  guest_id         = "${data.vsphere_virtual_machine.LAMPNode01_template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.LAMPNode01_template.scsi_type}"

  clone {
    template_uuid = "${data.vsphere_virtual_machine.LAMPNode01_template.id}"

    customize {
      linux_options {
        domain    = "${var.LAMPNode01_domain}"
        host_name = "${var.LAMPNode01-name}"
      }

      network_interface {
        ipv4_address = "${var.LAMPNode01_ipv4_address}"
        ipv4_netmask = "${var.LAMPNode01_ipv4_prefix_length}"
      }

      ipv4_gateway    = "${var.LAMPNode01_ipv4_gateway}"
      dns_suffix_list = "${var.LAMPNode01_dns_suffixes}"
      dns_server_list = "${var.LAMPNode01_dns_servers}"
    }
  }

  network_interface {
    network_id   = "${data.vsphere_network.LAMPNode01_network.id}"
    adapter_type = "${var.LAMPNode01_adapter_type}"
  }

  disk {
    label          = "${var.LAMPNode01-name}.disk0"
    size           = "${var.LAMPNode01_root_disk_size}"
    keep_on_remove = "${var.LAMPNode01_root_disk_keep_on_remove}"
  }

  # Specify the connection
  connection {
    type     = "ssh"
    user     = "${var.LAMPNode01-os_admin_user}"
    password = "${var.LAMPNode01-os_password}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "LAMPNode01_add_ssh_key.sh"

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
      "bash -c 'chmod +x LAMPNode01_add_ssh_key.sh'",
      "bash -c './LAMPNode01_add_ssh_key.sh  \"${var.LAMPNode01-os_admin_user}\" \"${var.user_public_ssh_key}\" \"${var.ibm_pm_public_ssh_key}\">> LAMPNode01_add_ssh_key.log 2>&1'",
    ]
  }
}

#########################################################
##### Resource : LAMPNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "LAMPNode01_chef_bootstrap_comp" {
  depends_on      = ["camc_vaultitem.VaultItem", "vsphere_virtual_machine.LAMPNode01", "module.provision_proxy"]
  name            = "LAMPNode01_chef_bootstrap_comp"
  camc_endpoint   = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LAMPNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LAMPNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LAMPNode01-name}",
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
##### Resource : LAMPNode01_httpd24-base-install
#########################################################

resource "camc_softwaredeploy" "LAMPNode01_httpd24-base-install" {
  depends_on      = ["camc_bootstrap.LAMPNode01_chef_bootstrap_comp"]
  name            = "LAMPNode01_httpd24-base-install"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LAMPNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LAMPNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LAMPNode01-name}",
  "runlist": "role[httpd24-base-install]",
  "node_attributes": {
    "httpd": {
      "data_dir_mode": "${var.LAMPNode01_httpd_data_dir_mode}",
      "document_root": "${var.LAMPNode01_httpd_document_root}",
      "listen": "${var.LAMPNode01_httpd_listen}",
      "log_dir": "${var.LAMPNode01_httpd_log_dir}",
      "log_level": "${var.LAMPNode01_httpd_log_level}",
      "os_users": {
        "web_content_owner": {
          "gid": "${var.LAMPNode01_httpd_os_users_web_content_owner_gid}",
          "home": "${var.LAMPNode01_httpd_os_users_web_content_owner_home}",
          "ldap_user": "${var.LAMPNode01_httpd_os_users_web_content_owner_ldap_user}",
          "name": "${var.LAMPNode01_httpd_os_users_web_content_owner_name}",
          "shell": "${var.LAMPNode01_httpd_os_users_web_content_owner_shell}"
        }
      },
      "php_mod_enabled": "${var.LAMPNode01_httpd_php_mod_enabled}",
      "server_admin": "${var.LAMPNode01_httpd_server_admin}",
      "server_name": "${var.LAMPNode01_httpd_server_name}",
      "version": "${var.LAMPNode01_httpd_version}",
      "vhosts_enabled": "${var.LAMPNode01_httpd_vhosts_enabled}"
    },
    "ibm": {
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[httpd24-base-install]"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

#########################################################
##### Resource : LAMPNode01_oracle_mysql_base
#########################################################

resource "camc_softwaredeploy" "LAMPNode01_oracle_mysql_base" {
  depends_on      = ["camc_softwaredeploy.LAMPNode01_httpd24-base-install"]
  name            = "LAMPNode01_oracle_mysql_base"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.LAMPNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.LAMPNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.LAMPNode01-name}",
  "runlist": "role[oracle_mysql_base]",
  "node_attributes": {
    "ibm": {
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[oracle_mysql_base]"
    },
    "mysql": {
      "config": {
        "data_dir": "${var.LAMPNode01_mysql_config_data_dir}",
        "databases": {
          "database_1": {
            "database_name": "${var.LAMPNode01_mysql_config_databases_database_1_database_name}",
            "users": {
              "user_1": {
                "name": "${var.LAMPNode01_mysql_config_databases_database_1_users_user_1_name}"
              },
              "user_2": {
                "name": "${var.LAMPNode01_mysql_config_databases_database_1_users_user_2_name}"
              }
            }
          }
        },
        "log_file": "${var.LAMPNode01_mysql_config_log_file}",
        "port": "${var.LAMPNode01_mysql_config_port}"
      },
      "install_from_repo": "${var.LAMPNode01_mysql_install_from_repo}",
      "os_users": {
        "daemon": {
          "gid": "${var.LAMPNode01_mysql_os_users_daemon_gid}",
          "home": "${var.LAMPNode01_mysql_os_users_daemon_home}",
          "ldap_user": "${var.LAMPNode01_mysql_os_users_daemon_ldap_user}",
          "name": "${var.LAMPNode01_mysql_os_users_daemon_name}",
          "shell": "${var.LAMPNode01_mysql_os_users_daemon_shell}"
        }
      },
      "version": "${var.LAMPNode01_mysql_version}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      },
      "mysql": {
        "config": {
          "databases": {
            "database_1": {
              "users": {
                "user_1": {
                  "password": "${var.LAMPNode01_mysql_config_databases_database_1_users_user_1_password}"
                },
                "user_2": {
                  "password": "${var.LAMPNode01_mysql_config_databases_database_1_users_user_2_password}"
                }
              }
            }
          }
        },
        "root_password": "${var.LAMPNode01_mysql_root_password}"
      }
    },
    "vault": "${var.ibm_stack_id}"
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

output "LAMPNode01_ip" {
  value = "VM IP Address : ${vsphere_virtual_machine.LAMPNode01.clone.0.customize.0.network_interface.0.ipv4_address}"
}

output "LAMPNode01_name" {
  value = "${var.LAMPNode01-name}"
}

output "LAMPNode01_roles" {
  value = "httpd24-base-install,oracle_mysql_base"
}

output "stack_id" {
  value = "${var.ibm_stack_id}"
}
