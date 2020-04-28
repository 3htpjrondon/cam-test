# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2018 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

##############################################################
# Connection Variables
##############################################################
variable "ipv4_address" { type = "string" description = "IPv4 address for vNIC configuration" }
variable "os_admin_user" { type = "string" description = "Template image user ID" }
variable "os_admin_password" { type = "string" description = "Template image password" }
variable "os_private_ssh_key" { type = "string" description = "Template image private key. The key should be base64 encoded" }

##############################################################
# Filebeat Variables
##############################################################
variable "logstash_server_ip" { type = "string" description = "Logstash server IP address" }
variable "logstash_server_port" { type = "string" description = "Logstash server port"}
variable "filebeat_source_url" { type = "string" description = "Location of the filebeat installation package" }
variable "filebeat_config_url" { type = "string" description = "Location of the filebeat configuration file" }
variable "monitored_paths" { type = "list" description = "List of files and directories to monitor with logstash. Wildcards supported" }
