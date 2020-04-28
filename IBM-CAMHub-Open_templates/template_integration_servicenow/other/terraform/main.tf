module "cmdb" {
  source = "./modules/cmdb"

  cmdb_user = "${var.cmdb_user}"
  cmdb_pass = "${var.cmdb_pass}"
  cmdb_instance = "${var.cmdb_instance}"
  cmdb_key = "${var.cmdb_key}"
  cmdb_record = "${var.cmdb_record}"

}
