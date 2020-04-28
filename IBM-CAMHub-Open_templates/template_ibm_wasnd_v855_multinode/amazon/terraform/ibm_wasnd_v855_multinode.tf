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

# This is a terraform generated template generated from ibm_wasnd_v855_multinode

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

variable "aws_ami_owner_id" {
  description = "AWS AMI Owner ID"
  default = "309956199498"
}

variable "aws_region" {
  description = "AWS Region Name"
  default = "us-east-1"
}

##############################################################
# Define the aws provider
##############################################################
provider "aws" {
  region = "${var.aws_region}"
  version = "~> 1.2"
}

provider "camc" {
  version = "~> 0.2"
}

provider "template" {
  version = "~> 1.0"
}

data "aws_vpc" "selected_vpc" {
  filter {
    name = "tag:Name"
    values = ["${var.aws_vpc_name}"]
  }
}

#Parameter : aws_vpc_name
variable "aws_vpc_name" {
  description = "AWS VPC Name"
}

data "aws_security_group" "aws_sg_camc_name_selected" {
  name = "${var.aws_sg_camc_name}"
  vpc_id = "${data.aws_vpc.selected_vpc.id}"
}

#Parameter : aws_sg_camc_name
variable "aws_sg_camc_name" {
  description = "AWS Security Group Name"
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
data "aws_ami" "IHSNode01_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.IHSNode01-image}*"]
  }
  owners = ["${var.aws_ami_owner_id}"]
}

#Variable : IHSNode01-image
variable "IHSNode01-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "RHEL-7.4_HVM_GA"
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
  default = "8.0.50.7"
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
  default = "8.5.5.13"
}


##### Image Parameters variables #####

##### virtualmachine variables #####
#Variable : IHSNode01-flavor
variable "IHSNode01-flavor" {
  type = "string"
  description = "IHSNode01 Flavor"
  default = "t2.medium"
}

#Variable : IHSNode01-mgmt-network-public
variable "IHSNode01-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}

#Variable : WASDMGRNode01-flavor
variable "WASDMGRNode01-flavor" {
  type = "string"
  description = "WASDMGRNode01 Flavor"
  default = "t2.medium"
}

#Variable : WASDMGRNode01-mgmt-network-public
variable "WASDMGRNode01-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}

#Variable : WASNode01-flavor
variable "WASNode01-flavor" {
  type = "string"
  description = "WASNode01 Flavor"
  default = "t2.medium"
}

#Variable : WASNode01-mgmt-network-public
variable "WASNode01-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}

#Variable : WASNode02-flavor
variable "WASNode02-flavor" {
  type = "string"
  description = "WASNode02 Flavor"
  default = "t2.medium"
}

#Variable : WASNode02-mgmt-network-public
variable "WASNode02-mgmt-network-public" {
  type = "string"
  description = "Expose and use public IP of virtual machine for internal communication"
  default = "true"
}


##### WASDMGRNode01 variables #####
data "aws_ami" "WASDMGRNode01_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.WASDMGRNode01-image}*"]
  }
  owners = ["${var.aws_ami_owner_id}"]
}

#Variable : WASDMGRNode01-image
variable "WASDMGRNode01-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "RHEL-7.4_HVM_GA"
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
  default = "7.1.4.15"
}

#Variable : WASDMGRNode01_was_os_users_was_comment
variable "WASDMGRNode01_was_os_users_was_comment" {
  type = "string"
  description = "Comment that will be added when creating the userid"
  default = "WAS administrative user"
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
  description = "The release and fixpack level of WebSphere Application Server to be installed. Example formats are 8.5.5.13 or 9.0.0.6"
  default = "8.5.5.13"
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
data "aws_ami" "WASNode01_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.WASNode01-image}*"]
  }
  owners = ["${var.aws_ami_owner_id}"]
}

#Variable : WASNode01-image
variable "WASNode01-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "RHEL-7.4_HVM_GA"
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
  default = "7.1.4.15"
}

#Variable : WASNode01_was_os_users_was_comment
variable "WASNode01_was_os_users_was_comment" {
  type = "string"
  description = "Comment that will be added when creating the userid"
  default = "WAS administrative user"
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
  description = "The release and fixpack level of WebSphere Application Server to be installed. Example formats are 8.5.5.13 or 9.0.0.4"
  default = "8.5.5.13"
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
data "aws_ami" "WASNode02_ami" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.WASNode02-image}*"]
  }
  owners = ["${var.aws_ami_owner_id}"]
}

#Variable : WASNode02-image
variable "WASNode02-image" {
  type = "string"
  description = "Operating system image id / template that should be used when creating the virtual image"
  default = "RHEL-7.4_HVM_GA"
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
  default = "7.1.4.15"
}

#Variable : WASNode02_was_os_users_was_comment
variable "WASNode02_was_os_users_was_comment" {
  type = "string"
  description = "Comment that will be added when creating the userid"
  default = "WAS administrative user"
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
  description = "The release and fixpack level of WebSphere Application Server to be installed. Example formats are 8.5.5.13 or 9.0.0.4"
  default = "8.5.5.13"
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

##### domain name #####
variable "runtime_domain" {
  description = "domain name"
  default = "cam.ibm.com"
}


#########################################################
##### Resource : IHSNode01
#########################################################


#Parameter : IHSNode01_subnet_name
data "aws_subnet" "IHSNode01_selected_subnet" {
  filter {
    name = "tag:Name"
    values = ["${var.IHSNode01_subnet_name}"]
  }
}

variable "IHSNode01_subnet_name" {
  type = "string"
  description = "AWS Subnet Name"
}


#Parameter : IHSNode01_associate_public_ip_address
variable "IHSNode01_associate_public_ip_address" {
  type = "string"
  description = "AWS assign a public IP to instance"
  default = "true"
}


#Parameter : IHSNode01_root_block_device_volume_type
variable "IHSNode01_root_block_device_volume_type" {
  type = "string"
  description = "AWS Root Block Device Volume Type"
  default = "gp2"
}


#Parameter : IHSNode01_root_block_device_volume_size
variable "IHSNode01_root_block_device_volume_size" {
  type = "string"
  description = "AWS Root Block Device Volume Size"
  default = "100"
}


#Parameter : IHSNode01_root_block_device_delete_on_termination
variable "IHSNode01_root_block_device_delete_on_termination" {
  type = "string"
  description = "AWS Root Block Device Delete on Termination"
  default = "true"
}

resource "aws_instance" "IHSNode01" {
  ami = "${data.aws_ami.IHSNode01_ami.id}"
  instance_type = "${var.IHSNode01-flavor}"
  key_name = "${var.ibm_pm_public_ssh_key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.aws_sg_camc_name_selected.id}"]
  subnet_id = "${data.aws_subnet.IHSNode01_selected_subnet.id}"
  associate_public_ip_address = "${var.IHSNode01_associate_public_ip_address}"
  tags {
    Name = "${var.IHSNode01-name}"
  }

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

  root_block_device {
    volume_type = "${var.IHSNode01_root_block_device_volume_type}"
    volume_size = "${var.IHSNode01_root_block_device_volume_size}"
    #iops = "${var.IHSNode01_root_block_device_iops}"
    delete_on_termination = "${var.IHSNode01_root_block_device_delete_on_termination}"
  }

  user_data = "${data.template_cloudinit_config.IHSNode01_init.rendered}"
}
data "template_cloudinit_config" "IHSNode01_init"  {
  part {
    content_type = "text/cloud-config"
    content = <<EOF
hostname: ${var.IHSNode01-name}.${var.runtime_domain}
fqdn: ${var.IHSNode01-name}.${var.runtime_domain}
manage_etc_hosts: false
EOF
  }
}

#########################################################
##### Resource : IHSNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "IHSNode01_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","aws_instance.IHSNode01"]
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
  "host_ip": "${var.IHSNode01-mgmt-network-public == "false" ? aws_instance.IHSNode01.private_ip : aws_instance.IHSNode01.public_ip}",
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
  "host_ip": "${var.IHSNode01-mgmt-network-public == "false" ? aws_instance.IHSNode01.private_ip : aws_instance.IHSNode01.public_ip}",
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


#Parameter : WASDMGRNode01_subnet_name
data "aws_subnet" "WASDMGRNode01_selected_subnet" {
  filter {
    name = "tag:Name"
    values = ["${var.WASDMGRNode01_subnet_name}"]
  }
}

variable "WASDMGRNode01_subnet_name" {
  type = "string"
  description = "AWS Subnet Name"
}


#Parameter : WASDMGRNode01_associate_public_ip_address
variable "WASDMGRNode01_associate_public_ip_address" {
  type = "string"
  description = "AWS assign a public IP to instance"
  default = "true"
}


#Parameter : WASDMGRNode01_root_block_device_volume_type
variable "WASDMGRNode01_root_block_device_volume_type" {
  type = "string"
  description = "AWS Root Block Device Volume Type"
  default = "gp2"
}


#Parameter : WASDMGRNode01_root_block_device_volume_size
variable "WASDMGRNode01_root_block_device_volume_size" {
  type = "string"
  description = "AWS Root Block Device Volume Size"
  default = "100"
}


#Parameter : WASDMGRNode01_root_block_device_delete_on_termination
variable "WASDMGRNode01_root_block_device_delete_on_termination" {
  type = "string"
  description = "AWS Root Block Device Delete on Termination"
  default = "true"
}

resource "aws_instance" "WASDMGRNode01" {
  ami = "${data.aws_ami.WASDMGRNode01_ami.id}"
  instance_type = "${var.WASDMGRNode01-flavor}"
  key_name = "${var.ibm_pm_public_ssh_key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.aws_sg_camc_name_selected.id}"]
  subnet_id = "${data.aws_subnet.WASDMGRNode01_selected_subnet.id}"
  associate_public_ip_address = "${var.WASDMGRNode01_associate_public_ip_address}"
  tags {
    Name = "${var.WASDMGRNode01-name}"
  }

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

  root_block_device {
    volume_type = "${var.WASDMGRNode01_root_block_device_volume_type}"
    volume_size = "${var.WASDMGRNode01_root_block_device_volume_size}"
    #iops = "${var.WASDMGRNode01_root_block_device_iops}"
    delete_on_termination = "${var.WASDMGRNode01_root_block_device_delete_on_termination}"
  }

  user_data = "${data.template_cloudinit_config.WASDMGRNode01_init.rendered}"
}
data "template_cloudinit_config" "WASDMGRNode01_init"  {
  part {
    content_type = "text/cloud-config"
    content = <<EOF
hostname: ${var.WASDMGRNode01-name}.${var.runtime_domain}
fqdn: ${var.WASDMGRNode01-name}.${var.runtime_domain}
manage_etc_hosts: false
EOF
  }
}

#########################################################
##### Resource : WASDMGRNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "WASDMGRNode01_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","aws_instance.WASDMGRNode01"]
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
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? aws_instance.WASDMGRNode01.private_ip : aws_instance.WASDMGRNode01.public_ip}",
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
  depends_on = ["camc_softwaredeploy.WASDMGRNode01_was_v855_install","camc_softwaredeploy.WASNode01_was_v855_install","camc_softwaredeploy.WASNode02_was_v855_install"]
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
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? aws_instance.WASDMGRNode01.private_ip : aws_instance.WASDMGRNode01.public_ip}",
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
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? aws_instance.WASDMGRNode01.private_ip : aws_instance.WASDMGRNode01.public_ip}",
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
##### Resource : WASDMGRNode01_was_v855_install
#########################################################

resource "camc_softwaredeploy" "WASDMGRNode01_was_v855_install" {
  depends_on = ["camc_bootstrap.WASDMGRNode01_chef_bootstrap_comp","camc_bootstrap.IHSNode01_chef_bootstrap_comp","camc_bootstrap.WASNode01_chef_bootstrap_comp","camc_bootstrap.WASNode02_chef_bootstrap_comp"]
  name = "WASDMGRNode01_was_v855_install"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASDMGRNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASDMGRNode01-mgmt-network-public == "false" ? aws_instance.WASDMGRNode01.private_ip : aws_instance.WASDMGRNode01.public_ip}",
  "node_name": "${var.WASDMGRNode01-name}",
  "runlist": "role[was_v855_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[was_v855_install]"
    },
    "was": {
      "install_dir": "${var.WASDMGRNode01_was_install_dir}",
      "java_version": "${var.WASDMGRNode01_was_java_version}",
      "os_users": {
        "was": {
          "comment": "${var.WASDMGRNode01_was_os_users_was_comment}",
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


#Parameter : WASNode01_subnet_name
data "aws_subnet" "WASNode01_selected_subnet" {
  filter {
    name = "tag:Name"
    values = ["${var.WASNode01_subnet_name}"]
  }
}

variable "WASNode01_subnet_name" {
  type = "string"
  description = "AWS Subnet Name"
}


#Parameter : WASNode01_associate_public_ip_address
variable "WASNode01_associate_public_ip_address" {
  type = "string"
  description = "AWS assign a public IP to instance"
  default = "true"
}


#Parameter : WASNode01_root_block_device_volume_type
variable "WASNode01_root_block_device_volume_type" {
  type = "string"
  description = "AWS Root Block Device Volume Type"
  default = "gp2"
}


#Parameter : WASNode01_root_block_device_volume_size
variable "WASNode01_root_block_device_volume_size" {
  type = "string"
  description = "AWS Root Block Device Volume Size"
  default = "100"
}


#Parameter : WASNode01_root_block_device_delete_on_termination
variable "WASNode01_root_block_device_delete_on_termination" {
  type = "string"
  description = "AWS Root Block Device Delete on Termination"
  default = "true"
}

resource "aws_instance" "WASNode01" {
  ami = "${data.aws_ami.WASNode01_ami.id}"
  instance_type = "${var.WASNode01-flavor}"
  key_name = "${var.ibm_pm_public_ssh_key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.aws_sg_camc_name_selected.id}"]
  subnet_id = "${data.aws_subnet.WASNode01_selected_subnet.id}"
  associate_public_ip_address = "${var.WASNode01_associate_public_ip_address}"
  tags {
    Name = "${var.WASNode01-name}"
  }

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

  root_block_device {
    volume_type = "${var.WASNode01_root_block_device_volume_type}"
    volume_size = "${var.WASNode01_root_block_device_volume_size}"
    #iops = "${var.WASNode01_root_block_device_iops}"
    delete_on_termination = "${var.WASNode01_root_block_device_delete_on_termination}"
  }

  user_data = "${data.template_cloudinit_config.WASNode01_init.rendered}"
}
data "template_cloudinit_config" "WASNode01_init"  {
  part {
    content_type = "text/cloud-config"
    content = <<EOF
hostname: ${var.WASNode01-name}.${var.runtime_domain}
fqdn: ${var.WASNode01-name}.${var.runtime_domain}
manage_etc_hosts: false
EOF
  }
}

#########################################################
##### Resource : WASNode01_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "WASNode01_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","aws_instance.WASNode01"]
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
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? aws_instance.WASNode01.private_ip : aws_instance.WASNode01.public_ip}",
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
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? aws_instance.WASNode01.private_ip : aws_instance.WASNode01.public_ip}",
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
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? aws_instance.WASNode01.private_ip : aws_instance.WASNode01.public_ip}",
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
##### Resource : WASNode01_was_v855_install
#########################################################

resource "camc_softwaredeploy" "WASNode01_was_v855_install" {
  depends_on = ["camc_bootstrap.WASDMGRNode01_chef_bootstrap_comp","camc_bootstrap.IHSNode01_chef_bootstrap_comp","camc_bootstrap.WASNode01_chef_bootstrap_comp","camc_bootstrap.WASNode02_chef_bootstrap_comp"]
  name = "WASNode01_was_v855_install"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode01-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode01-mgmt-network-public == "false" ? aws_instance.WASNode01.private_ip : aws_instance.WASNode01.public_ip}",
  "node_name": "${var.WASNode01-name}",
  "runlist": "role[was_v855_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[was_v855_install]"
    },
    "was": {
      "install_dir": "${var.WASNode01_was_install_dir}",
      "java_version": "${var.WASNode01_was_java_version}",
      "os_users": {
        "was": {
          "comment": "${var.WASNode01_was_os_users_was_comment}",
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


#Parameter : WASNode02_subnet_name
data "aws_subnet" "WASNode02_selected_subnet" {
  filter {
    name = "tag:Name"
    values = ["${var.WASNode02_subnet_name}"]
  }
}

variable "WASNode02_subnet_name" {
  type = "string"
  description = "AWS Subnet Name"
}


#Parameter : WASNode02_associate_public_ip_address
variable "WASNode02_associate_public_ip_address" {
  type = "string"
  description = "AWS assign a public IP to instance"
  default = "true"
}


#Parameter : WASNode02_root_block_device_volume_type
variable "WASNode02_root_block_device_volume_type" {
  type = "string"
  description = "AWS Root Block Device Volume Type"
  default = "gp2"
}


#Parameter : WASNode02_root_block_device_volume_size
variable "WASNode02_root_block_device_volume_size" {
  type = "string"
  description = "AWS Root Block Device Volume Size"
  default = "100"
}


#Parameter : WASNode02_root_block_device_delete_on_termination
variable "WASNode02_root_block_device_delete_on_termination" {
  type = "string"
  description = "AWS Root Block Device Delete on Termination"
  default = "true"
}

resource "aws_instance" "WASNode02" {
  ami = "${data.aws_ami.WASNode02_ami.id}"
  instance_type = "${var.WASNode02-flavor}"
  key_name = "${var.ibm_pm_public_ssh_key_name}"
  vpc_security_group_ids = ["${data.aws_security_group.aws_sg_camc_name_selected.id}"]
  subnet_id = "${data.aws_subnet.WASNode02_selected_subnet.id}"
  associate_public_ip_address = "${var.WASNode02_associate_public_ip_address}"
  tags {
    Name = "${var.WASNode02-name}"
  }

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

  root_block_device {
    volume_type = "${var.WASNode02_root_block_device_volume_type}"
    volume_size = "${var.WASNode02_root_block_device_volume_size}"
    #iops = "${var.WASNode02_root_block_device_iops}"
    delete_on_termination = "${var.WASNode02_root_block_device_delete_on_termination}"
  }

  user_data = "${data.template_cloudinit_config.WASNode02_init.rendered}"
}
data "template_cloudinit_config" "WASNode02_init"  {
  part {
    content_type = "text/cloud-config"
    content = <<EOF
hostname: ${var.WASNode02-name}.${var.runtime_domain}
fqdn: ${var.WASNode02-name}.${var.runtime_domain}
manage_etc_hosts: false
EOF
  }
}

#########################################################
##### Resource : WASNode02_chef_bootstrap_comp
#########################################################

resource "camc_bootstrap" "WASNode02_chef_bootstrap_comp" {
  depends_on = ["camc_vaultitem.VaultItem","aws_instance.WASNode02"]
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
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? aws_instance.WASNode02.private_ip : aws_instance.WASNode02.public_ip}",
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
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? aws_instance.WASNode02.private_ip : aws_instance.WASNode02.public_ip}",
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
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? aws_instance.WASNode02.private_ip : aws_instance.WASNode02.public_ip}",
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
##### Resource : WASNode02_was_v855_install
#########################################################

resource "camc_softwaredeploy" "WASNode02_was_v855_install" {
  depends_on = ["camc_bootstrap.WASDMGRNode01_chef_bootstrap_comp","camc_bootstrap.IHSNode01_chef_bootstrap_comp","camc_bootstrap.WASNode01_chef_bootstrap_comp","camc_bootstrap.WASNode02_chef_bootstrap_comp"]
  name = "WASNode02_was_v855_install"
  camc_endpoint = "${var.ibm_pm_service}/v1/software_deployment/chef"
  access_token = "${var.ibm_pm_access_token}"
  skip_ssl_verify = true
  trace = true
  data = <<EOT
{
  "os_admin_user": "${var.WASNode02-os_admin_user}",
  "stack_id": "${var.ibm_stack_id}",
  "environment_name": "_default",
  "host_ip": "${var.WASNode02-mgmt-network-public == "false" ? aws_instance.WASNode02.private_ip : aws_instance.WASNode02.public_ip}",
  "node_name": "${var.WASNode02-name}",
  "runlist": "role[was_v855_install]",
  "node_attributes": {
    "ibm": {
      "im_repo": "${var.ibm_im_repo}",
      "im_repo_user": "${var.ibm_im_repo_user}",
      "sw_repo": "${var.ibm_sw_repo}",
      "sw_repo_user": "${var.ibm_sw_repo_user}"
    },
    "ibm_internal": {
      "roles": "[was_v855_install]"
    },
    "was": {
      "install_dir": "${var.WASNode02_was_install_dir}",
      "java_version": "${var.WASNode02_was_java_version}",
      "os_users": {
        "was": {
          "comment": "${var.WASNode02_was_os_users_was_comment}",
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
  value = "Private : ${aws_instance.IHSNode01.private_ip} & Public : ${aws_instance.IHSNode01.public_ip}"
}

output "IHSNode01_name" {
  value = "${var.IHSNode01-name}"
}

output "IHSNode01_roles" {
  value = "ihs-wasmode-nonadmin"
}

output "WASDMGRNode01_ip" {
  value = "Private : ${aws_instance.WASDMGRNode01.private_ip} & Public : ${aws_instance.WASDMGRNode01.public_ip}"
}

output "WASDMGRNode01_name" {
  value = "${var.WASDMGRNode01-name}"
}

output "WASDMGRNode01_roles" {
  value = "was_create_dmgr,was_create_webserver,was_v855_install"
}

output "WASNode01_ip" {
  value = "Private : ${aws_instance.WASNode01.private_ip} & Public : ${aws_instance.WASNode01.public_ip}"
}

output "WASNode01_name" {
  value = "${var.WASNode01-name}"
}

output "WASNode01_roles" {
  value = "was_create_clusters_and_members,was_create_nodeagent,was_v855_install"
}

output "WASNode02_ip" {
  value = "Private : ${aws_instance.WASNode02.private_ip} & Public : ${aws_instance.WASNode02.public_ip}"
}

output "WASNode02_name" {
  value = "${var.WASNode02-name}"
}

output "WASNode02_roles" {
  value = "was_create_clusters_and_members,was_create_nodeagent,was_v855_install"
}

output "stack_id" {
  value = "${var.ibm_stack_id}"
}
