#!/bin/bash
# =================================================================
# Copyright 2018 IBM Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# =================================================================

# installBESAgent - A script to install the BigFix Client
# input parameters:
# $1 URL to the bifgix installation sources on the Content Runtime
# $2 name of the BigFix Client installation file (e.g. BESAgent-9.5.9.62-ubuntu10.amd64.deb)
# $3 name of the actionsite file (actionsite.afxm)


echo "*********** Downloading the sources from " $1
curl -O $1/$2
curl -O $1/$3

#Variables
CLIENTDIR=/etc/opt/BESClient

echo "*********** Creating directory " $CLIENTDIR
[[ -d "$CLIENTDIR" ]] || mkdir $CLIENTDIR

echo "*********** Installing BESClient"
dpkg -i ./$2

echo "*********** Moving " $3 " to " $CLIENTDIR
mv ./$3 $CLIENTDIR

echo "*********** Starting BESClient"
/etc/init.d/besclient start
