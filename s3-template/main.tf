#####################################################################
##
##      Creado el 22/04/20 por admin. para aws-env-test
##
#####################################################################

terraform {
  required_version = "> 0.8.0"
}

provider "aws" {
  version = "~> 2.0"
  region  = "us-west-1"
}

resource "aws_s3_bucket" "CAM-bucket" {
  bucket = "${var.bucket}"
  acl    = "private"
}