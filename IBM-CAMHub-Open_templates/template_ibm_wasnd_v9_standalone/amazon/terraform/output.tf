output "WAS Admin Console DNS URL" {
  value = "<a href='http://${var.WASNode01-name}:9060/ibm/console' target='_blank'>http://${var.WASNode01-name}:9060/ibm/console</a>"
}

output "WAS Admin Console IP URL" {
  value = "<a href='http://${aws_instance.WASNode01.public_ip}:9060/ibm/console' target='_blank'>http://${aws_instance.WASNode01.public_ip}:9060/ibm/console</a>"
}
