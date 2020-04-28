#
output "Ansible Public SSH Key for other machines" {
  value = "${tls_private_key.generate.public_key_openssh}"
}
