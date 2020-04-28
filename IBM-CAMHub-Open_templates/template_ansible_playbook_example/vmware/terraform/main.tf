provider "vsphere" {
  version              = "~> 1.3"
  allow_unverified_ssl = "true"
}

provider "random" {
  version = "~> 1.0"
}

provider "local" {
  version = "~> 1.1"
}

provider "null" {
  version = "~> 1.0"
}

provider "tls" {
  version = "~> 1.0"
}

resource "random_string" "random-dir" {
  length  = 8
  special = false
}

resource "tls_private_key" "generate" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "null_resource" "create-temp-random-dir" {
  provisioner "local-exec" {
    command = "${format("mkdir -p  /tmp/%s" , "${random_string.random-dir.result}")}"
  }
}

module "deployVM_singlenode" {
  source = "./modules/vmware_provision"

  #######
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"

  #######
  count = "${length(var.singlenode_vm_ipv4_address)}"

  vm_vcpu                    = "${var.singlenode_vcpu}"
  vm_name                    = "${var.singlenode_prefix_name}"
  vm_memory                  = "${var.singlenode_memory}"
  vm_template                = "${var.singlenode_vm_template}"
  vm_os_password             = "${var.singlenode_vm_os_password}"
  vm_os_user                 = "${var.singlenode_vm_os_user}"
  vm_domain                  = "${var.vm_domain}"
  vm_folder                  = "${var.vm_folder}"
  vm_private_ssh_key         = "${tls_private_key.generate.private_key_pem}"
  vm_public_ssh_key          = "${tls_private_key.generate.public_key_openssh}"
  vm_network_interface_label = "${var.vm_network_interface_label}"
  vm_ipv4_gateway            = "${var.singlenode_vm_ipv4_gateway}"
  vm_ipv4_address            = "${var.singlenode_vm_ipv4_address}"
  vm_ipv4_prefix_length      = "${var.singlenode_vm_ipv4_prefix_length}"
  vm_adapter_type            = "${var.vm_adapter_type}"
  vm_disk1_size              = "${var.singlenode_vm_disk1_size}"
  vm_disk1_datastore         = "${var.singlenode_vm_disk1_datastore}"
  vm_disk1_keep_on_remove    = "${var.singlenode_vm_disk1_keep_on_remove}"
  vm_disk2_enable            = "${var.singlenode_vm_disk2_enable}"
  vm_disk2_size              = "${var.singlenode_vm_disk2_size}"
  vm_disk2_datastore         = "${var.singlenode_vm_disk2_datastore}"
  vm_disk2_keep_on_remove    = "${var.singlenode_vm_disk2_keep_on_remove}"
  vm_dns_servers             = "${var.vm_dns_servers}"
  vm_dns_suffixes            = "${var.vm_dns_suffixes}"
  random                     = "${random_string.random-dir.result}"
}

module "add_ansible_public_key" {
  source               = "./modules/add_public_ssh_key"
  private_key          = "${tls_private_key.generate.private_key_pem}"
  vm_os_password       = "${var.singlenode_vm_os_password}"
  vm_os_user           = "${var.singlenode_vm_os_user}"
  vm_ipv4_address_list = "${concat(var.singlenode_vm_ipv4_address)}"
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.deployVM_singlenode.dependsOn}"
  public_key           = "${var.ansible_public_key_openssh}"
}

module "execute_lamp_playbook" {
  source               = "./modules/execute_ansible"
  ansible_username     = "${var.ansible_username}"
  ansible_password     = "${var.ansible_password}"
  ansible_private_key  = "${var.ansible_private_key}"
  ansible_hostname     = "${var.ansible_hostname}"
  playbook_location    = "${var.playbook_location}"
  mysql_password       = "${var.mysql_password}"
  mysql_dbuser         = "${var.mysql_dbuser}"
  mysql_dbname         = "${var.mysql_dbname}"
  mysql_dbport         = "${var.mysql_dbport}"
  vm_ipv4_address_list = "${concat(var.singlenode_vm_ipv4_address)}"
  dependsOn            = "${module.add_ansible_public_key.dependsOn}"
}
