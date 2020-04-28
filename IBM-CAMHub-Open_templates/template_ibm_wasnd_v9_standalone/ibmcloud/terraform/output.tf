output "WAS Admin Console DNS URL" {
  value = "<a href='http://${var.WASNode01-name}:9060/ibm/console' target='_blank'>http://${var.WASNode01-name}:9060/ibm/console</a>"
}

output "WAS Admin Console IP URL" {
  value = "<a href='http://${ibm_compute_vm_instance.WASNode01.ipv4_address}:9060/ibm/console' target='_blank'>http://${ibm_compute_vm_instance.WASNode01.ipv4_address}:9060/ibm/console</a>"
}
