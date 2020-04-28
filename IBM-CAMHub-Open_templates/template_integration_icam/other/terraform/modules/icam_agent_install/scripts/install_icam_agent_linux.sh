#!/bin/bash
# =================================================================
# Copyright 2017 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

# Check if a command exists
command_exists() {
  type "$1" &> /dev/null;
}

IPMGetValue() {
    [ ! -f "${2}" ] && return 1
    _properties_entry=$(grep "${1}" "${2}" 2>/dev/null | cut -f2 -d= | sed s'/^ //' | sed s'/ $//')
    # Did not find the entry so return with error code.
    [ -z "${_properties_entry}" ] && return 1
    echo "${_properties_entry}"

    return 0
}

GetAgentProductCode() {
    _agent_properties="${TEMP_DIR}/${SOURCE_SUBDIR}"/.apm/inst/${1}-agent/agent.properties
    _product_code=$(IPMGetValue "^SMAI_PC" "${_agent_properties}") || return 1
    _ipmo_agents=$(echo "${_product_code}" | tr '[:upper:]' '[:lower:]')
    echo "${_ipmo_agents}"

    return 0
}


TEMP_DIR=/tmp

# Check Parameters

if [ "$#" -lt 4 ]; then
    echo "Usage: $0 icam_agent_location icam_agent_location_credentials icam_agent_source_subdir icam_agent_installation_dir icam_agent_name" >&2
    exit 1
fi

# Assign Parameters
for i in "$@"
do
case $i in
    --icam_agent_location=*)
    SOURCE="${i#*=}"
    shift # past argument=value
    ;;
    --icam_agent_location_credentials=*)
    SOURCE_CREDENTIALS="${i#*=}"
    shift # past argument=value
    ;;
    --icam_agent_source_subdir=*)
    SOURCE_SUBDIR="${i#*=}"
    shift # past argument=value
    ;;
    --icam_agent_installation_dir=*)
    INSTALL_DIR="${i#*=}"
    shift # past argument=value
    ;;
    --icam_agent_name=*)
    AGENT_NAME="${i#*=}"
    shift # past argument with no value
    ;;
    *)
    # unknown option
    ;;
esac
done


INSTALLER=${SOURCE##*/}

AGENTS="$@"

# Download APM Installer

cd $TEMP_DIR
if [[ -z "$SOURCE_CREDENTIALS" ]]; then
    curl -O $SOURCE
else
    curl -u$SOURCE_CREDENTIALS -O $SOURCE
fi

tar xvf $INSTALLER

# Modify Silent Install File

cd $SOURCE_SUBDIR
cp APM_MGMT_silent_install.txt APM_MGMT_silent_install.txt.tmp

echo "" >> APM_MGMT_silent_install.txt.tmp
echo "License_Agreement=\"I agree to use the software only in accordance with the installed license.\"" >> APM_MGMT_silent_install.txt.tmp
echo "AGENT_HOME=$INSTALL_DIR" >> APM_MGMT_silent_install.txt.tmp
echo "INSTALL_AGENT=$AGENT_NAME" >> APM_MGMT_silent_install.txt.tmp


# Install Pre-requisites

# Identify the platform and version using Python
if command_exists python; then
  PLATFORM=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
  PLATFORM_VERSION=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
else
  if command_exists python3; then
    PLATFORM=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
    PLATFORM_VERSION=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
  fi
fi
# Check if the executing platform is supported
if [[ $PLATFORM == *"ubuntu"* ]] || [[ $PLATFORM == *"redhat"* ]] || [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
  echo "[*] Platform identified as: $PLATFORM $PLATFORM_VERSION"
else
  echo "[ERROR] Platform $PLATFORM not supported"
  exit 1
fi
# Change the string 'redhat' to 'rhel'
if [[ $PLATFORM == *"redhat"* ]]; then
  PLATFORM="rhel"
fi

if [[ $PLATFORM == *"ubuntu"* ]]; then
  PACKAGE_MANAGER=apt-get
  until sudo apt-get update; do
    echo "Sleeping 2 sec while waiting for apt-get update to finish ..."
    sleep 2
  done
else
  PACKAGE_MANAGER=yum
  if { sudo -n yum -y update 2>&1 || echo E: update failed; } | grep -q '^[W]:'; then
    echo "[ERROR] There was an error obtaining the latest packages"
  fi
fi

PACKAGES="bc"

for PACKAGE in $PACKAGES
do
  echo "Installing $PACKAGE"
  until sudo $PACKAGE_MANAGER install -y $PACKAGE; do
    echo "Sleeping 2 sec while waiting for $PACKAGE_MANAGER install to finish ..."
    sleep 2
  done   
done

# Install Agent
export IGNORE_PRECHECK_WARNING=1
./installAPMAgents.sh -p  APM_MGMT_silent_install.txt.tmp

#Check for successful installation
AGENT_CODE=$(GetAgentProductCode ${AGENT_NAME})
AGENT_INSTALLED=`$INSTALL_DIR/bin/cinfo -d | grep \"${AGENT_CODE}\"  | wc -l` 
if [ "$AGENT_INSTALLED" = "0" ]; then
  exit 1
fi

# Cleanup
rm $TEMP_DIR/$INSTALLER
rm -Rf $TEMP_DIR/$SOURCE_SUBDIR

