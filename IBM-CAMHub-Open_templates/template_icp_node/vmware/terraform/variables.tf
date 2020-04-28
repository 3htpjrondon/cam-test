variable "vsphere_datacenter" {
  type = "string"
}

variable "vsphere_resource_pool" {
  type = "string"
}
#---------Worker VM----------------------
variable "worker_vcpu" {
  type    = "string"
  default = "16"
}

variable "worker_memory" {
  type = "string"
  default = "32768"
}

variable "worker_vm_disk1_size" {
  type = "string"
  default = "200"
}

variable "vm_disk1_datastore" {
  type = "string"
}

variable "worker_vm_disk1_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "worker_vm_disk2_enable" {
  type    = "string"
  default = "true"
}

variable "worker_vm_disk2_size" {
  type = "string"
  default = "85"
}

variable "vm_disk2_datastore" {
  type = "string"
}

variable "worker_vm_disk2_keep_on_remove" {
  type    = "string"
  default = "false"
}

variable "vm_template" {
  type = "string"
}

variable "vm_os_password" {
  type = "string"
}

variable "vm_os_user" {
  type = "string"
}

#------------- VM Generic Items ------------
variable "vm_domain" {
  type = "string"
}

variable "vm_folder" {
  type = "string"
}

#----------------- SSH KEY Information ------------
variable "icp_private_ssh_key" {
  type = "string"
  default = ""
}

variable "icp_public_ssh_key" {
  type = "string"
  default = ""
}
#----------- Network ----------------
variable "vm_network_interface_label" {
  type = "string"
}

variable "worker_hostname_ip" {
  type = "map"
}

variable "worker_vm_ipv4_gateway" {
  type = "string"
}

variable "worker_vm_ipv4_prefix_length" {
  type = "string"
}

variable "vm_adapter_type" {
  type    = "string"
  default = "vmxnet3"
}

variable "vm_dns_servers" {
  type = "list"
}

variable "vm_dns_suffixes" {
  type = "list"
}

#------- Master / Boot VM Details --------
variable "master_vm_ipv4_address" {
  type = "string"
}

variable "boot_vm_ipv4_address" {
  type = "string"
}

#--------- GlusterFS ------------
variable "worker_enable_glusterFS" {
  type    = "string"
  default = "true"
}

variable "gluster_volumetype_none" {
  type        = "string"
  default     = "false"
  description = "Gluster durability"
}

#--------- ICP / Docker Reg--------
variable "icp_version" {
  type = "string"
  default = "3.1.1"
}

variable "node_type" {}

variable "cluster_location" {}

variable "vm_clone_timeout" {
  description = "The timeout, in minutes, to wait for the virtual machine clone to complete."
  default = "30"
}