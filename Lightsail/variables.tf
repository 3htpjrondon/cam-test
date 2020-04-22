#####################################################################
##
##      Creado el 22/04/20 por admin. para Lightsail
##
#####################################################################

variable "name" {
  type = "string"
  description = "name for the lightsail instance"
  default = "training"
}

variable "availability_zone" {
  type = "string"
  description = "availability zone to deploy the lightsail instance"
  default = "us-west-2a"
}

variable "blueprint_id" {
  type = "string"
  description = "blueprint to be used for the instance"
  default = "ubuntu_16_04_2"
}

variable "key_pair_name" {
  type = "string"
  description = "key pair to be used for SSH conecction"
  default = "CAMOregonKP"
}

variable "bundle_id" {
  type = "string"
  description = "bundle to be used for Lightsail"
  default = "nano_2_0"
}

variable "Project" {
  type = "string"
  description = "tag for porject"
  default = "Induccion"
}

variable "Customer" {
  type = "string"
  description = "tag for customer"
  default = "3HTP"
}

variable "User" {
  type = "string"
  description = "tag for user"
  default = "user"
}

variable "Country" {
  type = "string"
  description = "tag for country"
  default = "Colombia"
}

variable "zone_id" {
  type = "string"
  description = "hosted zone in route 53 for the DNS record of the lightsail instance"
  default = "Z32NM2OZW9ZVMV"
}

variable "record_name" {
  type = "string"
  description = "record name for the lightsail instance"
  default = "training.born2bcloud.net"
}

