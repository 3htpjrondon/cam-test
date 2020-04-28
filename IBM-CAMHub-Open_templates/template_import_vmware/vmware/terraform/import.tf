############### Optinal settings in provider ##########
provider "vsphere" {
    allow_unverified_ssl = "true"
}

#########################################################
##### Resource : vm_1
#########################################################
variable "name" {
  type = "string"
}

variable "folder" {
  description = "Folder location of the VM"
}

variable "num_cpus" {
  description = "Number of virtual CPU for the virtual machine, which is required to be a positive Integer"
}

variable "cpu_reservation" {
  description = "Amount of reserved CPU"
}

variable "memory" {
  description = "Memory assigned to the virtual machine in megabytes. This value is required to be an increment of 1024"
}

variable "scsi_type" {
  description = "SCSI interface type"
}

variable "guest_id" {
  description = "Guest operating system ID"
}

variable "resource_pool_id" {
  description = "Target vSphere Resource Pool to host the virtual machine"
}

variable "network_interface_0_network_id" {
  description = "vSphere port group or network label for virtual machine's vNIC"
}

variable "network_interface_0_adapter_type" {
  description = "Network adapter type for vNIC Configuration"
}

variable "disk_0_unit_number" {
  description = ""
}

variable "disk_0_path" {
  description = ""
}

variable "disk_0_label" {
  description = ""
}

variable "disk_0_size" {
  description = ""
}

variable "disk_0_datastore_id" {
  description = ""
}

variable "datastore_id" {
  description = "ID of datastore to place VM."
}

# vsphere vm
resource "vsphere_virtual_machine" "vm_1" {
  name             = "${var.name}"
  folder           = "${var.folder}"
  num_cpus         = "${var.num_cpus}"
  cpu_reservation  = "${var.cpu_reservation}"
  memory           = "${var.memory}"
  resource_pool_id = "${var.resource_pool_id}"
  guest_id         = "${var.guest_id}"
  scsi_type        = "${var.scsi_type}"
  datastore_id     = "${var.datastore_id}"

  network_interface {
    network_id   = "${var.network_interface_0_network_id}"
    adapter_type = "${var.network_interface_0_adapter_type}"
  }

  disk {
    unit_number = "${var.disk_0_unit_number}"
    path = "${var.disk_0_path}"
    label = "${var.disk_0_label}"
    size = "${var.disk_0_size}"
    datastore_id = "${var.disk_0_datastore_id}"
  }
}
