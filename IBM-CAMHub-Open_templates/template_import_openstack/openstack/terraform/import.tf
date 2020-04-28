provider "openstack" {
  insecure = true
}

variable "image_name" {
  description = "Name of the image"
}

variable "flavor_name" {
  description = "Name of the flavor"
}

variable "force_delete" {
  description = "Whether to force the instance to be forcefully deleted"
  default     = "false"
}

variable "key_pair" {
  description = "Name of the key pair"
}

variable "metadata" {
  type        = "map"
  description = "Metadata for this instance"
}

variable "name" {
  description = "Name of the instance"
}

variable "network_0_name" {
  description = "Name of the network"
}

variable "network_0_fixed_ip_v4" {
  description = "The fixed IPv4 address of the instance"
}

variable "security_groups" {
  type        = "list"
  description = "List of security groups"
}

variable "stop_before_destroy" {
  description = "Whether to try stop the instance gracefully before destroying it"
  default     = "false"
}

resource "openstack_compute_instance_v2" "vm_1" {
  name  = "${var.name}"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  key_pair = "${var.key_pair}"
  security_groups = "${var.security_groups}"
  force_delete = "${var.force_delete}"
  stop_before_destroy = "${var.stop_before_destroy}"
  metadata = "${var.metadata}"
  network {
    name = "${var.network_0_name}"
    fixed_ip_v4 = "${var.network_0_fixed_ip_v4}"
  }
}