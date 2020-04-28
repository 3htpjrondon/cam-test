# Single Node
variable "singlenode_prefix_name" {
  type        = "string"
  description = "Single Node Hostname Prefix"
  default     = "playbookNode"
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
  default     = ["9.42.134.194"]
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

variable "ansible_public_key_openssh" {
  type        = "string"
  description = "Ansible Node Public SSH key Details"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXfZtX4pHoAskVPHIes18+3GngOBpP8vEqVeg3Q7XJfJJkROcTy5SXix7hTZ5LMppujRyGdcJ2qAvcbdksisNLm34WEZ1W1z2zLay06NkRdA/qM9XJZW0KyYGBjAYlD4ND7pkDaFCTgJ4niKR5/dRwXWhkI9GGbXOAW+9bhm6SntYc0+bpKozkES4/6mA3QhGD08Lr5ZDsDVrdIccCQ7l7f5WaRbK9G1aZ7MHFAkhxYRL6AFCqZCS0v3puOjpGhT2gETlt7RGKqFkKN9O8hqG7kFCYd3M6C3287BCGjUMd1ts+K0KKqByi6L0rQ+dB04fkHbBkmlksG31fou/ekLNEiSUK016RCqn8o7KYHMBaZdD9dKEPJf0BwlZh9rnpzAB++p8+hFpKb75MFfWqyCKivljL9G3ZLe+ez++QZEMeGRqC1QJvMJ+YjuLJHv7szKQsywg4SqafJbcR5gN8Kx6bxu9Sm3G5s0noLeQZXw9b076j74cCBhtCioVyy92VyDgN61tg2jIJ/ZvXBebenigZBh9aFTzJJjN6l9TSRdHzRbVz7M5JVGqeo3YYxa8KrkEeK6kD7Tygs5oQ+F4Pxmse6BJlpGWjoTfzk3rIGb6n623MyBhYvEsgGZCBrLDFEtiw0g37cDKVOO//2eP9ig5B9n7AalkYQZFa3H3ThJiabQ=="
}

variable "ansible_private_key" {
  type        = "string"
  description = "Ansible Node Private SSH key Details (base64)"
  default     = ""
}

variable "ansible_username" {
  description = "Ansible Username"
  default     = "root"
}

variable "ansible_password" {
  description = "Ansible Password"
  default     = "Op3nPatterns"
}

variable "ansible_hostname" {
  description = "Ansible Host"
  default     = "9.42.134.195"
}

variable "playbook_location" {
  description = "PlayBook Location"
  default     = "/root/ansible-examples-master/lamp_simple_rhel7"
}

variable "mysql_password" {
  description = "MySQL Password"
  default     = "Op3nPatterns"
}

variable "mysql_dbuser" {
  description = "MySQL Database UserName"
  default     = "dbuser"
}

variable "mysql_dbname" {
  description = "MySQL Database name"
  default     = "db01"
}

variable "mysql_dbport" {
  description = "MySQL Port Number"
  default     = "3309"
}
