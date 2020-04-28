# =================================================================
# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure
# restricted by GSA ADP Schedule Contract with IBM Corp.
# =================================================================

##############################################################
# Script package to install the APM Agents
##############################################################


resource "camc_scriptpackage" "InstallScript" {
  program = ["/bin/bash", "/tmp/install_icam_agent_linux.sh", "--icam_agent_location=${var.icam_agent_location}", "--icam_agent_location_credentials=${var.icam_agent_location_credentials}", "--icam_agent_source_subdir=${var.icam_agent_source_subdir}", "--icam_agent_installation_dir=${var.icam_agent_installation_dir}", "--icam_agent_name=${var.icam_agent_name}", "> /tmp/install_icam_agent_linux.log"]
  remote_host = "${var.ip_address}"
  remote_user = "${var.user}"
  remote_password = "${var.password}"
  remote_key = "${var.private_key}"
  bastion_host = "${var.bastion_host}"
  bastion_user = "${var.bastion_user}"
  bastion_password = "${var.bastion_password}"
  bastion_private_key = "${var.bastion_private_key}"  
  bastion_port = "${var.bastion_port}"    
  destination = "/tmp/install_icam_agent_linux.sh"
  source = "${path.module}/scripts/install_icam_agent_linux.sh"
  on_create = true
}

resource "camc_scriptpackage" "DestroyScript" {
  program = ["/bin/bash", "${var.icam_agent_installation_dir}/bin/smai-agent.sh uninstall_all force", "> /tmp/unistall_icam_agent_linux.log"]
  remote_host = "${var.ip_address}"
  remote_user = "${var.user}"
  remote_password = "${var.password}"
  remote_key = "${var.private_key}"
  bastion_host = "${var.bastion_host}"
  bastion_user = "${var.bastion_user}"
  bastion_password = "${var.bastion_password}"
  bastion_private_key = "${var.bastion_private_key}"  
  bastion_port = "${var.bastion_port}"    
  on_delete = true
}
