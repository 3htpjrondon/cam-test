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

variable "ip_address" { type = "string" description = "IP Address of the HOST to install the APM Agent." }
variable "user" { type = "string" description = "Userid to install the APM Agent, root reccomended." default = "root" }
variable "password" { type = "string" description = "Password of the installation user." }
variable "private_key" { type = "string" description = "Private key of the installation user. This value should be base64 encoded"}


##############################################################
# COMMAND VARIABLES
##############################################################

variable "apm_method" { type = "string" description = "URI type for download, http reccomended." default = "http" }
variable "apm_location" { description = "Source for the APM Agent installer, eg http://IP_ADDRESS:8888/apm-agent/APMADV_Agent_Install.tar" }
variable "apm_source_subdir" { description = "Subdirectory within the installer where the installation files reside." }
variable "apm_dir" { description = "APM Installation Directory" default = "/opt/ibm/apm/agent" }
variable "apm_agents" { type = "string" description = "List of APM agents to install, eg, os." }
