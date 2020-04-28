output "WAS Admin Console DNS URL" {
  value = "<a href='http://${var.WASNode01-name}:9060/ibm/console' target='_blank'>http://${var.WASNode01-name}:9060/ibm/console</a>"
}

output "WAS Admin Console IP URL" {
  value = "<a href='http://${vsphere_virtual_machine.WASNode01.clone.0.customize.0.network_interface.0.ipv4_address}:9060/ibm/console' target='_blank'>http://${vsphere_virtual_machine.WASNode01.clone.0.customize.0.network_interface.0.ipv4_address}:9060/ibm/console</a>"
}
