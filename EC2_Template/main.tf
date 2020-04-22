#####################################################################
##
##      Creado el 22/04/20 por admin. para EC2_Template
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  version = "~> 2.0"
  region = "us-west-1"
}

resource "aws_instance" "EC2-Instance" {

  ami = "${var.ami-id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_name}"
  associate_public_ip_address = "${var.instance_network}"
  
  tags = {
    Name = "${var.instance_name}"
  }
  
  root_block_device {
    volume_size = "${var.root_size}"
  } 
}