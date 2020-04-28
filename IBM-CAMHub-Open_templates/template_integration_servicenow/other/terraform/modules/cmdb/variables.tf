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
# COMMAND VARIABLES
##############################################################

variable "cmdb_user" { type = "string" description = "ServiceNow User." default = "admin" }
variable "cmdb_pass" { type = "string" description = "ServiceNow Password"}
variable "cmdb_instance" { type = "string" description = "ServiceNow Instance Location" }
variable "cmdb_key" { type = "string" description = "CMDB Unique Record Key, maps to the name field" default = "server1"}
variable "cmdb_record" { type = "map" description = "CMDB MAP Record" }
