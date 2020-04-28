##################################
## Configure the provider
##################################
# Details about authentication options here: https://www.terraform.io/docs/providers/azurerm

provider "azurerm" { }



##################################
## Create a resource group
##################################
resource "azurerm_resource_group" "icp" {
  name     = "${var.resource_group}_${random_id.clusterid.id}"
  location = "${var.location}"

  tags = "${merge(
    var.default_tags, map(
      "Clusterid", "${random_id.clusterid.hex}",
      "Name", "${var.instance_name}"
    )
  )}"
}
##################################
## Create the SSH key terraform will use for installation
##################################
resource "tls_private_key" "installkey" {
  algorithm   = "RSA"
}

resource "tls_private_key" "vmkey" {
  algorithm   = "RSA"
}

##################################
## Create a random id to uniquely identifying cluster
##################################
resource "random_id" "clusterid" {
  byte_length = 4
}

# Generate a random string in case user wants us to generate admin password
resource "random_id" "adminpassword" {
  byte_length = "16"
}

locals {
  icppassword    = "${var.icpadmin_password != "" ? "${var.icpadmin_password}" : "P${random_id.adminpassword.hex}"}!p"

  # This is just to have a long list of disabled items to use in icp-deploy.tf
  disabled_list = "${list("disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled","disabled")}"

  disabled_management_services = "${zipmap(var.disabled_management_services, slice(local.disabled_list, 0, length(var.disabled_management_services)))}"
}
