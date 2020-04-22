#####################################################################
##
##      Creado el 22/04/20 por admin. para EC2_Template
##
#####################################################################

variable "ami-id" {
  type = "string"
  description = "ami to use for the EC2 instance"
  default = "ami-06fcc1f0bc2c8943f"
}

variable "instance_type" {
  type = "string"
  description = "Generado"
  default = "t2.micro"
}

variable "key_name" {
  type = "string"
  description = "Key pair name to be used"
  default = "CAM-demo-keypair"
}

variable "instance_network" {
  type = "string"
  description = "Assign Public IP address to the instance"
  default = "true"
}

variable "root_size" {
  type = "string"
  description = "Size in GiB of the root volume"
  default = "20"
}

variable "instance_name" {
  type = "string"
  description = "Name of the EC2 instance"
  default = "ec2-cam-test"
}


