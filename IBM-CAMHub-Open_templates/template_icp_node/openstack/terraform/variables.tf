#---------Worker VM----------------------
variable "worker_vm_flavor_id" {
  type = "string"
}


variable "vm_security_groups" {
  type = "list"
}

variable "worker_vm_disk1_size" {
  type = "string"
  default = "200"
}

variable "worker_vm_disk1_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "worker_vm_disk2_enable" {
  type    = "string"
  default = "true"
}

variable "worker_vm_disk2_size" {
  type = "string"
  default = "85"
}

variable "worker_vm_disk2_delete_on_termination" {
  type    = "string"
  default = "true"
}

variable "vm_image_id" {
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
variable "worker_hostname_ip" {
  type = "map"
}

variable "vm_public_ip_pool" {
  type = "string"
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
  default = "2.1.0.3"
}

variable "node_type" {}

variable "cluster_location" {}
