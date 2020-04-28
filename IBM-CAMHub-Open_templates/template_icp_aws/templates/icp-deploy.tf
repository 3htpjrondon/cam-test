resource "aws_s3_bucket_object" "icp_cert_crt" {
  count = "${var.user_provided_cert_dns != "" ? 1 : 0}"
  bucket = "${aws_s3_bucket.icp_config_backup.id}"
  key    = "cfc-certs/icp-auth.crt"
  source = "${path.module}/cfc-certs/icp-auth.crt"
}

resource "aws_s3_bucket_object" "icp_cert_key" {
  count = "${var.user_provided_cert_dns != "" ? 1 : 0}"
  bucket = "${aws_s3_bucket.icp_config_backup.id}"
  key    = "cfc-certs/icp-auth.key"
  source = "${path.module}/cfc-certs/icp-auth.key"
}

resource "aws_s3_bucket_object" "hostfile" {
  bucket = "${aws_s3_bucket.icp_config_backup.id}"
  key    = "hosts"
  content = <<EOF
[master]
${join("\n", formatlist("%v", aws_network_interface.mastervip.*.private_ip))}

[proxy]
${var.proxy["nodes"] > 0 ?
  join("\n", formatlist("%v", aws_network_interface.proxyvip.*.private_ip)) :
  join("\n", formatlist("%v", aws_network_interface.mastervip.*.private_ip))
}

[management]
${var.management["nodes"] > 0 ?
  join("\n", formatlist("%v", aws_instance.icpmanagement.*.private_ip)) :
  join("\n", formatlist("%v", aws_network_interface.mastervip.*.private_ip))
}

${var.va["nodes"] > 0 ? "
[va]
${join("\n", formatlist("%v", aws_instance.icpva.*.private_ip))}
" :
""
}

[worker]
${join("\n", formatlist("%v", aws_instance.icpnodes.*.private_ip))}

EOF
#  source = "${path.module}/hostlist.txt"
}

resource "aws_s3_bucket_object" "icp_config_yaml" {
  bucket = "${aws_s3_bucket.icp_config_backup.id}"
  key    = "icp-terraform-config.yaml"
  content = <<EOF
kubelet_nodename: fqdn
${var.use_aws_cloudprovider ? "cloud_provider: aws" : "" }
calico_tunnel_mtu: 8981
ansible_user: icpdeploy
ansible_become: true
network_cidr: ${var.icp_network_cidr}
service_cluster_ip_range: ${var.icp_service_network_cidr}
default_admin_password: ${local.icppassword}
proxy_lb_address: ${aws_lb.icp-proxy.dns_name}
cluster_lb_address: ${aws_lb.icp-console.dns_name}
cluster_CA_domain: ${var.user_provided_cert_dns != "" ? var.user_provided_cert_dns : aws_lb.icp-console.dns_name}
disabled_management_services: [ "istio", "custom-metrics-adapter", "${var.va["nodes"] == 0 ? "va" : "" }", "${var.va["nodes"] == 0 ? "vulnerability-advisor": ""}" ]
kibana_install: true
cluster_name: ${var.instance_name}
EOF
#  source = "${path.module}/items-config.yaml"
}

output "cluster_ca_domain" {
  value =  "${var.user_provided_cert_dns != "" ? var.user_provided_cert_dns : aws_lb.icp-console.dns_name}"
}

resource "tls_private_key" "installkey" {
  algorithm   = "RSA"
}

output "vm_os_private_key" {
  value = "${base64encode(tls_private_key.installkey.private_key_pem)}"
}

resource "aws_s3_bucket_object" "ssh_key" {
  bucket = "${aws_s3_bucket.icp_config_backup.id}"
  key    = "ssh_key"
  content = "${tls_private_key.installkey.private_key_pem}"
}

output "ICP_Console_ELB_DNS" {
  value = "${aws_lb.icp-console.dns_name}"
}

output "ICP_Proxy_ELB_DNS_internal" {
  value = "${aws_lb.icp-proxy.dns_name}"
}

output "icp_klusterlet_dns" {
  value = "${aws_lb.icp-klusterlet.dns_name}"
}

output "ICP_Console_URL" {
  value = "https://${var.user_provided_cert_dns != "" ? var.user_provided_cert_dns : aws_lb.icp-console.dns_name}:8443"
}

output "ICP_Registry_ELB_URL" {
  value = "https://${aws_lb.icp-console.dns_name}:8500"
}

output "ICP_Kubernetes_API_URL" {
  value = "https://${aws_lb.icp-console.dns_name}:8001"
}

output "ICP_Admin_Username" {
  value = "admin"
}

output "ICP_Admin_Password" {
  value = "${local.icppassword}"
}

output "connection_name"{
	value = "${var.instance_name}${random_id.clusterid.hex}" 
}


