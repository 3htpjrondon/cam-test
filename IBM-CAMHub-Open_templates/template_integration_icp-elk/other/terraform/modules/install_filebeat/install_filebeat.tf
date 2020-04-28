# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2018 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

##############################################################
# Provisioner to install the Filebeat agent
##############################################################


resource "null_resource" "install_filebeat"{
  connection {
    host = "${var.ipv4_address}"
    type = "ssh"
    user = "${var.os_admin_user}"
    password = "${var.os_admin_password}"
    private_key = "${base64decode(var.os_private_ssh_key)}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }

  provisioner "icp-elk" {
    "logstash_server_ip" = "${var.logstash_server_ip}"
    "logstash_server_port" = "${var.logstash_server_port}"
    "filebeat_source_url" = "${var.filebeat_source_url}"
    "filebeat_config_url" = "${var.filebeat_config_url}"
    "monitored_paths" = "${var.monitored_paths}"
  }
}
