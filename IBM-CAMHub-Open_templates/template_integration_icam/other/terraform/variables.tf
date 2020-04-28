# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

##############################################################
# CHAINED INPUT VARIABLES
##############################################################

variable "ip_address" { type = "string" description = "IP Address of the host to install the IBM Cloud App Management Agent onto." }
variable "user" { type = "string" description = "Userid to install the IBM Cloud App Management Agent, root reccomended." default = "root" }
variable "password" { type = "string" description = "Password of the installation user." }
variable "private_key" { type = "string" description = "Private key of the installation user. This value should be base64 encoded"}


##############################################################
# COMMAND VARIABLES
##############################################################

variable "icam_agent_location" { description = "Source for the IBM Cloud App Management Agent installer, eg http://IP_ADDRESS:8888/APP_MGMT_Agent_Install_2018.2.0" }
variable "icam_agent_location_credentials" { description = "Credentials required to retrieve the IBM Cloud App Management agent, provided in a user:password format." }
variable "icam_agent_source_subdir" { description = "Subdirectory within the installer where the installation files reside, eg APP_MGMT_Agent_Install_2018.2.0" }
variable "icam_agent_installation_dir" { description = "IBM Cloud App Management installation directory" default = "/opt/ibm/apm/agent" }
variable "icam_agent_name" { type = "string" description = "IBM Cloud App Management agent to be installed. For example, os." }

