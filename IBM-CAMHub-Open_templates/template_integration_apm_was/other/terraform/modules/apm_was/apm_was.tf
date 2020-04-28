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
  program = ["/bin/bash", "/tmp/config_apm_was.sh --was_profile ${var.was_profile} --was_home ${var.was_home} --was_cell ${var.was_cell} --was_node  ${var.was_node} --was_user ${var.was_user} --apm_dir ${var.apm_dir}"]
  remote_host = "${var.ip_address}"
  remote_user = "${var.user}"
  remote_password = "${var.password}"
  remote_key = "${var.private_key}"
  bastion_host = "${var.bastion_host}"
  bastion_user = "${var.bastion_user}"
  bastion_password = "${var.bastion_password}"
  bastion_private_key = "${var.bastion_private_key}"  
  bastion_port = "${var.bastion_port}"
  destination = "/tmp/config_apm_was.sh"
  source = "${path.module}/scripts/config_apm_was.sh"
  on_create = true
}
