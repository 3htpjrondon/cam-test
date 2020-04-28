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

variable "was_profile" { type = "string" description = "Default WebSphere Profile." default = "AppSrv01" }
variable "was_home" { type = "string" description = "Base directory for the WebSphere Installation." default = "/opt/IBM/WebSphere/AppServer" }
variable "was_cell" { type = "string" description = "WebSphere Cell Name." default = "cell01" }
variable "was_node" { type = "string" description = "WebSphere Node Name" default = "devnode01" }
variable "was_user" { type = "string" description = "Websphere run_as user." default = "wasadmin" }
variable "apm_dir" { type = "string" description = "Base directory for APM" default = "/opt/ibm/apm/agent" }
