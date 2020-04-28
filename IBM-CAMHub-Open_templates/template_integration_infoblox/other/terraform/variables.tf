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

##############################################################
# Infoblox script variables
##############################################################

variable "infoblox_ip_address" { type = "string" description = "The IP address of the Infoblox server" }
variable "infoblox_user" { type = "string" description = "The user name to access the Infoblox server" }
variable "infoblox_user_password" { type = "string" description = "The user password to access the Infoblox server" }
variable "network" { type = "string" description = "The network from which to get an IP address" }
variable "hostname" { type = "string" description = "The hostname to associate with the IP address" }
variable "domain" { type = "string" description = "The domain to associate with the IP address" }
variable "configure_for_dns" { type = "string" description = "Indicates that DNS should be updated when the host record is updated." }

##############################################################
# Result variables. Terraform requires variables rather
# than Strings when using its lookup function
##############################################################

variable "assigned_ip_address" { type = "string" description = "The IP address assigned from Infoblox IPAM" default = "ipaddress" }
variable "associated_hostname" { type = "string" description = "The hostname associated with the assigned IP address" default = "hostname" }
variable "associated_domain" { type = "string" description = "The domain associated with the assigned IP address" default = "domain" }
