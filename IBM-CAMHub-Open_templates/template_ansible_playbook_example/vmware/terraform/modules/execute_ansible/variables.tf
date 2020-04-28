variable "vm_ipv4_address_list" {
  type        = "list"
  description = "IPv4 Address's in List format"
}

variable "dependsOn" {
  default     = "true"
  description = "Boolean for dependency"
}

variable "ansible_hostname" {
  description = "Ansible Host"
}

variable "ansible_username" {
  description = "Ansible Username"
}

variable "ansible_password" {
  description = "Ansible Password"
}

variable "ansible_private_key" {
  description = "Ansible Private Key"
}

variable "playbook_location" {}
variable "mysql_password" {}
variable "mysql_dbuser" {}
variable "mysql_dbname" {}
variable "mysql_dbport" {}
