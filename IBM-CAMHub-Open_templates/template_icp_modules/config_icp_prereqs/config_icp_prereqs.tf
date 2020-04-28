resource "null_resource" "config_icp_prereq_dependsOn" {
  provisioner "local-exec" {
    command = "echo The dependsOn output for VM Availability is ${var.dependsOn}"
  }
}

resource "null_resource" "install_python" {
  depends_on = ["null_resource.config_icp_prereq_dependsOn"]
  count = "${length(var.vm_ipv4_address_list)}"
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }
  provisioner "file" {
    source = "${path.module}/scripts/python_install.sh"
    destination = "/var/tmp/python_install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod 755 /var/tmp/python_install.sh",
      "echo /var/tmp/python_install.sh",
      "bash -c '/var/tmp/python_install.sh'"
      # "bash -c 'rm /var/tmp/python_install.sh'"
    ]
  }
}

resource "null_resource" "install_system_settings" {
  depends_on = ["null_resource.install_python"]

  count = "${length(var.vm_ipv4_address_list)}"
  connection {
    type = "ssh"
    user = "${var.vm_os_user}"
    password =  "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host = "${var.vm_ipv4_address_list[count.index]}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"    
  }
  provisioner "file" {
    source = "${path.module}/scripts/system_settings.sh"
    destination = "/var/tmp/system_settings.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -e",
      "chmod 755 /var/tmp/system_settings.sh",
      "echo /var/tmp/system_settings.sh",
      "bash -c '/var/tmp/system_settings.sh'"
      # "bash -c 'rm /var/tmp/system_settings.sh'"
    ]
  }
}

resource "null_resource" "icp_prereqs_finished" {
  depends_on = ["null_resource.install_system_settings"]
  provisioner "local-exec" {
    command = "echo 'IBM Cloud Private Pre-reqs installed on Nodes'"
  }
}
