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

# This is a terraform generated template generated from apache_tomcat_v8_standalone

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
data "vsphere_datacenter" "TomcatNode01_datacenter" {
  name = "${var.TomcatNode01_datacenter}"
}

data "vsphere_datastore" "TomcatNode01_datastore" {
  name          = "${var.TomcatNode01_root_disk_datastore}"
  datacenter_id = "${data.vsphere_datacenter.TomcatNode01_datacenter.id}"
}

data "vsphere_resource_pool" "TomcatNode01_resource_pool" {
  name          = "${var.TomcatNode01_resource_pool}"
  datacenter_id = "${data.vsphere_datacenter.TomcatNode01_datacenter.id}"
}

data "vsphere_network" "TomcatNode01_network" {
  name          = "${var.TomcatNode01_network_interface_label}"
  datacenter_id = "${data.vsphere_datacenter.TomcatNode01_datacenter.id}"
}

data "vsphere_virtual_machine" "TomcatNode01_template" {
  name          = "${var.TomcatNode01-image}"
  datacenter_id = "${data.vsphere_datacenter.TomcatNode01_datacenter.id}"
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

##### TomcatNode01 variables #####
#Variable : TomcatNode01-image
variable "TomcatNode01-image" {
  type        = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
}

#Variable : TomcatNode01-name
variable "TomcatNode01-name" {
  type        = "string"
  description = "Short hostname of virtual machine"
}

#Variable : TomcatNode01-os_admin_user
variable "TomcatNode01-os_admin_user" {
  type        = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : TomcatNode01_tomcat_http_port
variable "TomcatNode01_tomcat_http_port" {
  type        = "string"
  description = "The Tomcat port to service HTTP requests."
  default     = "8080"
}

#Variable : TomcatNode01_tomcat_install_dir
variable "TomcatNode01_tomcat_install_dir" {
  type        = "string"
  description = "Specifies the directory to install Tomcat."
  default     = "/opt/tomcat8"
}

#Variable : TomcatNode01_tomcat_instance_dirs_log_dir
variable "TomcatNode01_tomcat_instance_dirs_log_dir" {
  type        = "string"
  description = "Specifies the directory for Tomcat log files."
  default     = "/var/log/tomcat8"
}

#Variable : TomcatNode01_tomcat_instance_dirs_temp_dir
variable "TomcatNode01_tomcat_instance_dirs_temp_dir" {
  type        = "string"
  description = "Specifies the temporary directory for Tomcat."
  default     = "/var/tmp/tomcat8/temp"
}

#Variable : TomcatNode01_tomcat_instance_dirs_webapps_dir
variable "TomcatNode01_tomcat_instance_dirs_webapps_dir" {
  type        = "string"
  description = "Specifies the Tomcat directory for web applications."
  default     = "/var/lib/tomcat8/webapps"
}

#Variable : TomcatNode01_tomcat_instance_dirs_work_dir
variable "TomcatNode01_tomcat_instance_dirs_work_dir" {
  type        = "string"
  description = "Specifies the Tomcat working directory."
  default     = "/var/tmp/tomcat8/work"
}

#Variable : TomcatNode01_tomcat_java_java_sdk
variable "TomcatNode01_tomcat_java_java_sdk" {
  type        = "string"
  description = "Specifies the use of a Java Development Kit (false) or Runtime Environment (true)."
  default     = "false"
}

#Variable : TomcatNode01_tomcat_java_vendor
variable "TomcatNode01_tomcat_java_vendor" {
  type        = "string"
  description = "Currently only openjdk is supported as the Tomcat java vendor."
  default     = "openjdk"
}

#Variable : TomcatNode01_tomcat_java_version
variable "TomcatNode01_tomcat_java_version" {
  type        = "string"
  description = "The version of Java to be used for Tomcat."
  default     = "1.8.0"
}

#Variable : TomcatNode01_tomcat_os_users_daemon_gid
variable "TomcatNode01_tomcat_os_users_daemon_gid" {
  type        = "string"
  description = "Specifies the name of the Operating System group for Tomcat daemon users."
  default     = "tomcat"
}

#Variable : TomcatNode01_tomcat_os_users_daemon_ldap_user
variable "TomcatNode01_tomcat_os_users_daemon_ldap_user" {
  type        = "string"
  description = "Specifies whether the Tomcat daemon user is stored in LDAP."
  default     = "false"
}

#Variable : TomcatNode01_tomcat_os_users_daemon_name
variable "TomcatNode01_tomcat_os_users_daemon_name" {
  type        = "string"
  description = "Specifies the user for the Tomcat daemon."
  default     = "tomcat"
}

#Variable : TomcatNode01_tomcat_ssl_enabled
variable "TomcatNode01_tomcat_ssl_enabled" {
  type        = "string"
  description = "Indicates whether to enable the Tomcat SSL connector."
  default     = "true"
}

#Variable : TomcatNode01_tomcat_ssl_keystore_password
variable "TomcatNode01_tomcat_ssl_keystore_password" {
  type        = "string"
  description = "The keystore password used in Tomcat for SSL configuration."
}

#Variable : TomcatNode01_tomcat_ssl_port
variable "TomcatNode01_tomcat_ssl_port" {
  type        = "string"
  description = "Tomcat port for SSL communication"
  default     = "8443"
}

#Variable : TomcatNode01_tomcat_ui_control_all_roles_admin-gui
variable "TomcatNode01_tomcat_ui_control_all_roles_admin-gui" {
  type        = "string"
  description = "Tomcat role admin-gui"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_all_roles_manager-gui
variable "TomcatNode01_tomcat_ui_control_all_roles_manager-gui" {
  type        = "string"
  description = "Tomcat role manager-gui"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_all_roles_manager-jmx
variable "TomcatNode01_tomcat_ui_control_all_roles_manager-jmx" {
  type        = "string"
  description = "Tomcat role manager-jmx"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_all_roles_manager-script
variable "TomcatNode01_tomcat_ui_control_all_roles_manager-script" {
  type        = "string"
  description = "Tomcat role manager-script"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_all_roles_manager-status
variable "TomcatNode01_tomcat_ui_control_all_roles_manager-status" {
  type        = "string"
  description = "Tomcat role manager-status"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_name
variable "TomcatNode01_tomcat_ui_control_users_administrator_name" {
  type        = "string"
  description = "Name of the admin user to be configured in Tomcat."
  default     = "admin"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_password
variable "TomcatNode01_tomcat_ui_control_users_administrator_password" {
  type        = "string"
  description = "Password of the admin user to be configured in Tomcat."
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_status
variable "TomcatNode01_tomcat_ui_control_users_administrator_status" {
  type        = "string"
  description = "Specifies whether to enable the admin user in the Tomcat configuration."
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_user_roles_admin-gui
variable "TomcatNode01_tomcat_ui_control_users_administrator_user_roles_admin-gui" {
  type        = "string"
  description = "Tomcat users administrator role admin-gui"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-gui
variable "TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-gui" {
  type        = "string"
  description = "Tomcat users administrator role manager-gui"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-jmx
variable "TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-jmx" {
  type        = "string"
  description = "Tomcat users administrator role manager-jmx"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-script
variable "TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-script" {
  type        = "string"
  description = "Tomcat users administrator role manager-script"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-status
variable "TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-status" {
  type        = "string"
  description = "Tomcat users administrator role manager-status"
  default     = "enabled"
}

#Variable : TomcatNode01_tomcat_version
variable "TomcatNode01_tomcat_version" {
  type        = "string"
  description = "The version of Tomcat to be installed."
  default     = "8.0.15"
}

##### virtualmachine variables #####

#########################################################
##### Resource : TomcatNode01
#########################################################

variable "TomcatNode01-os_password" {
  type        = "string"
  description = "Operating System Password for the Operating System User to access virtual machine"
}

variable "TomcatNode01_folder" {
  description = "Target vSphere folder for virtual machine"
}

variable "TomcatNode01_datacenter" {
  description = "Target vSphere datacenter for virtual machine creation"
}

variable "TomcatNode01_domain" {
  description = "Domain Name of virtual machine"
}

variable "TomcatNode01_number_of_vcpu" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
  default     = "2"
}

variable "TomcatNode01_memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
  default     = "4096"
}

variable "TomcatNode01_cluster" {
  description = "Target vSphere cluster to host the virtual machine"
}

variable "TomcatNode01_resource_pool" {
  description = "Target vSphere Resource Pool to host the virtual machine"
}

variable "TomcatNode01_dns_suffixes" {
  type        = "list"
  description = "Name resolution suffixes for the virtual network adapter"
}

variable "TomcatNode01_dns_servers" {
  type        = "list"
  description = "DNS servers for the virtual network adapter"
}

variable "TomcatNode01_network_interface_label" {
  description = "vSphere port group or network label for virtual machine's vNIC"
}

variable "TomcatNode01_ipv4_gateway" {
  description = "IPv4 gateway for vNIC configuration"
}

variable "TomcatNode01_ipv4_address" {
  description = "IPv4 address for vNIC configuration"
}

variable "TomcatNode01_ipv4_prefix_length" {
  description = "IPv4 prefix length for vNIC configuration. The value must be a number between 8 and 32"
}

variable "TomcatNode01_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
  default     = "vmxnet3"
}

variable "TomcatNode01_root_disk_datastore" {
  description = "Data store or storage cluster name for target virtual machine's disks"
}

variable "TomcatNode01_root_disk_keep_on_remove" {
  type        = "string"
  description = "Delete template disk volume when the virtual machine is deleted"
  default     = "false"
}

variable "TomcatNode01_root_disk_size" {
  description = "Size of template disk volume. Should be equal to template's disk size"
  default     = "100"
}

module "provision_proxy" {
  source 						= "git::https://github.com/IBM-CAMHub-Open/terraform-modules.git?ref=1.0//vmware/proxy"
  ip                  = "${var.TomcatNode01_ipv4_address}"
  id									= "${vsphere_virtual_machine.TomcatNode01.id}"
  ssh_user            = "${var.TomcatNode01-os_admin_user}"
  ssh_password        = "${var.TomcatNode01-os_password}"
  http_proxy_host     = "${var.http_proxy_host}"
  http_proxy_user     = "${var.http_proxy_user}"
  http_proxy_password = "${var.http_proxy_password}"
  http_proxy_port     = "${var.http_proxy_port}"
  enable							= "${ length(var.http_proxy_host) > 0 ? "true" : "false"}"
}

# vsphere vm
resource "vsphere_virtual_machine" "TomcatNode01" {
  name             = "${var.TomcatNode01-name}"
  folder           = "${var.TomcatNode01_folder}"
  num_cpus         = "${var.TomcatNode01_number_of_vcpu}"
  memory           = "${var.TomcatNode01_memory}"
  resource_pool_id = "${data.vsphere_resource_pool.TomcatNode01_resource_pool.id}"
  datastore_id     = "${data.vsphere_datastore.TomcatNode01_datastore.id}"
  guest_id         = "${data.vsphere_virtual_machine.TomcatNode01_template.guest_id}"
  scsi_type        = "${data.vsphere_virtual_machine.TomcatNode01_template.scsi_type}"

  clone {
    template_uuid = "${data.vsphere_virtual_machine.TomcatNode01_template.id}"

    customize {
      linux_options {
        domain    = "${var.TomcatNode01_domain}"
        host_name = "${var.TomcatNode01-name}"
      }

      network_interface {
        ipv4_address = "${var.TomcatNode01_ipv4_address}"
        ipv4_netmask = "${var.TomcatNode01_ipv4_prefix_length}"
      }

      ipv4_gateway    = "${var.TomcatNode01_ipv4_gateway}"
      dns_suffix_list = "${var.TomcatNode01_dns_suffixes}"
      dns_server_list = "${var.TomcatNode01_dns_servers}"
    }
  }

  network_interface {
    network_id   = "${data.vsphere_network.TomcatNode01_network.id}"
    adapter_type = "${var.TomcatNode01_adapter_type}"
  }

  disk {
    label          = "${var.TomcatNode01-name}.disk0"
    size           = "${var.TomcatNode01_root_disk_size}"
    keep_on_remove = "${var.TomcatNode01_root_disk_keep_on_remove}"
  }

  # Specify the connection
  connection {
    type     = "ssh"
    user     = "${var.TomcatNode01-os_admin_user}"
    password = "${var.TomcatNode01-os_password}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "TomcatNode01_add_ssh_key.sh"

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
      "bash -c 'chmod +x TomcatNode01_add_ssh_key.sh'",
      "bash -c './TomcatNode01_add_ssh_key.sh  \"${var.TomcatNode01-os_admin_user}\" \"${var.user_public_ssh_key}\" \"${var.ibm_pm_public_ssh_key}\">> TomcatNode01_add_ssh_key.log 2>&1'",
    ]
  }
}

#########################################################
##### Resource : TomcatNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "TomcatNode01_chef_bootstrap_comp" {
  depends_on      = ["camc_vaultitem.VaultItem", "vsphere_virtual_machine.TomcatNode01", "module.provision_proxy"]
  name            = "TomcatNode01_chef_bootstrap_comp"
  camc_endpoint   = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.TomcatNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.TomcatNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.TomcatNode01-name}",
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
##### Resource : TomcatNode01_tomcat
#########################################################

resource "camc_softwaredeploy" "TomcatNode01_tomcat" {
  depends_on      = ["camc_bootstrap.TomcatNode01_chef_bootstrap_comp"]
  name            = "TomcatNode01_tomcat"
  camc_endpoint   = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token    = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace           = true

  data = <<EOT
{
  "os_admin_user": "${var.TomcatNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${vsphere_virtual_machine.TomcatNode01.clone.0.customize.0.network_interface.0.ipv4_address}",
  "node_name": "${var.TomcatNode01-name}",
  "runlist": "role[tomcat]",
  "node_attributes": {
    "ibm": {
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[tomcat]"
    },
    "tomcat": {
      "http": {
        "port": "${var.TomcatNode01_tomcat_http_port}"
      },
      "install_dir": "${var.TomcatNode01_tomcat_install_dir}",
      "instance_dirs": {
        "log_dir": "${var.TomcatNode01_tomcat_instance_dirs_log_dir}",
        "temp_dir": "${var.TomcatNode01_tomcat_instance_dirs_temp_dir}",
        "webapps_dir": "${var.TomcatNode01_tomcat_instance_dirs_webapps_dir}",
        "work_dir": "${var.TomcatNode01_tomcat_instance_dirs_work_dir}"
      },
      "java": {
        "java_sdk": "${var.TomcatNode01_tomcat_java_java_sdk}",
        "vendor": "${var.TomcatNode01_tomcat_java_vendor}",
        "version": "${var.TomcatNode01_tomcat_java_version}"
      },
      "os_users": {
        "daemon": {
          "gid": "${var.TomcatNode01_tomcat_os_users_daemon_gid}",
          "ldap_user": "${var.TomcatNode01_tomcat_os_users_daemon_ldap_user}",
          "name": "${var.TomcatNode01_tomcat_os_users_daemon_name}"
        }
      },
      "ssl": {
        "enabled": "${var.TomcatNode01_tomcat_ssl_enabled}",
        "port": "${var.TomcatNode01_tomcat_ssl_port}"
      },
      "ui_control": {
        "all_roles": {
          "admin-gui": "${var.TomcatNode01_tomcat_ui_control_all_roles_admin-gui}",
          "manager-gui": "${var.TomcatNode01_tomcat_ui_control_all_roles_manager-gui}",
          "manager-jmx": "${var.TomcatNode01_tomcat_ui_control_all_roles_manager-jmx}",
          "manager-script": "${var.TomcatNode01_tomcat_ui_control_all_roles_manager-script}",
          "manager-status": "${var.TomcatNode01_tomcat_ui_control_all_roles_manager-status}"
        },
        "users": {
          "administrator": {
            "name": "${var.TomcatNode01_tomcat_ui_control_users_administrator_name}",
            "status": "${var.TomcatNode01_tomcat_ui_control_users_administrator_status}",
            "user_roles": {
              "admin-gui": "${var.TomcatNode01_tomcat_ui_control_users_administrator_user_roles_admin-gui}",
              "manager-gui": "${var.TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-gui}",
              "manager-jmx": "${var.TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-jmx}",
              "manager-script": "${var.TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-script}",
              "manager-status": "${var.TomcatNode01_tomcat_ui_control_users_administrator_user_roles_manager-status}"
            }
          }
        }
      },
      "version": "${var.TomcatNode01_tomcat_version}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      },
      "tomcat": {
        "ssl": {
          "keystore": {
            "password": "${var.TomcatNode01_tomcat_ssl_keystore_password}"
          }
        },
        "ui_control": {
          "users": {
            "administrator": {
              "password": "${var.TomcatNode01_tomcat_ui_control_users_administrator_password}"
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

output "TomcatNode01_ip" {
  value = "VM IP Address : ${vsphere_virtual_machine.TomcatNode01.clone.0.customize.0.network_interface.0.ipv4_address}"
}

output "TomcatNode01_name" {
  value = "${var.TomcatNode01-name}"
}

output "TomcatNode01_roles" {
  value = "tomcat"
}

output "stack_id" {
  value = "${var.ibm_stack_id}"
}
