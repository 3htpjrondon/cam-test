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

output "assigned_ip_address" {
  description = "The IP address assigned from Infoblox IPAM"
  value = "${lookup(camc_scriptpackage.GetIP.result, var.assigned_ip_address)}"
}

output "associated_hostname" {
  description = "The hostname associated with the assigned IP address"
  value = "${lookup(camc_scriptpackage.GetIP.result, var.associated_hostname)}"
}

output "associated_domain" {
  description = "The domain associated with the assigned IP address"
  value = "${lookup(camc_scriptpackage.GetIP.result, var.associated_domain)}"
}
