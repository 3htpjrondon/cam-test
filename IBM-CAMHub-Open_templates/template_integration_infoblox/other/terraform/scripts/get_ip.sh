#!/bin/bash
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

# set -x

# Get script parameters
while test $# -gt 0; do
  [[ $1 =~ ^-u|--user ]] && { PARAM_USER="${2}"; shift 2; continue; };
  [[ $1 =~ ^-p|--password ]] && { PARAM_PASSWORD="${2}"; shift 2; continue; };
  [[ $1 =~ ^-i|--ipamip ]] && { PARAM_IPAMIP="${2}"; shift 2; continue; };
  [[ $1 =~ ^-h|--hostname ]] && { PARAM_HOSTNAME="${2}"; shift 2; continue; };
  [[ $1 =~ ^-d|--domain ]] && { PARAM_DOMAIN="${2}"; shift 2; continue; };
  [[ $1 =~ ^-n|--network ]] && { PARAM_NETWORK="${2}"; shift 2; continue; };
  [[ $1 =~ ^-s|--dns ]] && { PARAM_DNS="${2}"; shift 2; continue; };
  break;
done

json_network="{\"network\":\"${PARAM_NETWORK}\""
json_hostname="{\"name\":\"${PARAM_HOSTNAME}.${PARAM_DOMAIN}\""
#echo $json_network
#echo $json_hostname

json="${json_hostname},\"configure_for_dns\":${PARAM_DNS},\"ipv4addrs\":[{\"ipv4addr\":{\"_object_function\":\"next_available_ip\",\"_result_field\":\"ips\",\"_object\""
json2=" : \"network\",\"_object_parameters\":${json_network}}}}]}"


full_json=${json}${json2}
#echo $full_json

curerespo=`curl -k \
                 -u ${PARAM_USER}:${PARAM_PASSWORD}  \
                 -H 'content-type: application/json' \
                 -X POST "https://${PARAM_IPAMIP}/wapi/v2.6.1/record:host?_return_fields%2B=name,ipv4addrs&_return_as_object=1" \
                 -d "${full_json}" 2>/dev/null`


address=`echo $curerespo | jq -r '.result .ipv4addrs[0].ipv4addr'`
host=`echo $curerespo | jq -r '.result .ipv4addrs[0].host'`
short_host=`echo $host |  cut -d'.' -f 1`
domain=`echo $host |  cut -d'.' -f 2-`

if [ $address == "null" ]; then
  error=`echo $curerespo | jq -r '.text'`
  if [ "$error" == "null" ]; then
    error=$curerespo
  fi
  echo "The request to retrieve an IP address from Infoblox failed. Error message: $error" >&2
  exit 1
fi

#echo $address
#echo $host
#echo $short_host
#echo $domain

return_result="{\"ipaddress\": \"${address}\", \"hostname\": \"${short_host}\",\"domain\": \"${domain}\"}"

echo $return_result
