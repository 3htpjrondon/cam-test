# =================================================================
# Copyright 2017 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

# This is a terraform generated template generated from ibm_wasnd_v9_multinode

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
  type = "string"
  description = "User defined public SSH key used to connect to the virtual machine. The format must be in openSSH."
  default = "None"
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
  label = "${var.ibm_pm_public_ssh_key_name}"
  most_recent = "true"
}

##############################################################
# Define pattern variables
##############################################################
##### unique stack name #####
variable "ibm_stack_name" {
  description = "A unique stack name."
}


##### Environment variables #####
#Variable : ibm_im_repo
variable "ibm_im_repo" {
  type = "string"
  description = "IBM Software  Installation Manager Repository URL (https://<hostname/IP>:<port>/IMRepo) "
}

#Variable : ibm_im_repo_password
variable "ibm_im_repo_password" {
  type = "string"
  description = "IBM Software  Installation Manager Repository Password"
}

#Variable : ibm_im_repo_user
variable "ibm_im_repo_user" {
  type = "string"
  description = "IBM Software  Installation Manager Repository username"
  default = "repouser"
}

#Variable : ibm_pm_access_token
variable "ibm_pm_access_token" {
  type = "string"
  description = "IBM Pattern Manager Access Token"
}

#Variable : ibm_pm_service
variable "ibm_pm_service" {
  type = "string"
  description = "IBM Pattern Manager Service"
}

#Variable : ibm_sw_repo
variable "ibm_sw_repo" {
  type = "string"
  description = "IBM Software Repo Root (https://<hostname>:<port>)"
}

#Variable : ibm_sw_repo_password
variable "ibm_sw_repo_password" {
  type = "string"
  description = "IBM Software Repo Password"
}

#Variable : ibm_sw_repo_user
variable "ibm_sw_repo_user" {
  type = "string"
  description = "IBM Software Repo Username"
  default = "repouser"
}


##### IHSNode01 variables #####
#Variable : IHSNode01-image
variable "IHSNode01-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "REDHAT_7_64"
}

#Variable : IHSNode01-name
variable "IHSNode01-name" {
  type = "string"
  description = "Short hostname of virtual machine"
}

#Variable : IHSNode01-os_admin_user
variable "IHSNode01-os_admin_user" {
  type = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : IHSNode01_ihs_admin_server_enabled
variable "IHSNode01_ihs_admin_server_enabled" {
  type = "string"
  description = "IBM HTTP Server Admin Server Enable(true/false)"
  default = "true"
}

#Variable : IHSNode01_ihs_admin_server_password
variable "IHSNode01_ihs_admin_server_password" {
  type = "string"
  description = "IBM HTTP Server Admin Server Password"
}

#Variable : IHSNode01_ihs_admin_server_port
variable "IHSNode01_ihs_admin_server_port" {
  type = "string"
  description = "IBM HTTP Server Admin Server Port Number"
  default = "8008"
}

#Variable : IHSNode01_ihs_admin_server_username
variable "IHSNode01_ihs_admin_server_username" {
  type = "string"
  description = "IBM HTTP Server Admin Server username"
  default = "ihsadmin"
}

#Variable : IHSNode01_ihs_install_dir
variable "IHSNode01_ihs_install_dir" {
  type = "string"
  description = "The directory to install IBM HTTP Server"
  default = "/opt/IBM/HTTPServer"
}

#Variable : IHSNode01_ihs_install_mode
variable "IHSNode01_ihs_install_mode" {
  type = "string"
  description = "The mode of installation for IBM HTTP Server"
  default = "nonAdmin"
}

#Variable : IHSNode01_ihs_java_legacy
variable "IHSNode01_ihs_java_legacy" {
  type = "string"
  description = "The Java version to be used with IBM HTTP Server version 8.5.5"
  default = "java8"
}

#Variable : IHSNode01_ihs_java_version
variable "IHSNode01_ihs_java_version" {
  type = "string"
  description = "The Java version to be used with IBM HTTP Server"
  default = "8.0.5.17"
}

#Variable : IHSNode01_ihs_os_users_ihs_gid
variable "IHSNode01_ihs_os_users_ihs_gid" {
  type = "string"
  description = "The group name for the IBM HTTP Server user"
  default = "ihsgrp"
}

#Variable : IHSNode01_ihs_os_users_ihs_name
variable "IHSNode01_ihs_os_users_ihs_name" {
  type = "string"
  description = "The username for IBM HTTP Server"
  default = "ihssrv"
}

#Variable : IHSNode01_ihs_os_users_ihs_shell
variable "IHSNode01_ihs_os_users_ihs_shell" {
  type = "string"
  description = "Location of the IBM HTTP Server operating system user shell"
  default = "/sbin/nologin"
}

#Variable : IHSNode01_ihs_plugin_enabled
variable "IHSNode01_ihs_plugin_enabled" {
  type = "string"
  description = "IBM HTTP Server Plugin Enabled"
  default = "true"
}

#Variable : IHSNode01_ihs_plugin_install_dir
variable "IHSNode01_ihs_plugin_install_dir" {
  type = "string"
  description = "IBM HTTP Server Plugin Installation Direcrtory"
  default = "/opt/IBM/WebSphere/Plugins"
}

#Variable : IHSNode01_ihs_plugin_was_webserver_name
variable "IHSNode01_ihs_plugin_was_webserver_name" {
  type = "string"
  description = "IBM HTTP Server Plugin Hostname, normally the FQDN"
  default = "webserver1"
}

#Variable : IHSNode01_ihs_port
variable "IHSNode01_ihs_port" {
  type = "string"
  description = "The IBM HTTP Server default port for HTTP requests"
  default = "8080"
}

#Variable : IHSNode01_ihs_version
variable "IHSNode01_ihs_version" {
  type = "string"
  description = "The version of IBM HTTP Server to install"
  default = "9.0.0.8"
}


##### Image Parameters variables #####

##### virtualmachine variables #####
#Variable : IHSNode01-mgmt-network-public
variable "IHSNode01-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}

#Variable : WASDMGRNode01-mgmt-network-public
variable "WASDMGRNode01-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}

#Variable : WASNode01-mgmt-network-public
variable "WASNode01-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}

#Variable : WASNode02-mgmt-network-public
variable "WASNode02-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}


##### WASDMGRNode01 variables #####
#Variable : WASDMGRNode01-image
variable "WASDMGRNode01-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "REDHAT_7_64"
}

#Variable : WASDMGRNode01-name
variable "WASDMGRNode01-name" {
  type = "string"
  description = "Short hostname of virtual machine"
}

#Variable : WASDMGRNode01-os_admin_user
variable "WASDMGRNode01-os_admin_user" {
  type = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : WASDMGRNode01_was_install_dir
variable "WASDMGRNode01_was_install_dir" {
  type = "string"
  description = "The installation root directory for the WebSphere Application Server product binaries"
  default = "/opt/IBM/WebSphere/AppServer"
}

#Variable : WASDMGRNode01_was_java_version
variable "WASDMGRNode01_was_java_version" {
  type = "string"
  description = "The Java SDK version that should be installed with the WebSphere Application Server. Example format is 8.0.4.70"
  default = "8.0.5.17"
}

#Variable : WASDMGRNode01_was_os_users_was_gid
variable "WASDMGRNode01_was_os_users_was_gid" {
  type = "string"
  description = "Operating system group name that will be assigned to the product installation"
  default = "wasgrp"
}

#Variable : WASDMGRNode01_was_os_users_was_home
variable "WASDMGRNode01_was_os_users_was_home" {
  type = "string"
  description = "Home directory location for operating system user that is used for product installation"
  default = "/home/wasadmin"
}

#Variable : WASDMGRNode01_was_os_users_was_ldap_user
variable "WASDMGRNode01_was_os_users_was_ldap_user" {
  type = "string"
  description = "A flag which indicates whether to create the WebSphere user locally, or utilize an LDAP based user"
  default = "false"
}

#Variable : WASDMGRNode01_was_os_users_was_name
variable "WASDMGRNode01_was_os_users_was_name" {
  type = "string"
  description = "Operating system userid that will be used to install the product. Userid will be created if it does not exist"
  default = "wasadmin"
}

#Variable : WASDMGRNode01_was_profile_dir
variable "WASDMGRNode01_was_profile_dir" {
  type = "string"
  description = "The directory path that contains WebSphere Application Server profiles"
  default = "/opt/IBM/WebSphere/AppServer/profiles"
}

#Variable : WASDMGRNode01_was_profiles_dmgr_cell
variable "WASDMGRNode01_was_profiles_dmgr_cell" {
  type = "string"
  description = "A cell name is a logical name for the group of nodes administered by the deployment manager cell"
  default = "cell01"
}

#Variable : WASDMGRNode01_was_profiles_dmgr_keystorepassword
variable "WASDMGRNode01_was_profiles_dmgr_keystorepassword" {
  type = "string"
  description = "Specifies the password to use on keystore created during profile creation"
}

#Variable : WASDMGRNode01_was_profiles_dmgr_profile
variable "WASDMGRNode01_was_profiles_dmgr_profile" {
  type = "string"
  description = "WebSphere Deployment Manager profile name"
  default = "Dmgr01"
}

#Variable : WASDMGRNode01_was_security_admin_user
variable "WASDMGRNode01_was_security_admin_user" {
  type = "string"
  description = "The username for securing the WebSphere adminstrative console"
  default = "wasadmin"
}

#Variable : WASDMGRNode01_was_security_admin_user_pwd
variable "WASDMGRNode01_was_security_admin_user_pwd" {
  type = "string"
  description = "The password for the WebSphere administrative account"
}

#Variable : WASDMGRNode01_was_version
variable "WASDMGRNode01_was_version" {
  type = "string"
  description = "The release and fixpack level of WebSphere Application Server to be installed. Example formats are 8.5.5.12 or 9.0.0.8"
  default = "9.0.0.8"
}

#Variable : WASDMGRNode01_was_webserver_ihs_server_admin_port
variable "WASDMGRNode01_was_webserver_ihs_server_admin_port" {
  type = "string"
  description = "IBM HTTP Administrative Server Port.  Used for creating the web server definition"
  default = "8008"
}

#Variable : WASDMGRNode01_was_webserver_ihs_server_ihs_admin_user
variable "WASDMGRNode01_was_webserver_ihs_server_ihs_admin_user" {
  type = "string"
  description = "IBM HTTP administrative username. Used for creating the web server definition"
  default = "ihsadmin"
}

#Variable : WASDMGRNode01_was_webserver_ihs_server_install_dir
variable "WASDMGRNode01_was_webserver_ihs_server_install_dir" {
  type = "string"
  description = "Specify the HTTP Server installation directory. Used for creating the web server definition"
  default = "/opt/IBM/HTTPServer"
}

#Variable : WASDMGRNode01_was_webserver_ihs_server_webserver_name
variable "WASDMGRNode01_was_webserver_ihs_server_webserver_name" {
  type = "string"
  description = "Web server server name"
  default = "webserver1"
}

#Variable : WASDMGRNode01_was_webserver_ihs_server_webserver_port
variable "WASDMGRNode01_was_webserver_ihs_server_webserver_port" {
  type = "string"
  description = "IBM HTTP Server Listener Port that will receive requests on. Use for creating the web server definition"
  default = "8080"
}

#Variable : WASDMGRNode01_was_wsadmin_dmgr_jvmproperty_property_value_initial
variable "WASDMGRNode01_was_wsadmin_dmgr_jvmproperty_property_value_initial" {
  type = "string"
  description = "Minimum JVM heap size"
  default = "256"
}

#Variable : WASDMGRNode01_was_wsadmin_dmgr_jvmproperty_property_value_maximum
variable "WASDMGRNode01_was_wsadmin_dmgr_jvmproperty_property_value_maximum" {
  type = "string"
  description = "Maximum JVM heap size"
  default = "512"
}


##### WASNode01 variables #####
#Variable : WASNode01-image
variable "WASNode01-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "REDHAT_7_64"
}

#Variable : WASNode01-name
variable "WASNode01-name" {
  type = "string"
  description = "Short hostname of virtual machine"
}

#Variable : WASNode01-os_admin_user
variable "WASNode01-os_admin_user" {
  type = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : WASNode01_was_install_dir
variable "WASNode01_was_install_dir" {
  type = "string"
  description = "The installation root directory for the WebSphere Application Server product binaries"
  default = "/opt/IBM/WebSphere/AppServer"
}

#Variable : WASNode01_was_java_version
variable "WASNode01_was_java_version" {
  type = "string"
  description = "The Java SDK version that should be installed with the WebSphere Application Server. Example format is 8.0.4.70"
  default = "8.0.5.17"
}

#Variable : WASNode01_was_os_users_was_gid
variable "WASNode01_was_os_users_was_gid" {
  type = "string"
  description = "Operating system group name that will be assigned to the product installation"
  default = "wasgrp"
}

#Variable : WASNode01_was_os_users_was_home
variable "WASNode01_was_os_users_was_home" {
  type = "string"
  description = "Home directory location for operating system user that is used for product installation"
  default = "/home/wasadmin"
}

#Variable : WASNode01_was_os_users_was_ldap_user
variable "WASNode01_was_os_users_was_ldap_user" {
  type = "string"
  description = "A flag which indicates whether to create the WebSphere user locally, or utilize an LDAP based user"
  default = "false"
}

#Variable : WASNode01_was_os_users_was_name
variable "WASNode01_was_os_users_was_name" {
  type = "string"
  description = "Operating system userid that will be used to install the product. Userid will be created if it does not exist"
  default = "wasadmin"
}

#Variable : WASNode01_was_profile_dir
variable "WASNode01_was_profile_dir" {
  type = "string"
  description = "The directory path that contains WebSphere Application Server profiles"
  default = "/opt/IBM/WebSphere/AppServer/profiles"
}

#Variable : WASNode01_was_profiles_node_profile_keystorepassword
variable "WASNode01_was_profiles_node_profile_keystorepassword" {
  type = "string"
  description = "Specifies the password to use on all keystore files created during profile creation"
}

#Variable : WASNode01_was_profiles_node_profile_profile
variable "WASNode01_was_profiles_node_profile_profile" {
  type = "string"
  description = "Profile name for a custom profile"
  default = "AppSrv01"
}

#Variable : WASNode01_was_security_admin_user
variable "WASNode01_was_security_admin_user" {
  type = "string"
  description = "The username for securing the WebSphere adminstrative console"
  default = "wasadmin"
}

#Variable : WASNode01_was_security_admin_user_pwd
variable "WASNode01_was_security_admin_user_pwd" {
  type = "string"
  description = "The password for the WebSphere administrative account"
}

#Variable : WASNode01_was_version
variable "WASNode01_was_version" {
  type = "string"
  description = "The release and fixpack level of WebSphere Application Server to be installed. Example formats are 8.5.5.12 or 9.0.0.8"
  default = "9.0.0.8"
}

#Variable : WASNode01_was_wsadmin_clusters_cluster01_cluster_name
variable "WASNode01_was_wsadmin_clusters_cluster01_cluster_name" {
  type = "string"
  description = "Name of the cluster that will be created"
  default = "cluster01"
}

#Variable : WASNode01_was_wsadmin_clusters_cluster01_cluster_servers_cluster_server01_server_name
variable "WASNode01_was_wsadmin_clusters_cluster01_cluster_servers_cluster_server01_server_name" {
  type = "string"
  description = "Name of the cluster member that will created on each of the nodes"
  default = "server01"
}

#Variable : WASNode01_was_wsadmin_nodeagent_jvmproperty_property_value_initial
variable "WASNode01_was_wsadmin_nodeagent_jvmproperty_property_value_initial" {
  type = "string"
  description = "Minimum JVM heap size"
  default = "256"
}

#Variable : WASNode01_was_wsadmin_nodeagent_jvmproperty_property_value_maximum
variable "WASNode01_was_wsadmin_nodeagent_jvmproperty_property_value_maximum" {
  type = "string"
  description = "Maximum JVM heap size"
  default = "512"
}


##### WASNode02 variables #####
#Variable : WASNode02-image
variable "WASNode02-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "REDHAT_7_64"
}

#Variable : WASNode02-name
variable "WASNode02-name" {
  type = "string"
  description = "Short hostname of virtual machine"
}

#Variable : WASNode02-os_admin_user
variable "WASNode02-os_admin_user" {
  type = "string"
  description = "Name of the admin user account in the virtual machine that will be accessed via SSH"
}

#Variable : WASNode02_was_install_dir
variable "WASNode02_was_install_dir" {
  type = "string"
  description = "The installation root directory for the WebSphere Application Server product binaries"
  default = "/opt/IBM/WebSphere/AppServer"
}

#Variable : WASNode02_was_java_version
variable "WASNode02_was_java_version" {
  type = "string"
  description = "The Java SDK version that should be installed with the WebSphere Application Server. Example format is 8.0.4.70"
  default = "8.0.5.17"
}

#Variable : WASNode02_was_os_users_was_gid
variable "WASNode02_was_os_users_was_gid" {
  type = "string"
  description = "Operating system group name that will be assigned to the product installation"
  default = "wasgrp"
}

#Variable : WASNode02_was_os_users_was_home
variable "WASNode02_was_os_users_was_home" {
  type = "string"
  description = "Home directory location for operating system user that is used for product installation"
  default = "/home/wasadmin"
}

#Variable : WASNode02_was_os_users_was_ldap_user
variable "WASNode02_was_os_users_was_ldap_user" {
  type = "string"
  description = "A flag which indicates whether to create the WebSphere user locally, or utilize an LDAP based user"
  default = "false"
}

#Variable : WASNode02_was_os_users_was_name
variable "WASNode02_was_os_users_was_name" {
  type = "string"
  description = "Operating system userid that will be used to install the product. Userid will be created if it does not exist"
  default = "wasadmin"
}

#Variable : WASNode02_was_profile_dir
variable "WASNode02_was_profile_dir" {
  type = "string"
  description = "The directory path that contains WebSphere Application Server profiles"
  default = "/opt/IBM/WebSphere/AppServer/profiles"
}

#Variable : WASNode02_was_profiles_node_profile_keystorepassword
variable "WASNode02_was_profiles_node_profile_keystorepassword" {
  type = "string"
  description = "Specifies the password to use on all keystore files created during profile creation"
}

#Variable : WASNode02_was_profiles_node_profile_profile
variable "WASNode02_was_profiles_node_profile_profile" {
  type = "string"
  description = "Profile name for a custom profile"
  default = "AppSrv01"
}

#Variable : WASNode02_was_security_admin_user
variable "WASNode02_was_security_admin_user" {
  type = "string"
  description = "The username for securing the WebSphere adminstrative console"
  default = "wasadmin"
}

#Variable : WASNode02_was_security_admin_user_pwd
variable "WASNode02_was_security_admin_user_pwd" {
  type = "string"
  description = "The password for the WebSphere administrative account"
}

#Variable : WASNode02_was_version
variable "WASNode02_was_version" {
  type = "string"
  description = "The release and fixpack level of WebSphere Application Server to be installed. Example formats are 8.5.5.12 or 9.0.0.8"
  default = "9.0.0.8"
}

#Variable : WASNode02_was_wsadmin_clusters_cluster01_cluster_name
variable "WASNode02_was_wsadmin_clusters_cluster01_cluster_name" {
  type = "string"
  description = "Name of the cluster that will be created"
  default = "cluster01"
}

#Variable : WASNode02_was_wsadmin_clusters_cluster01_cluster_servers_cluster_server01_server_name
variable "WASNode02_was_wsadmin_clusters_cluster01_cluster_servers_cluster_server01_server_name" {
  type = "string"
  description = "Name of the cluster member that will created on each of the nodes"
  default = "server01"
}

#Variable : WASNode02_was_wsadmin_nodeagent_jvmproperty_property_value_initial
variable "WASNode02_was_wsadmin_nodeagent_jvmproperty_property_value_initial" {
  type = "string"
  description = "Minimum JVM heap size"
  default = "256"
}

#Variable : WASNode02_was_wsadmin_nodeagent_jvmproperty_property_value_maximum
variable "WASNode02_was_wsadmin_nodeagent_jvmproperty_property_value_maximum" {
  type = "string"
  description = "Maximum JVM heap size"
  default = "512"
}


##### ungrouped variables #####
##### domain name #####
variable "runtime_domain" {
  description = "domain name"
  default = "cam.ibm.com"
}


#########################################################
##### Resource : IHSNode01
#########################################################


#Parameter : IHSNode01_datacenter
variable "IHSNode01_datacenter" {
  type = "string"
  description = "IBMCloud datacenter where infrastructure resources will be deployed"
  default = "dal05"
}


#Parameter : IHSNode01_private_network_only
variable "IHSNode01_private_network_only" {
  type = "string"
  description = "Provision the virtual machine with only private IP"
  default = "false"
}


#Parameter : IHSNode01_number_of_cores
variable "IHSNode01_number_of_cores" {
  type = "string"
  description = "Number of CPU cores, which is required to be a positive Integer"
  default = "2"
}


#Parameter : IHSNode01_memory
variable "IHSNode01_memory" {
  type = "string"
  description = "Amount of Memory (MBs), which is required to be one or more times of 1024"
  default = "4096"
}


#Parameter : IHSNode01_network_speed
variable "IHSNode01_network_speed" {
  type = "string"
  description = "Bandwidth of network communication applied to the virtual machine"
  default = "10"
}


#Parameter : IHSNode01_hourly_billing
variable "IHSNode01_hourly_billing" {
  type = "string"
  description = "Billing cycle: hourly billed or monthly billed"
  default = "true"
}


#Parameter : IHSNode01_dedicated_acct_host_only
variable "IHSNode01_dedicated_acct_host_only" {
  type = "string"
  description = "Shared or dedicated host, where dedicated host usually means higher performance and cost"
  default = "false"
}


#Parameter : IHSNode01_local_disk
variable "IHSNode01_local_disk" {
  type = "string"
  description = "User local disk or SAN disk"
  default = "false"
}

variable "IHSNode01_root_disk_size" {
  type = "string"
  description = "Root Disk Size - IHSNode01"
  default = "25"
}

resource "ibm_compute_vm_instance" "IHSNode01" {
  hostname = "${var.IHSNode01-name}"
  os_reference_code = "${var.IHSNode01-image}"
  domain = "${var.runtime_domain}"
  datacenter = "${var.IHSNode01_datacenter}"
  network_speed = "${var.IHSNode01_network_speed}"
  hourly_billing = "${var.IHSNode01_hourly_billing}"
  private_network_only = "${var.IHSNode01_private_network_only}"
  cores = "${var.IHSNode01_number_of_cores}"
  memory = "${var.IHSNode01_memory}"
  disks = ["${var.IHSNode01_root_disk_size}"]
  dedicated_acct_host_only = "${var.IHSNode01_dedicated_acct_host_only}"
  local_disk = "${var.IHSNode01_local_disk}"
  ssh_key_ids = ["${data.ibm_compute_ssh_key.ibm_pm_public_key.id}"]
  # Specify the ssh connection
  connection {
    user = "${var.IHSNode01-os_admin_user}"
    private_key = "${base64decode(var.ibm_pm_private_ssh_key)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "IHSNode01_add_ssh_key.sh"
    content     = <<EOF
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
      "bash -c 'chmod +x IHSNode01_add_ssh_key.sh'",
      "bash -c './IHSNode01_add_ssh_key.sh  \"${var.IHSNode01-os_admin_user}\" \"${var.user_public_ssh_key}\">> IHSNode01_add_ssh_key.log 2>&1'"
    ]
  }

}

#########################################################
##### Resource : IHSNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "IHSNode01_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","ibm_compute_vm_instance.IHSNode01"]
  name = "IHSNode01_chef_bootstrap_comp"
  camc_endpoint = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.IHSNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.IHSNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.IHSNode01.ipv4_address_private : ibm_compute_vm_instance.IHSNode01.ipv4_address}",
  "node_name": "${var.IHSNode01-name}",
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
##### Resource : IHSNode01_ihs-wasmode-nonadmin
#########################################################

resource "camc_softwaredeploy" "IHSNode01_ihs-wasmode-nonadmin" {
  depends_on = ["camc_softwaredeploy.WASDMGRNode01_was_create_dmgr"]
  name = "IHSNode01_ihs-wasmode-nonadmin"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.IHSNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.IHSNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.IHSNode01.ipv4_address_private : ibm_compute_vm_instance.IHSNode01.ipv4_address}",
  "node_name": "${var.IHSNode01-name}",
  "runlist": "role[ihs-wasmode-nonadmin]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[ihs-wasmode-nonadmin]"
    },
    "ihs": {
      "admin_server": {
        "enabled": "${var.IHSNode01_ihs_admin_server_enabled}",
        "port": "${var.IHSNode01_ihs_admin_server_port}",
        "username": "${var.IHSNode01_ihs_admin_server_username}"
      },
      "install_dir": "${var.IHSNode01_ihs_install_dir}",
      "install_mode": "${var.IHSNode01_ihs_install_mode}",
      "java": {
        "legacy": "${var.IHSNode01_ihs_java_legacy}",
        "version": "${var.IHSNode01_ihs_java_version}"
      },
      "os_users": {
        "ihs": {
          "gid": "${var.IHSNode01_ihs_os_users_ihs_gid}",
          "name": "${var.IHSNode01_ihs_os_users_ihs_name}",
          "shell": "${var.IHSNode01_ihs_os_users_ihs_shell}"
        }
      },
      "plugin": {
        "enabled": "${var.IHSNode01_ihs_plugin_enabled}",
        "install_dir": "${var.IHSNode01_ihs_plugin_install_dir}",
        "was_webserver_name": "${var.IHSNode01_ihs_plugin_was_webserver_name}"
      },
      "port": "${var.IHSNode01_ihs_port}",
      "version": "${var.IHSNode01_ihs_version}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "im_repo_password": "${var.ibm_im_repo_password}",
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      },
      "ihs": {
        "admin_server": {
          "password": "${var.IHSNode01_ihs_admin_server_password}"
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
  camc_endpoint = "${var.ibm_pm_service}/v1/vault_item/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
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


#########################################################
##### Resource : WASDMGRNode01
#########################################################


#Parameter : WASDMGRNode01_datacenter
variable "WASDMGRNode01_datacenter" {
  type = "string"
  description = "IBMCloud datacenter where infrastructure resources will be deployed"
  default = "dal05"
}


#Parameter : WASDMGRNode01_private_network_only
variable "WASDMGRNode01_private_network_only" {
  type = "string"
  description = "Provision the virtual machine with only private IP"
  default = "false"
}


#Parameter : WASDMGRNode01_number_of_cores
variable "WASDMGRNode01_number_of_cores" {
  type = "string"
  description = "Number of CPU cores, which is required to be a positive Integer"
  default = "2"
}


#Parameter : WASDMGRNode01_memory
variable "WASDMGRNode01_memory" {
  type = "string"
  description = "Amount of Memory (MBs), which is required to be one or more times of 1024"
  default = "4096"
}


#Parameter : WASDMGRNode01_network_speed
variable "WASDMGRNode01_network_speed" {
  type = "string"
  description = "Bandwidth of network communication applied to the virtual machine"
  default = "10"
}


#Parameter : WASDMGRNode01_hourly_billing
variable "WASDMGRNode01_hourly_billing" {
  type = "string"
  description = "Billing cycle: hourly billed or monthly billed"
  default = "true"
}


#Parameter : WASDMGRNode01_dedicated_acct_host_only
variable "WASDMGRNode01_dedicated_acct_host_only" {
  type = "string"
  description = "Shared or dedicated host, where dedicated host usually means higher performance and cost"
  default = "false"
}


#Parameter : WASDMGRNode01_local_disk
variable "WASDMGRNode01_local_disk" {
  type = "string"
  description = "User local disk or SAN disk"
  default = "false"
}

variable "WASDMGRNode01_root_disk_size" {
  type = "string"
  description = "Root Disk Size - WASDMGRNode01"
  default = "25"
}

resource "ibm_compute_vm_instance" "WASDMGRNode01" {
  hostname = "${var.WASDMGRNode01-name}"
  os_reference_code = "${var.WASDMGRNode01-image}"
  domain = "${var.runtime_domain}"
  datacenter = "${var.WASDMGRNode01_datacenter}"
  network_speed = "${var.WASDMGRNode01_network_speed}"
  hourly_billing = "${var.WASDMGRNode01_hourly_billing}"
  private_network_only = "${var.WASDMGRNode01_private_network_only}"
  cores = "${var.WASDMGRNode01_number_of_cores}"
  memory = "${var.WASDMGRNode01_memory}"
  disks = ["${var.WASDMGRNode01_root_disk_size}"]
  dedicated_acct_host_only = "${var.WASDMGRNode01_dedicated_acct_host_only}"
  local_disk = "${var.WASDMGRNode01_local_disk}"
  ssh_key_ids = ["${data.ibm_compute_ssh_key.ibm_pm_public_key.id}"]
  # Specify the ssh connection
  connection {
    user = "${var.WASDMGRNode01-os_admin_user}"
    private_key = "${base64decode(var.ibm_pm_private_ssh_key)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "WASDMGRNode01_add_ssh_key.sh"
    content     = <<EOF
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
      "bash -c 'chmod +x WASDMGRNode01_add_ssh_key.sh'",
      "bash -c './WASDMGRNode01_add_ssh_key.sh  \"${var.WASDMGRNode01-os_admin_user}\" \"${var.user_public_ssh_key}\">> WASDMGRNode01_add_ssh_key.log 2>&1'"
    ]
  }

}

#########################################################
##### Resource : WASDMGRNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "WASDMGRNode01_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","ibm_compute_vm_instance.WASDMGRNode01"]
  name = "WASDMGRNode01_chef_bootstrap_comp"
  camc_endpoint = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASDMGRNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASDMGRNode01.ipv4_address_private : ibm_compute_vm_instance.WASDMGRNode01.ipv4_address}",
  "node_name": "${var.WASDMGRNode01-name}",
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
##### Resource : WASDMGRNode01_was_create_dmgr
#########################################################

resource "camc_softwaredeploy" "WASDMGRNode01_was_create_dmgr" {
  depends_on = ["camc_softwaredeploy.WASDMGRNode01_was_v9_install","camc_softwaredeploy.WASNode01_was_v9_install","camc_softwaredeploy.WASNode02_was_v9_install"]
  name = "WASDMGRNode01_was_create_dmgr"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASDMGRNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASDMGRNode01.ipv4_address_private : ibm_compute_vm_instance.WASDMGRNode01.ipv4_address}",
  "node_name": "${var.WASDMGRNode01-name}",
  "runlist": "role[was_create_dmgr]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[was_create_dmgr]"
    },
    "was": {
      "profiles": {
        "dmgr": {
          "cell": "${var.WASDMGRNode01_was_profiles_dmgr_cell}",
          "profile": "${var.WASDMGRNode01_was_profiles_dmgr_profile}"
        }
      },
      "wsadmin": {
        "dmgr": {
          "jvmproperty": {
            "property_value_initial": "${var.WASDMGRNode01_was_wsadmin_dmgr_jvmproperty_property_value_initial}",
            "property_value_maximum": "${var.WASDMGRNode01_was_wsadmin_dmgr_jvmproperty_property_value_maximum}"
          }
        }
      }
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "was": {
        "profiles": {
          "dmgr": {
            "keystorepassword": "${var.WASDMGRNode01_was_profiles_dmgr_keystorepassword}"
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
##### Resource : WASDMGRNode01_was_create_webserver
#########################################################

resource "camc_softwaredeploy" "WASDMGRNode01_was_create_webserver" {
  depends_on = ["camc_softwaredeploy.WASNode02_was_create_clusters_and_members"]
  name = "WASDMGRNode01_was_create_webserver"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASDMGRNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASDMGRNode01.ipv4_address_private : ibm_compute_vm_instance.WASDMGRNode01.ipv4_address}",
  "node_name": "${var.WASDMGRNode01-name}",
  "runlist": "role[was_create_webserver]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[was_create_webserver]"
    },
    "was": {
      "webserver": {
        "ihs_server": {
          "admin_port": "${var.WASDMGRNode01_was_webserver_ihs_server_admin_port}",
          "ihs_admin_user": "${var.WASDMGRNode01_was_webserver_ihs_server_ihs_admin_user}",
          "install_dir": "${var.WASDMGRNode01_was_webserver_ihs_server_install_dir}",
          "webserver_name": "${var.WASDMGRNode01_was_webserver_ihs_server_webserver_name}",
          "webserver_port": "${var.WASDMGRNode01_was_webserver_ihs_server_webserver_port}"
        }
      }
    }
  }
}
EOT
}


#########################################################
##### Resource : WASDMGRNode01_was_v9_install
#########################################################

resource "camc_softwaredeploy" "WASDMGRNode01_was_v9_install" {
  depends_on = ["camc_bootstrap.WASDMGRNode01_chef_bootstrap_comp","camc_bootstrap.WASNode01_chef_bootstrap_comp","camc_bootstrap.WASNode02_chef_bootstrap_comp","camc_bootstrap.IHSNode01_chef_bootstrap_comp"]
  name = "WASDMGRNode01_was_v9_install"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASDMGRNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASDMGRNode01.ipv4_address_private : ibm_compute_vm_instance.WASDMGRNode01.ipv4_address}",
  "node_name": "${var.WASDMGRNode01-name}",
  "runlist": "role[was_v9_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[was_v9_install]"
    },
    "was": {
      "install_dir": "${var.WASDMGRNode01_was_install_dir}",
      "java_version": "${var.WASDMGRNode01_was_java_version}",
      "os_users": {
        "was": {
          "gid": "${var.WASDMGRNode01_was_os_users_was_gid}",
          "home": "${var.WASDMGRNode01_was_os_users_was_home}",
          "ldap_user": "${var.WASDMGRNode01_was_os_users_was_ldap_user}",
          "name": "${var.WASDMGRNode01_was_os_users_was_name}"
        }
      },
      "profile_dir": "${var.WASDMGRNode01_was_profile_dir}",
      "security": {
        "admin_user": "${var.WASDMGRNode01_was_security_admin_user}"
      },
      "version": "${var.WASDMGRNode01_was_version}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "im_repo_password": "${var.ibm_im_repo_password}",
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      },
      "was": {
        "security": {
          "admin_user_pwd": "${var.WASDMGRNode01_was_security_admin_user_pwd}"
        }
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}


#########################################################
##### Resource : WASNode01
#########################################################


#Parameter : WASNode01_datacenter
variable "WASNode01_datacenter" {
  type = "string"
  description = "IBMCloud datacenter where infrastructure resources will be deployed"
  default = "dal05"
}


#Parameter : WASNode01_private_network_only
variable "WASNode01_private_network_only" {
  type = "string"
  description = "Provision the virtual machine with only private IP"
  default = "false"
}


#Parameter : WASNode01_number_of_cores
variable "WASNode01_number_of_cores" {
  type = "string"
  description = "Number of CPU cores, which is required to be a positive Integer"
  default = "2"
}


#Parameter : WASNode01_memory
variable "WASNode01_memory" {
  type = "string"
  description = "Amount of Memory (MBs), which is required to be one or more times of 1024"
  default = "4096"
}


#Parameter : WASNode01_network_speed
variable "WASNode01_network_speed" {
  type = "string"
  description = "Bandwidth of network communication applied to the virtual machine"
  default = "10"
}


#Parameter : WASNode01_hourly_billing
variable "WASNode01_hourly_billing" {
  type = "string"
  description = "Billing cycle: hourly billed or monthly billed"
  default = "true"
}


#Parameter : WASNode01_dedicated_acct_host_only
variable "WASNode01_dedicated_acct_host_only" {
  type = "string"
  description = "Shared or dedicated host, where dedicated host usually means higher performance and cost"
  default = "false"
}


#Parameter : WASNode01_local_disk
variable "WASNode01_local_disk" {
  type = "string"
  description = "User local disk or SAN disk"
  default = "false"
}

variable "WASNode01_root_disk_size" {
  type = "string"
  description = "Root Disk Size - WASNode01"
  default = "25"
}

resource "ibm_compute_vm_instance" "WASNode01" {
  hostname = "${var.WASNode01-name}"
  os_reference_code = "${var.WASNode01-image}"
  domain = "${var.runtime_domain}"
  datacenter = "${var.WASNode01_datacenter}"
  network_speed = "${var.WASNode01_network_speed}"
  hourly_billing = "${var.WASNode01_hourly_billing}"
  private_network_only = "${var.WASNode01_private_network_only}"
  cores = "${var.WASNode01_number_of_cores}"
  memory = "${var.WASNode01_memory}"
  disks = ["${var.WASNode01_root_disk_size}"]
  dedicated_acct_host_only = "${var.WASNode01_dedicated_acct_host_only}"
  local_disk = "${var.WASNode01_local_disk}"
  ssh_key_ids = ["${data.ibm_compute_ssh_key.ibm_pm_public_key.id}"]
  # Specify the ssh connection
  connection {
    user = "${var.WASNode01-os_admin_user}"
    private_key = "${base64decode(var.ibm_pm_private_ssh_key)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "WASNode01_add_ssh_key.sh"
    content     = <<EOF
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
      "bash -c 'chmod +x WASNode01_add_ssh_key.sh'",
      "bash -c './WASNode01_add_ssh_key.sh  \"${var.WASNode01-os_admin_user}\" \"${var.user_public_ssh_key}\">> WASNode01_add_ssh_key.log 2>&1'"
    ]
  }

}

#########################################################
##### Resource : WASNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "WASNode01_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","ibm_compute_vm_instance.WASNode01"]
  name = "WASNode01_chef_bootstrap_comp"
  camc_endpoint = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode01.ipv4_address_private : ibm_compute_vm_instance.WASNode01.ipv4_address}",
  "node_name": "${var.WASNode01-name}",
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
##### Resource : WASNode01_was_create_clusters_and_members
#########################################################

resource "camc_softwaredeploy" "WASNode01_was_create_clusters_and_members" {
  depends_on = ["camc_softwaredeploy.WASNode02_was_create_nodeagent"]
  name = "WASNode01_was_create_clusters_and_members"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode01.ipv4_address_private : ibm_compute_vm_instance.WASNode01.ipv4_address}",
  "node_name": "${var.WASNode01-name}",
  "runlist": "role[was_create_clusters_and_members]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[was_create_clusters_and_members]"
    },
    "was": {
      "wsadmin": {
        "clusters": {
          "cluster01": {
            "cluster_name": "${var.WASNode01_was_wsadmin_clusters_cluster01_cluster_name}",
            "cluster_servers": {
              "cluster_server01": {
                "server_name": "${var.WASNode01_was_wsadmin_clusters_cluster01_cluster_servers_cluster_server01_server_name}"
              }
            }
          }
        }
      }
    }
  }
}
EOT
}


#########################################################
##### Resource : WASNode01_was_create_nodeagent
#########################################################

resource "camc_softwaredeploy" "WASNode01_was_create_nodeagent" {
  depends_on = ["camc_softwaredeploy.WASDMGRNode01_was_create_dmgr"]
  name = "WASNode01_was_create_nodeagent"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode01.ipv4_address_private : ibm_compute_vm_instance.WASNode01.ipv4_address}",
  "node_name": "${var.WASNode01-name}",
  "runlist": "role[was_create_nodeagent]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[was_create_nodeagent]"
    },
    "was": {
      "profiles": {
        "node_profile": {
          "profile": "${var.WASNode01_was_profiles_node_profile_profile}"
        }
      },
      "wsadmin": {
        "nodeagent": {
          "jvmproperty": {
            "property_value_initial": "${var.WASNode01_was_wsadmin_nodeagent_jvmproperty_property_value_initial}",
            "property_value_maximum": "${var.WASNode01_was_wsadmin_nodeagent_jvmproperty_property_value_maximum}"
          }
        }
      }
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "was": {
        "profiles": {
          "node_profile": {
            "keystorepassword": "${var.WASNode01_was_profiles_node_profile_keystorepassword}"
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
##### Resource : WASNode01_was_v9_install
#########################################################

resource "camc_softwaredeploy" "WASNode01_was_v9_install" {
  depends_on = ["camc_bootstrap.WASDMGRNode01_chef_bootstrap_comp","camc_bootstrap.WASNode01_chef_bootstrap_comp","camc_bootstrap.WASNode02_chef_bootstrap_comp","camc_bootstrap.IHSNode01_chef_bootstrap_comp"]
  name = "WASNode01_was_v9_install"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode01.ipv4_address_private : ibm_compute_vm_instance.WASNode01.ipv4_address}",
  "node_name": "${var.WASNode01-name}",
  "runlist": "role[was_v9_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[was_v9_install]"
    },
    "was": {
      "install_dir": "${var.WASNode01_was_install_dir}",
      "java_version": "${var.WASNode01_was_java_version}",
      "os_users": {
        "was": {
          "gid": "${var.WASNode01_was_os_users_was_gid}",
          "home": "${var.WASNode01_was_os_users_was_home}",
          "ldap_user": "${var.WASNode01_was_os_users_was_ldap_user}",
          "name": "${var.WASNode01_was_os_users_was_name}"
        }
      },
      "profile_dir": "${var.WASNode01_was_profile_dir}",
      "security": {
        "admin_user": "${var.WASNode01_was_security_admin_user}"
      },
      "version": "${var.WASNode01_was_version}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "im_repo_password": "${var.ibm_im_repo_password}",
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      },
      "was": {
        "security": {
          "admin_user_pwd": "${var.WASNode01_was_security_admin_user_pwd}"
        }
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}


#########################################################
##### Resource : WASNode02
#########################################################


#Parameter : WASNode02_datacenter
variable "WASNode02_datacenter" {
  type = "string"
  description = "IBMCloud datacenter where infrastructure resources will be deployed"
  default = "dal05"
}


#Parameter : WASNode02_private_network_only
variable "WASNode02_private_network_only" {
  type = "string"
  description = "Provision the virtual machine with only private IP"
  default = "false"
}


#Parameter : WASNode02_number_of_cores
variable "WASNode02_number_of_cores" {
  type = "string"
  description = "Number of CPU cores, which is required to be a positive Integer"
  default = "2"
}


#Parameter : WASNode02_memory
variable "WASNode02_memory" {
  type = "string"
  description = "Amount of Memory (MBs), which is required to be one or more times of 1024"
  default = "4096"
}


#Parameter : WASNode02_network_speed
variable "WASNode02_network_speed" {
  type = "string"
  description = "Bandwidth of network communication applied to the virtual machine"
  default = "10"
}


#Parameter : WASNode02_hourly_billing
variable "WASNode02_hourly_billing" {
  type = "string"
  description = "Billing cycle: hourly billed or monthly billed"
  default = "true"
}


#Parameter : WASNode02_dedicated_acct_host_only
variable "WASNode02_dedicated_acct_host_only" {
  type = "string"
  description = "Shared or dedicated host, where dedicated host usually means higher performance and cost"
  default = "false"
}


#Parameter : WASNode02_local_disk
variable "WASNode02_local_disk" {
  type = "string"
  description = "User local disk or SAN disk"
  default = "false"
}

variable "WASNode02_root_disk_size" {
  type = "string"
  description = "Root Disk Size - WASNode02"
  default = "25"
}

resource "ibm_compute_vm_instance" "WASNode02" {
  hostname = "${var.WASNode02-name}"
  os_reference_code = "${var.WASNode02-image}"
  domain = "${var.runtime_domain}"
  datacenter = "${var.WASNode02_datacenter}"
  network_speed = "${var.WASNode02_network_speed}"
  hourly_billing = "${var.WASNode02_hourly_billing}"
  private_network_only = "${var.WASNode02_private_network_only}"
  cores = "${var.WASNode02_number_of_cores}"
  memory = "${var.WASNode02_memory}"
  disks = ["${var.WASNode02_root_disk_size}"]
  dedicated_acct_host_only = "${var.WASNode02_dedicated_acct_host_only}"
  local_disk = "${var.WASNode02_local_disk}"
  ssh_key_ids = ["${data.ibm_compute_ssh_key.ibm_pm_public_key.id}"]
  # Specify the ssh connection
  connection {
    user = "${var.WASNode02-os_admin_user}"
    private_key = "${base64decode(var.ibm_pm_private_ssh_key)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "file" {
    destination = "WASNode02_add_ssh_key.sh"
    content     = <<EOF
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
      "bash -c 'chmod +x WASNode02_add_ssh_key.sh'",
      "bash -c './WASNode02_add_ssh_key.sh  \"${var.WASNode02-os_admin_user}\" \"${var.user_public_ssh_key}\">> WASNode02_add_ssh_key.log 2>&1'"
    ]
  }

}

#########################################################
##### Resource : WASNode02_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "WASNode02_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","ibm_compute_vm_instance.WASNode02"]
  name = "WASNode02_chef_bootstrap_comp"
  camc_endpoint = "${var.ibm_pm_service}/v1/bootstrap/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode02-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode02.ipv4_address_private : ibm_compute_vm_instance.WASNode02.ipv4_address}",
  "node_name": "${var.WASNode02-name}",
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
##### Resource : WASNode02_was_create_clusters_and_members
#########################################################

resource "camc_softwaredeploy" "WASNode02_was_create_clusters_and_members" {
  depends_on = ["camc_softwaredeploy.WASNode01_was_create_clusters_and_members"]
  name = "WASNode02_was_create_clusters_and_members"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode02-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode02.ipv4_address_private : ibm_compute_vm_instance.WASNode02.ipv4_address}",
  "node_name": "${var.WASNode02-name}",
  "runlist": "role[was_create_clusters_and_members]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[was_create_clusters_and_members]"
    },
    "was": {
      "wsadmin": {
        "clusters": {
          "cluster01": {
            "cluster_name": "${var.WASNode02_was_wsadmin_clusters_cluster01_cluster_name}",
            "cluster_servers": {
              "cluster_server01": {
                "server_name": "${var.WASNode02_was_wsadmin_clusters_cluster01_cluster_servers_cluster_server01_server_name}"
              }
            }
          }
        }
      }
    }
  }
}
EOT
}


#########################################################
##### Resource : WASNode02_was_create_nodeagent
#########################################################

resource "camc_softwaredeploy" "WASNode02_was_create_nodeagent" {
  depends_on = ["camc_softwaredeploy.WASNode01_was_create_nodeagent","camc_softwaredeploy.IHSNode01_ihs-wasmode-nonadmin"]
  name = "WASNode02_was_create_nodeagent"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode02-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode02.ipv4_address_private : ibm_compute_vm_instance.WASNode02.ipv4_address}",
  "node_name": "${var.WASNode02-name}",
  "runlist": "role[was_create_nodeagent]",
  "node_attributes": {
    "ibm_internal": {
      "roles": "[was_create_nodeagent]"
    },
    "was": {
      "profiles": {
        "node_profile": {
          "profile": "${var.WASNode02_was_profiles_node_profile_profile}"
        }
      },
      "wsadmin": {
        "nodeagent": {
          "jvmproperty": {
            "property_value_initial": "${var.WASNode02_was_wsadmin_nodeagent_jvmproperty_property_value_initial}",
            "property_value_maximum": "${var.WASNode02_was_wsadmin_nodeagent_jvmproperty_property_value_maximum}"
          }
        }
      }
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "was": {
        "profiles": {
          "node_profile": {
            "keystorepassword": "${var.WASNode02_was_profiles_node_profile_keystorepassword}"
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
##### Resource : WASNode02_was_v9_install
#########################################################

resource "camc_softwaredeploy" "WASNode02_was_v9_install" {
  depends_on = ["camc_bootstrap.WASDMGRNode01_chef_bootstrap_comp","camc_bootstrap.WASNode01_chef_bootstrap_comp","camc_bootstrap.WASNode02_chef_bootstrap_comp","camc_bootstrap.IHSNode01_chef_bootstrap_comp"]
  name = "WASNode02_was_v9_install"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode02-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? ibm_compute_vm_instance.WASNode02.ipv4_address_private : ibm_compute_vm_instance.WASNode02.ipv4_address}",
  "node_name": "${var.WASNode02-name}",
  "runlist": "role[was_v9_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[was_v9_install]"
    },
    "was": {
      "install_dir": "${var.WASNode02_was_install_dir}",
      "java_version": "${var.WASNode02_was_java_version}",
      "os_users": {
        "was": {
          "gid": "${var.WASNode02_was_os_users_was_gid}",
          "home": "${var.WASNode02_was_os_users_was_home}",
          "ldap_user": "${var.WASNode02_was_os_users_was_ldap_user}",
          "name": "${var.WASNode02_was_os_users_was_name}"
        }
      },
      "profile_dir": "${var.WASNode02_was_profile_dir}",
      "security": {
        "admin_user": "${var.WASNode02_was_security_admin_user}"
      },
      "version": "${var.WASNode02_was_version}"
    }
  },
  "vault_content": {
    "item": "secrets",
    "values": {
      "ibm": {
        "im_repo_password": "${var.ibm_im_repo_password}",
        "sw_repo_password": "${var.ibm_sw_repo_password}"
      },
      "was": {
        "security": {
          "admin_user_pwd": "${var.WASNode02_was_security_admin_user_pwd}"
        }
      }
    },
    "vault": "${var.ibm_stack_id}"
  }
}
EOT
}

output "IHSNode01_ip" {
  value = "Private : ${ibm_compute_vm_instance.IHSNode01.ipv4_address_private} & Public : ${ibm_compute_vm_instance.IHSNode01.ipv4_address}"
}

output "IHSNode01_name" {
  value = "${var.IHSNode01-name}"
}

output "IHSNode01_roles" {
  value = "ihs-wasmode-nonadmin"
}

output "WASDMGRNode01_ip" {
  value = "Private : ${ibm_compute_vm_instance.WASDMGRNode01.ipv4_address_private} & Public : ${ibm_compute_vm_instance.WASDMGRNode01.ipv4_address}"
}

output "WASDMGRNode01_name" {
  value = "${var.WASDMGRNode01-name}"
}

output "WASDMGRNode01_roles" {
  value = "was_create_dmgr,was_create_webserver,was_v9_install"
}

output "WASNode01_ip" {
  value = "Private : ${ibm_compute_vm_instance.WASNode01.ipv4_address_private} & Public : ${ibm_compute_vm_instance.WASNode01.ipv4_address}"
}

output "WASNode01_name" {
  value = "${var.WASNode01-name}"
}

output "WASNode01_roles" {
  value = "was_create_clusters_and_members,was_create_nodeagent,was_v9_install"
}

output "WASNode02_ip" {
  value = "Private : ${ibm_compute_vm_instance.WASNode02.ipv4_address_private} & Public : ${ibm_compute_vm_instance.WASNode02.ipv4_address}"
}

output "WASNode02_name" {
  value = "${var.WASNode02-name}"
}

output "WASNode02_roles" {
  value = "was_create_clusters_and_members,was_create_nodeagent,was_v9_install"
}

output "stack_id" {
  value = "${var.ibm_stack_id}"
}
