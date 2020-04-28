#
output "ansible_mysql_" {
  value = "VM IP Address : ${var.singlenode_vm_ipv4_address[0]}"
}
