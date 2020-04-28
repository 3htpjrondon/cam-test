
########## __________ V A R I A B L E S __________ ##########


variable "ibm_cloud_organization" {
  description = "specify your IBM Cloud organization name"
}

variable "ibm_cloud_space" {
  description = "specify your IBM Cloud space name"
}


variable "application_hostname" {
  description = "specify the hostname for the application's route. The specified hostname will then be extended by '.mybluemix.net'"
}

variable "application_version" {
  description = "specify the version of the application. A change of this parameters is an indication for terraform that the application code has changed and needs redeployment."
  default = "100"
}

variable "application_instances" {
  description = "specify the number of cloud foundry application instances to be deployed"
  default = "1"
}




########## __________ M A I N __________ ##########

# Configure the IBM Cloud Provider
provider "ibm" {
/*bluemix_api_key             = "${var.ibm_bmx_api_key}"*/
}

data "ibm_space" "myspace" {
  org   = "${var.ibm_cloud_organization}"
  space = "${var.ibm_cloud_space}"
}

# Create an Cloud Froundry application
resource "ibm_app" "cfapp" {
  name              = "cfgo-${var.application_hostname}"
  space_guid        = "${data.ibm_space.myspace.id}"
  wait_time_minutes = 10
  buildpack         = "go_buildpack"
  app_path          = "${path.module}/appcode/goapp.zip"
  app_version       = "${var.application_version}"
  route_guid        = ["${ibm_app_route.myroute.id}"]
  instances         = "${var.application_instances}"
}


data "ibm_app_domain_shared" "mydomain" {
  name = "mybluemix.net"
}

resource "ibm_app_route" "myroute" {
  domain_guid = "${data.ibm_app_domain_shared.mydomain.id}"
  space_guid  = "${data.ibm_space.myspace.id}"
  host        = "${var.application_hostname}"
}




########## __________ O U T P U T S __________ ##########

output "final_output" {
    value = " https://${var.application_hostname}.${data.ibm_app_domain_shared.mydomain.name}"
}
