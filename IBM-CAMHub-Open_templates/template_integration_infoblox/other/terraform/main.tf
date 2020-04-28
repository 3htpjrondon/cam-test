# =================================================================
# Copyright 2018 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#	you may not use this file except in compliance with the License.
#	You may obtain a copy of the License at
#
#	  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#	WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

resource "camc_scriptpackage" "GetIP" {
  program = ["/bin/bash", "${path.module}/scripts/get_ip.sh", "-i", "${var.infoblox_ip_address}", "-u", "${var.infoblox_user}", "-n", "${var.network}", "-h", "${var.hostname}", "-d", "${var.domain}", "-s", "${var.configure_for_dns}"]
  program_sensitive = ["-p", "${var.infoblox_user_password}"]
  on_create = true
}

resource "camc_scriptpackage" "ReturnIP" {
  depends_on = ["camc_scriptpackage.GetIP"]
  program = ["/bin/bash", "${path.module}/scripts/return_ip.sh", "-i", "${var.infoblox_ip_address}", "-u", "${var.infoblox_user}", "-h", "${lookup(camc_scriptpackage.GetIP.result, var.assigned_ip_address)}"]
  program_sensitive = ["-p", "${var.infoblox_user_password}"]
  on_delete = true
}
