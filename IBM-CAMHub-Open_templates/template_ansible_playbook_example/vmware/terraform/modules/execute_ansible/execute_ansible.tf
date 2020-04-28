resource "null_resource" "execute_ansible_dependsOn" {
  provisioner "local-exec" {
    command = "echo The dependsOn output for Single Node is ${var.dependsOn}"
  }
}

resource "null_resource" "execute_ansible" {
  depends_on = ["null_resource.execute_ansible_dependsOn"]

  # Specify the ssh connection
  connection {
    type        = "ssh"
    user        = "${var.ansible_username}"
    password    = "${var.ansible_password}"
    private_key = "${var.ansible_private_key}"
    host        = "${var.ansible_hostname}"
  }

  # Create the Host File for example
  provisioner "file" {
    content = <<EOF
[webservers]
${var.vm_ipv4_address_list[count.index]}

[dbservers]
${var.vm_ipv4_address_list[count.index]}
EOF

    destination = "/tmp/ansible-playbook-host"
  }

  # Produce a YAML file to override defaults.
  provisioner "file" {
    content = <<EOF
dbuser: ${var.mysql_dbuser}
dbname: ${var.mysql_dbname}
mysql_port: ${var.mysql_dbport}
upassword: ${var.mysql_password}
EOF

    destination = "/tmp/ansible-playbook-override"
  }

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "cd ${var.playbook_location} && ansible-playbook -i \"/tmp/ansible-playbook-host\" -e \"@/tmp/ansible-playbook-override\" site.yml",
    ]
  }
}

resource "null_resource" "execute_ansible_finished" {
  depends_on = ["null_resource.execute_ansible"]

  provisioner "local-exec" {
    command = "echo 'Ansible Binaries installed'"
  }
}
