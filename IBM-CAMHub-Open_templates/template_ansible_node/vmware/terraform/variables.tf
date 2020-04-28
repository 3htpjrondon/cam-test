# Single Node
variable "singlenode_prefix_name" {
  type        = "string"
  description = "Single Node Hostname Prefix"
  default     = "ansible_node"
}

variable "singlenode_vcpu" {
  type        = "string"
  description = "Single Node vCPU Allocation"
  default     = "2"
}

variable "singlenode_memory" {
  type        = "string"
  description = "Single Node Node Memory Allocation (mb)"
  default     = "4096"
}

variable "singlenode_vm_template" {
  type        = "string"
  description = "Virtual Machine Template Name"
  default     = "Content/ContentRH_Template_2018_1Q"
}

variable "singlenode_vm_os_user" {
  type        = "string"
  description = "The user name to use while configuring the Single Node."
  default     = "root"
}

variable "singlenode_vm_os_password" {
  type        = "string"
  description = "The user password to use while configuring the Single Node"
  default     = "Op3nPatterns"
}

variable "singlenode_vm_ipv4_address" {
  type        = "list"
  description = "Single Node IP Address (list)"
  default     = ["9.42.134.195"]
}

variable "singlenode_vm_ipv4_gateway" {
  type        = "string"
  description = "Single Node IP Gateway Address"
  default     = "9.42.134.1"
}

variable "singlenode_vm_ipv4_prefix_length" {
  type        = "string"
  description = "Integer value between 1 and 32 for the prefix length, CIDR, to use when statically assigning an IPv4 address"
  default     = "24"
}

variable "singlenode_vm_disk1_size" {
  type        = "string"
  description = "Single Node Disk Size (GB)"
  default     = "100"
}

variable "singlenode_vm_disk1_datastore" {
  type        = "string"
  description = "Virtual Machine Datastore Name - Disk 1"
  default     = "CAM01-RSX6-002"
}

variable "singlenode_vm_disk1_keep_on_remove" {
  type        = "string"
  description = "Single Node Keep Disk on Remove"
  default     = "true"
}

variable "singlenode_vm_disk2_enable" {
  type        = "string"
  description = "Single Node Disk 2"
  default     = "false"
}

variable "singlenode_vm_disk2_size" {
  type        = "string"
  description = "Single Node Disk 2 Size (GB)"
  default     = ""
}

variable "singlenode_vm_disk2_datastore" {
  type        = "string"
  description = "Virtual Machine Datastore Name - Disk 2"
  default     = ""
}

variable "singlenode_vm_disk2_keep_on_remove" {
  type        = "string"
  description = "Single Node Keep Disk 2 on Remove"
  default     = ""
}

variable "vm_domain" {
  type        = "string"
  description = "Single Node Virtual Machine's domain name"
  default     = "rtp.raleigh.ibm.com"
}

variable "vm_network_interface_label" {
  type        = "string"
  description = "vSphere Port Group name to assign to this network interface."
  default     = "VIS241"
}

variable "vm_adapter_type" {
  type        = "string"
  description = "Network adapter type for vNIC Configuration"
  default     = "vmxnet3"
}

variable "vm_folder" {
  type        = "string"
  description = "vSphere Folder name"
  default     = "Content"
}

variable "vm_dns_servers" {
  type        = "list"
  description = "List of DNS servers for the virtual network adapter. For more than one DNS, the values can be entered by adding more fields."
  default     = ["9.42.106.2"]
}

variable "vm_dns_suffixes" {
  type        = "list"
  description = "Name resolution suffixes for the virtual network adapter"
  default     = ["rtp.raleigh.ibm.com"]
}

variable "vsphere_datacenter" {
  type        = "string"
  description = "The name of a Datacenter in which to launch the Single Node."
  default     = "CAMDC1"
}

variable "vsphere_resource_pool" {
  type        = "string"
  description = "Name of the default resource pool for the cluster. Specified as 'cluster_name/resource_pool'"
  default     = "CAM01/Resources"
}
