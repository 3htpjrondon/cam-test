#####################################################################
##
##      Creado el 22/04/20 por admin. para Lightsail
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  version = "~> 2.0"
}

resource "aws_lightsail_instance" "ls-instance" {

  name = "${var.name}"
  availability_zone = "${var.availability_zone}"
  blueprint_id = "${var.blueprint_id}"
  bundle_id = "${var.bundle_id}"
  key_pair_name = "${var.key_pair_name}"
  
    tags = {
    Project = "${var.Project}"
    Customer = "${var.Customer}"
    User = "${var.User}"
    Country = "${var.Country}"
  }
}

resource "aws_route53_record" "ls-record" {

  zone_id = "${var.zone_id}"
  name = "${var.record_name}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_lightsail_instance.ls-instance.public_ip_address}"]
}

output "lightsail_public_ip" {
  value = "${aws_lightsail_instance.ls-instance.public_ip_address}"
}

