#!/bin/bash

################################################################
# Module to deploy IBM Cloud Private
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Licensed Materials - Property of IBM
#
# Copyright IBM Corp. 2017.
#
################################################################

# HTTP-accessible location of the IBM Cloud Private image to download
ICP_IMAGE_HTTP_LOCATION="http://<HOSTNAME>/<PATH_TO_ICP_TAR_BALL>"
# The IBM Cloud Private embedded Docker image
# (ibmcom/icp-inception for x86 or ibmcom/icp-inception-ppc64le for Power)
ICP_DOCKER_IMAGE="ibmcom/icp-inception-ppc64le"
# Version of IBM Cloud Private to install
ICP_VER="2.1.0"
# Root directory of ICP installation
ICP_ROOT_DIR="/opt/ibm-cloud-private-ee"

# Disable the firewall
/usr/sbin/ufw disable
# Enable NTP
/usr/bin/timedatectl set-ntp on
# Need to set vm.max_map_count to at least 262144
/sbin/sysctl -w vm.max_map_count=262144
/bin/echo "vm.max_map_count=262144" | /usr/bin/tee -a /etc/sysctl.conf
# Prepare the system for updates, install Docker and install Python
/usr/bin/apt update
/usr/bin/apt-get --assume-yes install docker.io
/usr/bin/apt-get --assume-yes install python
/usr/bin/apt-get --assume-yes install python-pip
/usr/bin/apt-get --assume-yes install wget
/bin/systemctl start docker

# Ensure the hostnames are resolvable
IP=`/sbin/ifconfig eth0 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}'`
/bin/echo "${IP} $(hostname)" >> /etc/hosts

# Download and configure IBM Cloud Private
TMP_DIR="$(/bin/mktemp -d)"
cd "${TMP_DIR}"
/usr/bin/wget -q "${ICP_IMAGE_HTTP_LOCATION}"
/bin/tar xf *.tar.gz -O | /usr/bin/docker load

/bin/mkdir "${ICP_ROOT_DIR}-${ICP_VER}"
cd "${ICP_ROOT_DIR}-${ICP_VER}"
/usr/bin/docker run -e LICENSE=accept -v \
    "$(pwd)":/data ${ICP_DOCKER_IMAGE}:${ICP_VER}-ee cp -r cluster /data
/bin/mkdir -p cluster/images
/bin/mv ${TMP_DIR}/*.tar.gz ${ICP_ROOT_DIR}-${ICP_VER}/cluster/images/
/bin/rm -rf "${TMP_DIR}"

# Configure the master and proxy as the same node
/bin/echo "[master]"  > cluster/hosts
/bin/echo "${IP}"    >> cluster/hosts
/bin/echo "[proxy]"  >> cluster/hosts
/bin/echo "${IP}"    >> cluster/hosts
# Configure the worker node(s)
for worker_ip in $( cat /root/icp_worker_nodes.txt | sed 's/|/\n/g' ); do
    /bin/echo "[worker]"     >> cluster/hosts
    /bin/echo "${worker_ip}" >> cluster/hosts
done

# Setup the private key for the ICP cluster (injected at deploy time)
/bin/cp /root/id_rsa.terraform \
    ${ICP_ROOT_DIR}-${ICP_VER}/cluster/ssh_key
/bin/chmod 400 ${ICP_ROOT_DIR}-${ICP_VER}/cluster/ssh_key

# Deploy IBM Cloud Private
cd "${ICP_ROOT_DIR}-${ICP_VER}/cluster"
/usr/bin/docker run -e LICENSE=accept --net=host -t -v \
    "$(pwd)":/installer/cluster ${ICP_DOCKER_IMAGE}:${ICP_VER}-ee install | \
    /usr/bin/tee install.log

exit 0
