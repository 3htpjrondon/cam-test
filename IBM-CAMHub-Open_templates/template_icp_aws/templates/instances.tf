# Generate a new key if this is required for deployment
resource "random_id" "clusterid" {
  byte_length = "2"
}

# Generate a ICP admin password
resource "random_id" "adminpassword" {
  byte_length = "8"
}

locals  {
  icppassword    = "${var.icppassword != "" ? "${var.icppassword}" : "${random_id.adminpassword.hex}"}"
  iam_ec2_instance_profile_id = "${var.existing_ec2_iam_instance_profile_name != "" ?
        var.existing_ec2_iam_instance_profile_name :
        element(concat(aws_iam_instance_profile.icp_ec2_instance_profile.*.id, list("")), 0)}"
  efs_audit_mountpoints = "${concat(aws_efs_mount_target.icp-audit.*.dns_name, list(""))}"
  efs_registry_mountpoints = "${concat(aws_efs_mount_target.icp-registry.*.dns_name, list(""))}"
  image_package_uri = "${substr(var.image_location, 0, min(2, length(var.image_location))) == "s3" ?
    var.image_location :
      var.image_location  == "" ? "" : "s3://${element(concat(aws_s3_bucket.icp_binaries.*.id, list("")), 0)}/ibm-cloud-private.tar.gz"}"
  docker_package_uri = "${substr(var.docker_package_location, 0, min(2, length(var.docker_package_location))) == "s3" ?
    var.docker_package_location :
      var.docker_package_location == "" ? "" : "s3://${element(concat(aws_s3_bucket.icp_binaries.*.id, list("")), 0)}/icp-docker.bin"}"
  lambda_s3_bucket = "${element(concat(aws_s3_bucket.icp_lambda.*.id, list("")), 0)}"
  default_ami = "${var.ami != "" ? var.ami : data.aws_ami.rhel.id}"
}

## Search for a default Ubuntu image to allow this option
data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    // values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    values = ["RHEL*7.5_HVM*x86_64*Hourly*GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  // owners = ["099720109477"] # Canonical
  owners = ["309956199498"] # RedHat
}

## Search for a default Ubuntu image to allow this option
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
    //values = ["RHEL-7.4_HVM-*-x86_64-2-Hourly2-GP2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
  //owners = ["309956199498"] # RedHat
}

resource "aws_instance" "bastion" {
  count         = "${var.bastion["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.bastion["ami"] != "" ? var.bastion["ami"] : local.default_ami }"
  instance_type = "${var.bastion["type"]}"
  subnet_id     = "${element(aws_subnet.icp_public_subnet.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.default.id}",
    "${aws_security_group.bastion.id}"
  ]

  availability_zone = "${format("%s%s", element(list(var.aws_region), count.index), element(var.azs, count.index))}"
  associate_public_ip_address = true

  root_block_device {
    volume_size = "${var.bastion["disk"]}"
  }

  tags = "${merge(var.default_tags, map(
    "Name",  "${format("${var.instance_name}-${random_id.clusterid.hex}-bastion%02d", count.index + 1) }"
  ))}"
  user_data = <<EOF
#cloud-config
fqdn: ${format("${var.instance_name}-bastion%02d", count.index + 1)}.${random_id.clusterid.hex}.${var.private_domain}
users:
- default
manage_resolv_conf: true
resolv_conf:
  nameservers: [ ${cidrhost(element(aws_subnet.icp_private_subnet.*.cidr_block, count.index), 2)}]
  domain: ${random_id.clusterid.hex}.${var.private_domain}
  searchdomains:
  - ${random_id.clusterid.hex}.${var.private_domain}
EOF
}

resource "aws_instance" "icpmaster" {
  depends_on = [
    "aws_route_table_association.a",
    "aws_s3_bucket_object.docker_install_package",
    "aws_s3_bucket_object.hostfile",
    "aws_s3_bucket_object.icp_cert_crt",
    "aws_s3_bucket_object.icp_cert_key",
    "aws_s3_bucket_object.icp_config_yaml",
    "aws_s3_bucket_object.ssh_key",
    "aws_s3_bucket_object.bootstrap",
    "aws_s3_bucket_object.functions",
    "aws_s3_bucket_object.start_install"
  ]
  #subnet_id     = "${element(aws_subnet.icp_public_subnet.*.id, count.index)}"
  #associate_public_ip_address = true
  count         = "${var.master["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.master["ami"] != "" ? var.master["ami"] : local.default_ami }"
  instance_type = "${var.master["type"]}"

  availability_zone = "${format("%s%s", element(list(var.aws_region), count.index), element(var.azs, count.index))}"

  ebs_optimized = "${var.master["ebs_optimized"]}"
  root_block_device {
    volume_size = "${var.master["disk"]}"
  }

  # docker direct-lvm volume
  ebs_block_device {
    device_name       = "/dev/xvdx"
    volume_size       = "${var.master["docker_vol"]}"
    volume_type       = "gp2"
  }

  network_interface {
    network_interface_id = "${element(aws_network_interface.mastervip.*.id, count.index)}"
    device_index = 0
  }

  iam_instance_profile = "${local.iam_ec2_instance_profile_id}"


  tags = "${merge(
    var.default_tags,
    map("Name", "${format("${var.instance_name}-${random_id.clusterid.hex}-master%02d", count.index + 1) }"),
    map("kubernetes.io/cluster/${random_id.clusterid.hex}", "${random_id.clusterid.hex}")
  )}"

  user_data = <<EOF
#cloud-config
packages:
- unzip
- python
rh_subscription:
  enable-repo: rhui-REGION-rhel-server-optional
write_files:
- path: /tmp/bootstrap-node.sh
  permissions: '0755'
  encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap-node.sh"))}
runcmd:
- echo "`ifconfig | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }' | grep -v '^172\|^127'`  `hostname`" >> /etc/hosts
- /tmp/bootstrap-node.sh -c ${aws_s3_bucket.icp_config_backup.id} -s "bootstrap.sh functions.sh ${count.index == 0 ? "start_install.sh" : ""}"
- /tmp/icp_scripts/bootstrap.sh ${local.docker_package_uri != "" ? "-p ${local.docker_package_uri}" : "" } -d /dev/xvdx ${local.image_package_uri != "" ? "-i ${local.image_package_uri}" : "" } -s ${var.icp_inception_image} ${length(var.patch_images) > 0 ? "-a \"${join(" ", var.patch_images)}\"" : "" }
${count.index == 0 ? "
- /tmp/icp_scripts/start_install.sh -i ${var.icp_inception_image} -c ${aws_s3_bucket.icp_config_backup.id} -r ${aws_s3_bucket.icp_registry.id} -d ${aws_lb.icp-console.dns_name} ${length(var.patch_scripts) > 0 ? "-s \"${join(" ", var.patch_scripts)}\"" : "" }"
  :
"" }
${var.master["nodes"] > 1 ? "
mounts:
  - ['${element(local.efs_registry_mountpoints, count.index)}:/', '/var/lib/registry', 'nfs4', 'nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2', '0', '0']
  - ['${element(local.efs_audit_mountpoints, count.index)}:/', '/var/lib/icp/audit', 'nfs4', 'nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2', '0', '0']
"
:
"" }
users:
- default
- name: icpdeploy
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${tls_private_key.installkey.public_key_openssh}
fqdn:  ${format("${var.instance_name}-master%02d", count.index + 1) }.${random_id.clusterid.hex}.${var.private_domain}
manage_resolv_conf: true
resolv_conf:
  nameservers: [ ${cidrhost(element(aws_subnet.icp_private_subnet.*.cidr_block, count.index), 2)}]
  domain: ${random_id.clusterid.hex}.${var.private_domain}
  searchdomains:
  - ${random_id.clusterid.hex}.${var.private_domain}
EOF
}

##
#Monitor completion of ICP deploy.
##
resource "null_resource" "wait_for_icp"{
  depends_on = [
    "aws_instance.bastion",
	"aws_instance.icpmaster",
	"tls_private_key.installkey",
	"aws_lb.icp-console"
  ]
  
  # Specify the ssh connection
  connection {
  	type				= "ssh"
    user 				= "icpdeploy"
    host				= "${aws_instance.icpmaster.0.private_ip}" 
    private_key 		= "${tls_private_key.installkey.private_key_pem}"
    bastion_host        = "${aws_instance.bastion.0.public_ip}"
    bastion_user        = "ubuntu"
    bastion_private_key = "${base64decode(var.privatekey)}"
    bastion_port        = "22"
  }
    
  provisioner "file" {
    destination = "verify_icp_install.sh"
    content = <<EOF
#!/bin/bash
password=${local.icppassword}
while true
do
success_file="/opt/ibm/cluster/icp_install_completed"
failure_file="/opt/ibm/cluster/icp_install_failed"
if [ -f "$success_file" ] || [ -f "$failure_file" ]
then
echo "ICP install script execution completed."
break
else
echo "Wait for ICP deployment to be completed ..."
sleep 120
fi
done 
if [ -f "$failure_file" ]
then
echo "ICP deployment failed. Check /opt/ibm/cluster/logs in the boot master for more details."
exit 1
else
while true
do
response=`curl -s -o /dev/null -I -w "%{http_code}" -k https://${var.user_provided_cert_dns != "" ? var.user_provided_cert_dns : aws_lb.icp-console.dns_name}:8443/oidc/login.jsp`
if [ $response != 200 ]; then
echo "Login response is $${response}. Wait for ICP application to be available ..."
sleep 120
else
echo "Login response is $${response}. ICP application is available now ..."
break
fi
done   
while true
do
pre_req_check=`sudo cloudctl login -u admin -p $${password} -a https://${var.user_provided_cert_dns != "" ? var.user_provided_cert_dns : aws_lb.icp-console.dns_name}:8443 -n kube-system --skip-ssl-validation`
result=$?
echo $pre_req_check
if [ $result -eq "0" ]; then
echo "ICP application is available now ..."	
exit 0
else
echo "Prerequisite check failed. Wait for ICP to be available ..."
sleep 120
fi
done
fi  
EOF
  }  
  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "bash -c 'sudo chmod +x verify_icp_install.sh'",
      "bash -c 'sudo ./verify_icp_install.sh'"
    ]
  }  
}

resource "aws_instance" "icpproxy" {
  depends_on = [
    "aws_route_table_association.a",
    "aws_s3_bucket_object.bootstrap",
    "aws_s3_bucket_object.docker_install_package"
  ]

  count         = "${var.proxy["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.proxy["ami"] != "" ? var.proxy["ami"] : local.default_ami }"
  instance_type = "${var.proxy["type"]}"

  availability_zone = "${format("%s%s", element(list(var.aws_region), count.index), element(var.azs, count.index))}"

  ebs_optimized = "${var.proxy["ebs_optimized"]}"
  root_block_device {
    volume_size = "${var.proxy["disk"]}"
  }

  # docker direct-lvm volume
  ebs_block_device {
    device_name       = "/dev/xvdx"
    volume_size       = "${var.proxy["docker_vol"]}"
    volume_type       = "gp2"
  }

  network_interface {
    network_interface_id = "${element(aws_network_interface.proxyvip.*.id, count.index)}"
    device_index = 0
  }

  iam_instance_profile = "${local.iam_ec2_instance_profile_id}"

  tags = "${merge(
    var.default_tags,
    map("Name", "${format("${var.instance_name}-${random_id.clusterid.hex}-proxy%02d", count.index + 1) }"),
    map("kubernetes.io/cluster/${random_id.clusterid.hex}", "${random_id.clusterid.hex}")
  )}"


  user_data = <<EOF
#cloud-config
packages:
- unzip
- python
rh_subscription:
  enable-repo: rhui-REGION-rhel-server-optional
write_files:
- path: /tmp/bootstrap-node.sh
  permissions: '0755'
  encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap-node.sh"))}
runcmd:
- echo "`ifconfig | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }' | grep -v '^172\|^127'`  `hostname`" >> /etc/hosts
- /tmp/bootstrap-node.sh -c ${aws_s3_bucket.icp_config_backup.id} -s "bootstrap.sh"
- /tmp/icp_scripts/bootstrap.sh ${local.docker_package_uri != "" ? "-p ${local.docker_package_uri}" : "" } -d /dev/xvdx ${local.image_package_uri != "" ? "-i ${local.image_package_uri}" : "" } -s ${var.icp_inception_image} ${length(var.patch_images) > 0 ? "-a \"${join(" ", var.patch_images)}\"" : "" }
users:
- default
- name: icpdeploy
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${tls_private_key.installkey.public_key_openssh}
fqdn: ${format("${var.instance_name}-proxy%02d", count.index + 1)}.${random_id.clusterid.hex}.${var.private_domain}
manage_resolv_conf: true
resolv_conf:
  nameservers: [ ${cidrhost(element(aws_subnet.icp_private_subnet.*.cidr_block, count.index), 2)}]
  domain: ${random_id.clusterid.hex}.${var.private_domain}
  searchdomains:
  - ${random_id.clusterid.hex}.${var.private_domain}
EOF
}

resource "aws_instance" "icpmanagement" {
  depends_on = [
    "aws_route_table_association.a",
    "aws_s3_bucket_object.bootstrap",
    "aws_s3_bucket_object.docker_install_package"
  ]

  count         = "${var.management["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.management["ami"] != "" ? var.management["ami"] : local.default_ami }"
  instance_type = "${var.management["type"]}"
  subnet_id     = "${element(aws_subnet.icp_private_subnet.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.default.id}"
  ]

  availability_zone = "${format("%s%s", element(list(var.aws_region), count.index), element(var.azs, count.index))}"

  ebs_optimized = "${var.management["ebs_optimized"]}"
  root_block_device {
    volume_size = "${var.management["disk"]}"
  }

  # docker direct-lvm volume
  ebs_block_device {
    device_name       = "/dev/xvdx"
    volume_size       = "${var.management["docker_vol"]}"
    volume_type       = "gp2"
  }

  iam_instance_profile = "${local.iam_ec2_instance_profile_id}"

  tags = "${merge(
    var.default_tags,
    map("Name",  "${format("${var.instance_name}-${random_id.clusterid.hex}-management%02d", count.index + 1) }"),
    map("kubernetes.io/cluster/${random_id.clusterid.hex}", "${random_id.clusterid.hex}")
  )}"

  user_data = <<EOF
#cloud-config
packages:
- unzip
- python
rh_subscription:
  enable-repo: rhui-REGION-rhel-server-optional
write_files:
- path: /tmp/bootstrap-node.sh
  permissions: '0755'
  encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap-node.sh"))}
runcmd:
- echo "`ifconfig | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }' | grep -v '^172\|^127'`  `hostname`" >> /etc/hosts
- /tmp/bootstrap-node.sh -c ${aws_s3_bucket.icp_config_backup.id} -s "bootstrap.sh"
- /tmp/icp_scripts/bootstrap.sh ${local.docker_package_uri != "" ? "-p ${local.docker_package_uri}" : "" } -d /dev/xvdx ${local.image_package_uri != "" ? "-i ${local.image_package_uri}" : "" } -s ${var.icp_inception_image} ${length(var.patch_images) > 0 ? "-a \"${join(" ", var.patch_images)}\"" : "" }
users:
- default
- name: icpdeploy
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${tls_private_key.installkey.public_key_openssh}
fqdn: ${format("${var.instance_name}-management%02d", count.index + 1) }.${random_id.clusterid.hex}.${var.private_domain}
manage_resolv_conf: true
resolv_conf:
  nameservers: [ ${cidrhost(element(aws_subnet.icp_private_subnet.*.cidr_block, count.index), 2)}]
  domain: ${random_id.clusterid.hex}.${var.private_domain}
  searchdomains:
  - ${random_id.clusterid.hex}.${var.private_domain}
EOF
}

resource "aws_instance" "icpva" {
  depends_on = [
    "aws_route_table_association.a",
    "aws_s3_bucket_object.bootstrap",
    "aws_s3_bucket_object.docker_install_package"
  ]

  count         = "${var.va["nodes"]}"
  key_name      = "${var.key_name}"
  ami           = "${var.va["ami"] != "" ? var.va["ami"] : local.default_ami }"
  instance_type = "${var.va["type"]}"
  subnet_id     = "${element(aws_subnet.icp_private_subnet.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.default.id}"
  ]

  availability_zone = "${format("%s%s", element(list(var.aws_region), count.index), element(var.azs, count.index))}"

  ebs_optimized = "${var.va["ebs_optimized"]}"
  root_block_device {
    volume_size = "${var.va["disk"]}"
  }

  # docker direct-lvm volume
  ebs_block_device {
    device_name       = "/dev/xvdx"
    volume_size       = "${var.va["docker_vol"]}"
    volume_type       = "gp2"
  }

  iam_instance_profile = "${local.iam_ec2_instance_profile_id}"

  tags = "${merge(
    var.default_tags,
    map("Name",  "${format("${var.instance_name}-${random_id.clusterid.hex}-va%02d", count.index + 1) }"),
    map("kubernetes.io/cluster/${random_id.clusterid.hex}", "${random_id.clusterid.hex}")
  )}"

  user_data = <<EOF
#cloud-config
packages:
- unzip
- python
rh_subscription:
  enable-repo: rhui-REGION-rhel-server-optional
write_files:
- path: /tmp/bootstrap-node.sh
  permissions: '0755'
  encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap-node.sh"))}
runcmd:
- echo "`ifconfig | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }' | grep -v '^172\|^127'`  `hostname`" >> /etc/hosts
- /tmp/bootstrap-node.sh -c ${aws_s3_bucket.icp_config_backup.id} -s "bootstrap.sh"
- /tmp/icp_scripts/bootstrap.sh ${local.docker_package_uri != "" ? "-p ${local.docker_package_uri}" : "" } -d /dev/xvdx ${local.image_package_uri != "" ? "-i ${local.image_package_uri}" : "" } -s ${var.icp_inception_image} ${length(var.patch_images) > 0 ? "-a \"${join(" ", var.patch_images)}\"" : "" }
users:
- default
- name: icpdeploy
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${tls_private_key.installkey.public_key_openssh}
fqdn: ${format("${var.instance_name}-va%02d", count.index + 1) }.${random_id.clusterid.hex}.${var.private_domain}
manage_resolv_conf: true
resolv_conf:
  nameservers: [ ${cidrhost(element(aws_subnet.icp_private_subnet.*.cidr_block, count.index), 2)}]
  domain: ${random_id.clusterid.hex}.${var.private_domain}
  searchdomains:
  - ${random_id.clusterid.hex}.${var.private_domain}
EOF

}

resource "aws_instance" "icpnodes" {
  count         = "${var.worker["nodes"]}"

  # Make sure the nodes will have internet access before provisioning
  depends_on = [
    "aws_route_table_association.a",
    "aws_s3_bucket_object.bootstrap",
    "aws_s3_bucket_object.docker_install_package"
  ]

  key_name      = "${var.key_name}"
  ami           = "${var.worker["ami"] != "" ? var.worker["ami"] : local.default_ami }"
  instance_type = "${var.worker["type"]}"
  subnet_id     = "${element(aws_subnet.icp_private_subnet.*.id, count.index)}"
  vpc_security_group_ids = [
    "${aws_security_group.default.id}"
  ]

  availability_zone = "${format("%s%s", element(list(var.aws_region), count.index), element(var.azs, count.index))}"

  iam_instance_profile = "${local.iam_ec2_instance_profile_id}"

  ebs_optimized = "${var.worker["ebs_optimized"]}"
  root_block_device {
    volume_size = "${var.worker["disk"]}"
  }

  # docker direct-lvm volume
  ebs_block_device {
    device_name       = "/dev/xvdx"
    volume_size       = "${var.worker["docker_vol"]}"
    volume_type       = "gp2"
  }

  tags = "${merge(
    var.default_tags,
    map("Name",  "${format("${var.instance_name}-${random_id.clusterid.hex}-worker%02d", count.index + 1) }"),
    map("kubernetes.io/cluster/${random_id.clusterid.hex}", "${random_id.clusterid.hex}")
  )}"

  user_data = <<EOF
#cloud-config
packages:
- unzip
- python
rh_subscription:
  enable-repo: rhui-REGION-rhel-server-optional
write_files:
- path: /tmp/bootstrap-node.sh
  permissions: '0755'
  encoding: b64
  content: ${base64encode(file("${path.module}/scripts/bootstrap-node.sh"))}
runcmd:
- echo "`ifconfig | grep 'inet addr' | cut -d ':' -f 2 | awk '{ print $1 }' | grep -v '^172\|^127'`  `hostname`" >> /etc/hosts
- /tmp/bootstrap-node.sh -c ${aws_s3_bucket.icp_config_backup.id} -s "bootstrap.sh"
- /tmp/icp_scripts/bootstrap.sh ${local.docker_package_uri != "" ? "-p ${local.docker_package_uri}" : "" } -d /dev/xvdx ${local.image_package_uri != "" ? "-i ${local.image_package_uri}" : "" } -s ${var.icp_inception_image} ${length(var.patch_images) > 0 ? "-a \"${join(" ", var.patch_images)}\"" : "" }
users:
- default
- name: icpdeploy
  groups: [ wheel ]
  sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
  shell: /bin/bash
  ssh-authorized-keys:
  - ${tls_private_key.installkey.public_key_openssh}
fqdn: ${format("${var.instance_name}-worker%02d", count.index + 1) }.${random_id.clusterid.hex}.${var.private_domain}
manage_resolv_conf: true
resolv_conf:
  nameservers: [ ${cidrhost(element(aws_subnet.icp_private_subnet.*.cidr_block, count.index), 2)}]
  domain: ${random_id.clusterid.hex}.${var.private_domain}
  searchdomains:
  - ${random_id.clusterid.hex}.${var.private_domain}
EOF
}

output "bootmaster" {
  value = "${aws_instance.icpmaster.0.private_ip}"
}

output "bastion_host" {
  value = "${aws_instance.bastion.0.public_ip}"
}

resource "aws_network_interface" "mastervip" {
  count           = "${var.master["nodes"]}"
  subnet_id       = "${element(aws_subnet.icp_private_subnet.*.id, count.index)}"
  private_ips_count = 1

  security_groups = [
    "${compact(
        list(
          aws_security_group.default.id,
          aws_security_group.master.id,
          var.proxy["nodes"] == 0 ? aws_security_group.proxy.id : ""
      ))}"
  ]

  tags = "${merge(var.default_tags, map(
   "Name", "${format("${var.instance_name}-${random_id.clusterid.hex}-master%02d", count.index + 1) }"
 ))}"
}

resource "aws_network_interface" "proxyvip" {
  count           = "${var.proxy["nodes"]}"
  subnet_id       = "${element(aws_subnet.icp_private_subnet.*.id, count.index)}"
  private_ips_count = 1

  security_groups = [
    "${aws_security_group.default.id}",
    "${aws_security_group.proxy.id}"
  ]

  tags = "${merge(var.default_tags, map(
    "Name", "${format("${var.instance_name}-${random_id.clusterid.hex}-proxy%02d", count.index + 1) }"
  ))}"
}
