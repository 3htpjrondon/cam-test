
# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2018 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

##############################################################
# Provisioner to install Filebeat agent
##############################################################

module "filebeat_installer_linux" {
  source = "./modules/install_filebeat"

  ipv4_address         = "${var.ipv4_address}"
  os_admin_user        = "${var.os_admin_user}"
  os_admin_password    = "${var.os_admin_password}"
  os_private_ssh_key   = "${var.os_private_ssh_key}"

  logstash_server_ip   = "${var.logstash_server_ip}"
  logstash_server_port = "${var.logstash_server_port}"
  filebeat_source_url  = "${var.filebeat_source_url}"
  filebeat_config_url  = "${var.filebeat_config_url}"
  monitored_paths      = "${var.monitored_paths}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_password    = "${var.bastion_password}"      
  #######  
}
