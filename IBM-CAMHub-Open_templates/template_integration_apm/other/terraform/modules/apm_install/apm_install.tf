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


resource "camc_scriptpackage" "RemoteScript" {
  program = ["/bin/bash", "/tmp/install_apm_linux.sh", "${var.apm_location}", "${var.apm_method}", "${var.apm_source_subdir}", "${var.apm_dir}", "${var.apm_agents}", "> /tmp/install_apm_linux.log"]
  remote_host = "${var.ip_address}"
  remote_user = "${var.user}"
  remote_password = "${var.password}"
  remote_key = "${var.private_key}"
  destination = "/tmp/install_apm_linux.sh"
  source = "${path.module}/scripts/install_apm_linux.sh"
  on_create = true
  bastion_host = "${var.bastion_host}"
  bastion_user = "${var.bastion_user}"
  bastion_password = "${var.bastion_password}"
  bastion_private_key = "${var.bastion_private_key}"  
  bastion_port = "${var.bastion_port}"  
}
