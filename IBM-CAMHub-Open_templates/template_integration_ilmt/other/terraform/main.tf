# =================================================================
# Copyright 2018 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#       you may not use this file except in compliance with the License.
#       You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#       WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

variable "ip_address" {
  "description" = "IP Address of the HOST to install the BigFix Agent."
}
variable "user" {
  "description" = "Userid to install the BigFix Agent, root reccomended."
}
variable "password" {
  "description" = "Password of the installation user"
}
variable "private_key" {
  "description" = "Private key of the installation user. This value should be base64 encoded."
}
variable "sw_repo_url" {
  "description" = "Source for the BigFix Agent installer, eg https://IP_ADDRESS:9999/bigfix"
}
variable "bigfix_package" {
  "description" = "Name of the BigFix Agent package"
}
variable "actionsite" {
  "description" = "Name of the actionsite file"
}

resource "camc_scriptpackage" "InstallBESAgent" {
  program = ["/usr/bin/sudo", "/bin/bash", "/tmp/installBESAgent.sh", "${var.sw_repo_url}", "${var.bigfix_package}", "${var.actionsite}"]
  remote_host = "${var.ip_address}"
  remote_user = "${var.user}"
  remote_password = "${var.password}"
  remote_key = "${var.private_key}"
  source = "${path.module}/scripts/installBESAgent.sh"
  destination = "/tmp/installBESAgent.sh"
  on_create = true
}

