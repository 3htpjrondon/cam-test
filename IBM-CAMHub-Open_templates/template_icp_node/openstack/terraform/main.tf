provider "openstack" {
  version  = "~> 1.8"
  insecure = true
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

module "deployVM_new_worker" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//openstack_provision"

  #######
  count                             = "${length(keys(var.worker_hostname_ip))}"

  #######                                                                                                       
  vm_name                           = "${keys(var.worker_hostname_ip)}"
  vm_flavor_id                      = "${var.worker_vm_flavor_id}"
  vm_image_id                       = "${var.vm_image_id}"
  vm_security_groups                = "${var.vm_security_groups}"
  vm_os_password                    = "${var.vm_os_password}"
  vm_os_user                        = "${var.vm_os_user}"
  vm_domain                         = "${var.vm_domain}"
  vm_private_ssh_key                = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}"     : "${var.icp_private_ssh_key}"}"
  vm_public_ssh_key                 = "${length(var.icp_public_ssh_key)  == 0 ? "${tls_private_key.generate.public_key_openssh}"  : "${var.icp_public_ssh_key}"}"
  vm_public_ip_pool                 = "${var.vm_public_ip_pool}"
  vm_ipv4_address                   = "${values(var.worker_hostname_ip)}"
  vm_disk1_size                     = "${var.worker_vm_disk1_size}"
  vm_disk1_delete_on_termination    = "${var.worker_vm_disk1_delete_on_termination}"
  vm_disk2_enable                   = "${var.node_type == "worker" && var.worker_enable_glusterFS && var.worker_vm_disk2_enable}"
  vm_disk2_size                     = "${var.worker_vm_disk2_size}"
  vm_disk2_delete_on_termination    = "${var.worker_vm_disk2_delete_on_termination}"
  random                            = "${random_string.random-dir.result}"

  #######
  bastion_host               = "${var.bastion_host}"
  bastion_user               = "${var.bastion_user}"
  bastion_private_key        = "${var.bastion_private_key}"
  bastion_port               = "${var.bastion_port}"
  bastion_host_key           = "${var.bastion_host_key}"
  bastion_password           = "${var.bastion_password}" 
}

module "icp_prereqs" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_icp_prereqs"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  #vm_ipv4_address_list = "${compact(concat(var.nfs_server_vm_ipv4_address, var.boot_vm_ipv4_address, var.master_vm_ipv4_address, var.proxy_vm_ipv4_address, var.manage_vm_ipv4_address, var.worker_vm_ipv4_address, var.va_vm_ipv4_address))}"
  vm_ipv4_address_list = "${values(var.worker_hostname_ip)}"
  #######
  bastion_host               = "${var.bastion_host}"
  bastion_user               = "${var.bastion_user}"
  bastion_private_key        = "${var.bastion_private_key}"
  bastion_port               = "${var.bastion_port}"
  bastion_host_key           = "${var.bastion_host_key}"
  bastion_password           = "${var.bastion_password}"
  #######
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.deployVM_new_worker.dependsOn}" 
}

module "push_hostfile" {
  source               = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_hostfile"
  private_key          = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user           = "${var.vm_os_user}"
  vm_os_password       = "${var.vm_os_password}"
  #vm_ipv4_address_list = "${concat(var.boot_vm_ipv4_address, var.master_vm_ipv4_address, var.worker_vm_ipv4_address)}"
  vm_ipv4_address_list = "${values(var.worker_hostname_ip)}"
  #######
  bastion_host               = "${var.bastion_host}"
  bastion_user               = "${var.bastion_user}"
  bastion_private_key        = "${var.bastion_private_key}"
  bastion_port               = "${var.bastion_port}"
  bastion_host_key           = "${var.bastion_host_key}"
  bastion_password           = "${var.bastion_password}"
  #######
  random               = "${random_string.random-dir.result}"
  dependsOn            = "${module.icp_prereqs.dependsOn}"
}

module "glusterFS" {
  source                  = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_glusterFS"
  vm_ipv4_address_list    = "${values(var.worker_hostname_ip)}"
  vm_ipv4_address_str     = "${join(" ", values(var.worker_hostname_ip))}"
  enable_glusterFS        = "${var.node_type == "worker" && var.worker_enable_glusterFS}"
  random                  = "${random_string.random-dir.result}"
  private_key             = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user              = "${var.vm_os_user}"
  vm_os_password          = "${var.vm_os_password}"
  boot_vm_ipv4_address    = "${var.boot_vm_ipv4_address}"
  gluster_volumetype_none = "${var.gluster_volumetype_none}"
  #######
  bastion_host               = "${var.bastion_host}"
  bastion_user               = "${var.bastion_user}"
  bastion_private_key        = "${var.bastion_private_key}"
  bastion_port               = "${var.bastion_port}"
  bastion_host_key           = "${var.bastion_host_key}"
  bastion_password           = "${var.bastion_password}"
  #######
  dependsOn               = "${module.push_hostfile.dependsOn}"
}

# Adding ICP Node
module "Add_ICP_Node" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//config_add_node"
  icp_version = "${var.icp_version}"
  boot_node_IP = "${var.boot_vm_ipv4_address}"
  new_node_IPs = "${values(var.worker_hostname_ip)}"
  node_type  = "${var.node_type}"
  enable_glusterFS = "${var.node_type == "worker" && var.worker_enable_glusterFS}"
  private_key = "${length(var.icp_private_ssh_key) == 0 ? "${tls_private_key.generate.private_key_pem}" : "${var.icp_private_ssh_key}"}"
  vm_os_user = "${var.vm_os_user}"
  vm_os_password = "${var.vm_os_password}"
  cluster_location = "${var.cluster_location}"
  #######
  bastion_host               = "${var.bastion_host}"
  bastion_user               = "${var.bastion_user}"
  bastion_private_key        = "${var.bastion_private_key}"
  bastion_port               = "${var.bastion_port}"
  bastion_host_key           = "${var.bastion_host_key}"
  bastion_password           = "${var.bastion_password}"
  #######
  dependsOn = "${module.glusterFS.dependsOn}"
}
