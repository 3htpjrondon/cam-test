###
output "ibm_cloud_private_admin_url" {
  value = "https://${element(azurerm_public_ip.master_pip.*.fqdn, 0)}:8443"
}

output "ICP Registry URL" {
  value = "https://${element(azurerm_public_ip.master_pip.*.fqdn, 0)}:8500"
}

output "ICP Kubernetes API URL" {
  value = "https://${element(azurerm_public_ip.master_pip.*.fqdn, 0)}:8001"
}

output "cloudctl" {
  value = "cloudctl login --skip-ssl-validation -a https://${element(azurerm_public_ip.master_pip.*.fqdn, 0)}:8443 -u admin -p ${local.icppassword} -n default -c id-${var.cluster_name}-account"
}

output "ibm_cloud_private_cluster_name" {
  value = "${var.cluster_name}"
}

output "ibm_cloud_private_cluster_CA_domain_name" {
  value = "${element(azurerm_public_ip.master_pip.*.fqdn, 0)}"
}

output "ibm_cloud_private_admin_user" {
  value = "admin"
}

output "ibm_cloud_private_admin_password" {
  value = "${local.icppassword}"
}

output "ibm_cloud_private_boot_ip" {
  value = "${element(azurerm_public_ip.master_pip.*.ip_address, 0)}"
}

output "ibm_cloud_private_master_ip" {
  value = "${element(azurerm_public_ip.master_pip.*.fqdn, 0)}"
}

output "ibm_cloud_private_ssh_user" {
  value = "${var.admin_username}"
}

output "ibm_cloud_private_ssh_key" {
  value = "${base64encode(tls_private_key.vmkey.private_key_pem)}"
}

output "connection_name" {
	value = "${var.cluster_name}${random_id.clusterid.hex}"
}