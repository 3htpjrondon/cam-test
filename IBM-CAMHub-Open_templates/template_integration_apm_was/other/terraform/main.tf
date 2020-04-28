module "apm_install_linux" {
  source = "./modules/apm_was"

  ip_address = "${var.ip_address}"
  user = "${var.user}"
  password = "${var.password}"
  private_key = "${var.private_key}"

  was_profile = "${var.was_profile}"
  was_home = "${var.was_home}"
  was_cell = "${var.was_cell}"
  was_node = "${var.was_node}"
  was_user = "${var.was_user}"
  apm_dir = "${var.apm_dir}"
  #######
  bastion_host        = "${var.bastion_host}"
  bastion_user        = "${var.bastion_user}"
  bastion_private_key = "${var.bastion_private_key}"
  bastion_port        = "${var.bastion_port}"
  bastion_password    = "${var.bastion_password}"      
  #######
}
