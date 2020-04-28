##################################
## This module handles all the ICP confifguration
## and prerequisites setup
##################################

# Azure client config let's us pull out some details such as subscription ID
# which is used by the azure cloud provider
data "azurerm_client_config" "client_config" {}

locals {

  docker_username = "${var.registry_username != "" ? var.registry_username : "admin"}"
  docker_password = "${var.registry_password != "" ? var.registry_password : "${local.icppassword}"}"

  # Intermediate interpolations
  credentials = "${var.registry_username != "" ? join(":", list("${var.registry_username}"), list("${var.registry_password}")) : ""}"
  cred_reg   = "${local.credentials != "" ? join("@", list("${local.credentials}"), list("${var.private_registry}")) : ""}"

  # Inception image formatted for ICP deploy module
  inception_image = "${local.cred_reg != "" ? join("/", list("${local.cred_reg}"), list("${var.icp_inception_image}")) : var.icp_inception_image}"

}

module "icpprovision" {
  source = "git::https://github.com/IBM-CAMHub-Open/template_icp_modules.git?ref=2.3//public_cloud"

  bastion_host = "${azurerm_public_ip.bootnode_pip.ip_address}"
  
  ssh_agent = false
  install-verbosity = "${var.install_verbosity != "" ? "${var.install_verbosity}" : ""}"

  # Provide IP addresses for boot, master, mgmt, va, proxy and workers
  boot-node = "${element(concat(azurerm_network_interface.boot_nic.*.private_ip_address, list("")), 0)}"

  icp-host-groups = {
    master      = ["${azurerm_network_interface.master_nic.*.private_ip_address}"]
    worker      = ["${azurerm_network_interface.worker_nic.*.private_ip_address}"]
    proxy       = ["${azurerm_network_interface.proxy_nic.*.private_ip_address}"]
    management  = ["${azurerm_network_interface.management_nic.*.private_ip_address}"]
    va          = ["${azurerm_network_interface.va_nic.*.private_ip_address}"]
    
  }

  icp-version = "${local.inception_image}"  
  #image file set if the binaries are loaded from Azure container
  image_file = "${var.image_location != "" ? "/opt/ibm/cluster/images/${basename(var.image_location)}" : "/dev/null" }"
  #docker image file set if the binaries are loaded from Azure container  
  docker_package_location="${var.docker_image_location != "" ? "/tmp/icp-docker/icp-docker.bin" : "" }"  

  # Workaround for terraform issue #10857
  # When this is fixed, we can work this out automatically

  cluster_size  = "${var.boot["nodes"] + var.master["nodes"] + var.worker["nodes"] + var.proxy["nodes"] + var.management["nodes"] + var.va["nodes"] }"

  icp_configuration = {
    "network_cidr"              = "${var.network_cidr}"
    "service_cluster_ip_range"  = "${var.cluster_ip_range}"
    "ansible_user"              = "${var.admin_username}"
    "ansible_become"            = "true"
    "cluster_lb_address"        = "${azurerm_public_ip.master_pip.fqdn}"
    "proxy_lb_address"          = "${azurerm_public_ip.proxy_pip.fqdn}"
    "cluster_CA_domain"         = "${azurerm_public_ip.master_pip.fqdn}"
    "cluster_name"              = "${var.cluster_name}"

    "private_registry_enabled"  = "${var.private_registry != "" ? "true" : "false"}"
    # "private_registry_server"   = "${var.private_registry}"
    "image_repo"                = "${var.private_registry != "" ? "${var.private_registry}/${dirname(var.icp_inception_image)}" : ""}"
    "docker_username"           = "${local.docker_username}"
    "docker_password"           = "${local.docker_password}"

    # An admin password will be generated if not supplied in terraform.tfvars
    "default_admin_password"          = "${local.icppassword}"

    # This is the list of disabled management services
    "management_services"             = "${local.disabled_management_services}"

    "calico_ip_autodetection_method" = "can-reach=${azurerm_network_interface.master_nic.0.private_ip_address}"
    "kubelet_nodename"          = "fqdn"

    #"cloud_provider"            = "azure"

    # If you want to use calico in policy only mode and Azure routed routes.
    "kube_controller_manager_extra_args" = ["--allocate-node-cidrs=true"]
    "kubelet_extra_args" = ["--enable-controller-attach-detach=true"]

    # Azure specific configurations
    # We don't need ip in ip with Azure networking
    "calico_ipip_enabled"       = "false"
    # Settings for patched icp-inception
    "calico_networking_backend"  = "none"
    "calico_ipam_type"           = "host-local"
    "calico_ipam_subnet"         = "usePodCidr"
    # Try this later: "calico_cluster_type" = "k8s"
    "azure"                  = {

      "cloud_provider_conf" = {
          "cloud"               = "AzurePublicCloud"
          "useInstanceMetadata" = "true"
          "tenantId"            = "${data.azurerm_client_config.client_config.tenant_id}"
          "subscriptionId"      = "${data.azurerm_client_config.client_config.subscription_id}"
          "resourceGroup"       = "${azurerm_resource_group.icp.name}"
          "useManagedIdentityExtension" = "true"
      }

      "cloud_provider_controller_conf" = {
          "cloud"               = "AzurePublicCloud"
          "useInstanceMetadata" = "true"
          "tenantId"            = "${data.azurerm_client_config.client_config.tenant_id}"
          "subscriptionId"      = "${data.azurerm_client_config.client_config.subscription_id}"
          "resourceGroup"       = "${azurerm_resource_group.icp.name}"
          "aadClientId"         = "${var.aadClientId}"
          "aadClientSecret"     = "${var.aadClientSecret}"
          "location"            = "${azurerm_resource_group.icp.location}"
          "subnetName"          = "${azurerm_subnet.container_subnet.name}"
          "vnetName"            = "${azurerm_virtual_network.icp_vnet.name}"
          "vnetResourceGroup"   = "${azurerm_resource_group.icp.name}"
          "routeTableName"      = "${azurerm_route_table.routetb.name}"
          "cloudProviderBackoff"        = "false"
          "loadBalancerSku"             = "Standard"
          # "primaryAvailabilitySetName"  = "${basename(element(azurerm_virtual_machine.worker.*.availability_set_id, 0))}"# "workers_availabilityset"
          "securityGroupName"           = "${azurerm_network_security_group.worker_sg.name}"# "hktest-worker-sg"
          "excludeMasterFromStandardLB" = "true"
          "useManagedIdentityExtension" = "false"
      }
    }

    # # We'll insert a dummy value here to create an implicit dependency on VMs in Terraform
    "dummy_waitfor" = "${length(concat(azurerm_virtual_machine.boot.*.id, azurerm_virtual_machine.master.*.id, azurerm_virtual_machine.worker.*.id, azurerm_virtual_machine.management.*.id))}"
  }

  generate_key = true

  ssh_user         = "${var.admin_username}"
  ssh_key_base64   = "${base64encode(tls_private_key.installkey.private_key_pem)}"

    # Make sure to wait for image load to complete
    hooks = {
      "boot-preconfig" = [
        "while [ ! -f /opt/ibm/.imageload_complete ]; do sleep 5; done"
      ]
    }

}
