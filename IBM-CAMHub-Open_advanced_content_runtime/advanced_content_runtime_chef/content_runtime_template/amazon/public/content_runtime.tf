# Licensed Materials - Property of IBM
# 5737-E67
# @ Copyright IBM Corporation 2016, 2017 All Rights Reserved
# US Government Users Restricted Rights - Use, duplication or disclosure restricted by GSA ADP Schedule Contract with IBM Corp.

### Input Section

variable "ibm_stack_name" {
	type = "string"
	default = "unknown"
}

variable "docker_registry_token" {
  type = "string"
}

variable "docker_registry" {
  type = "string"
}

variable "docker_registry_camc_pattern_manager_version" {
  type = "string"
}

variable "docker_registry_camc_sw_repo_version" {
  type = "string"
}

variable "ibm_sw_repo_user" {
  type = "string"
}

variable "ibm_sw_repo_password" {
  type = "string"
}

variable "ibm_sw_repo_port" {
  type = "string"
}

variable "ibm_sw_repo_secure_port" {
  type = "string"
}

variable "chef_client_version" {
  type = "string"
}

variable "chef_client_path" {
  type = "string"
}

variable "ibm_im_repo_user_hidden" {
  type = "string"
}

variable "ibm_im_repo_password_hidden" {
  type = "string"
}

variable "ibm_contenthub_git_host" {
  type = "string"
}

variable "ibm_contenthub_git_organization" {
  type = "string"
}

variable "ibm_openhub_git_organization" {
  type = "string"
}

variable "offline_installation" {
  type = "string"
}

variable "docker_ee_repo" {
  type = "string"
}

variable "chef_org" {
  type = "string"
}

variable "chef_admin" {
  type = "string"
}

variable "byochef" {
  type = "string"
}

variable "install_cookbooks" {
  type = "string"
}

variable "chef_fqdn" {
  type = "string"
}

variable "chef_ip" {
  type = "string"
}

variable "chef_pem" {
  type = "string"
}

variable "ibm_pm_access_token" {
  type = "string"
}

variable "ibm_pm_admin_token" {
  type = "string"
}

variable "ibm_pm_public_ssh_key_name" {
  type = "string"
}

variable "ibm_pm_private_ssh_key" {
  type = "string"
}

variable "ibm_pm_public_ssh_key" {
  type = "string"
}

variable "user_public_ssh_key" {
  type = "string"
}

variable "template_timestamp_hidden" {
  type = "string"
}

variable "template_debug" {
  type = "string"
}

variable "aws_userid" {
  type = "string"
}

variable "nfs_mount" {
  type = "string"
}

variable "portable_private_ip" {
  type = "string"
}

variable "runtime_hostname" {
  type = "string"
}

variable "encryption_passphrase" {
  type = "string"
}

variable "ipv4_address" {
  type = "string"
}

variable "aws_security_group" {
  type = "string"
}

variable "aws_subnet" {
  type = "string"
}

variable "aws_instance_type" {
  type = "string"
}

variable "aws_ami_id" {
  type = "string"
  default = ""
}

variable "aws_region" {
  type = "string"
}

variable "network_visibility" {
  type = "string"
}

variable "prereq_strictness" {
  type = "string"
}

variable "installer_docker" {
  type = "string"
}

variable "installer_docker_compose" {
  type = "string"
}

variable "sw_repo_image" {
  type = "string"
}

variable "pm_image" {
  type = "string"
}

variable "chef_version" {
  type = "string"
}

variable "bastion_host" {
  type = "string"
}

variable "bastion_user" {
  type = "string"
}

variable "bastion_private_key" {
  type = "string"
}

variable "bastion_port" {
  type = "string"
}

variable "bastion_host_key" {
  type = "string"
}

variable "bastion_password" {
  type = "string"
}

### End Input Section

provider "tls" {
  version = "~> 1.0"
}

provider "null" {
  version = "~> 1.0"
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
}

resource "aws_key_pair" "internal_public_key" {
  public_key = "${tls_private_key.ssh.public_key_openssh}"
}

data "aws_ami" "ubuntu_1604" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

provider "aws" {
  version = "~> 1.2"
  region  = "${var.aws_region}"
}

resource "aws_instance" "singlenode" {
  ami                         = "${ length(var.aws_ami_id) > 0 ? var.aws_ami_id : data.aws_ami.ubuntu_1604.id}"
  instance_type               = "${var.aws_instance_type}"
  key_name                    = "${aws_key_pair.internal_public_key.id}"
  vpc_security_group_ids      = ["${var.aws_security_group}"]
  subnet_id                   = "${var.aws_subnet}"
  private_ip                  = "${var.portable_private_ip}"
  associate_public_ip_address = "${var.network_visibility == "public" ? "true" : "false"}"

  tags {
    Name = "${var.runtime_hostname}"
  }

  # Root disk of 25GB
  root_block_device {
    volume_size = 25
  }

  # Mounted disk of 100GB
  ebs_block_device {
    volume_size = 100
    device_name = "/dev/xvdc"
  }

  # see if this is the location for running the remote command
  connection {
    type                = "ssh"
    user                = "${var.aws_userid}"
    private_key         = "${tls_private_key.ssh.private_key_pem}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ./advanced-content-runtime",
    ]
  }

  provisioner "file" {
    content = <<EndOfFile
#!/bin/bash
#
# Copyright : IBM Corporation 2016, 2017
#
######################################################################################
# Script to check the requirements necessary for an installation
# # Usage: ./prereq-check-install.sh -m MODE(strict/lenient) -c CHEF_VERSION_OR_URL -u PM_PUBLIC_KEY -r PM_PRIVATE_KEY -e DOCKER_EE_REPO -o DOCKER_COMPOSE_FILE -d DOCKE_FILE -b BYOCHEF
######################################################################################
RESULT=0

. `dirname $0`/utilities.sh

# Declare the default chef and docker compose versions for their installations
CHEF_VERSION=12.17.33
CHEF_CLIENT_VERSION=14.0.190
# CHEF_VERSION=12.11.1
# CHEF_CLIENT_VERSION=12.17.44
DOCKER_COMPOSE_VERSION=1.17.1

[[ `dirname $0 | cut -c1` == '/' ]] && runtimepath=`dirname $0/` || runtimepath=`pwd`/`dirname $0`

function wait_apt_lock()
{
    sleepC=5
    while [[ -f /var/lib/dpkg/lock  || -f /var/lib/apt/lists/lock ]]
    do
      sleep $sleepC
      echo "    Checking lock file /var/lib/dpkg/lock or /var/lib/apt/lists/lock"
      [[ `sudo lsof 2>/dev/null | egrep 'var.lib.dpkg.lock|var.lib.apt.lists.lock'` ]] || break
      let 'sleepC++'
      if [ "$sleepC" -gt "50" ] ; then
 	lockfile=`sudo lsof 2>/dev/null | egrep 'var.lib.dpkg.lock|var.lib.apt.lists.lock'|rev|cut -f1 -d' '|rev`
        echo "Lock $lockfile still exists, waited long enough, attempt apt-get. If failure occurs, you will need to cleanup $lockfile"
        continue
      fi
    done
}

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

# If executing from unsupported distro versions
MAIN_VERSION=`echo $PLATFORM_VERSION | cut -d '.' -f1`
if ([[ $PLATFORM == *"ubuntu"* ]] && [[ $MAIN_VERSION -lt "14" ]]) || [[ $MAIN_VERSION -lt "7" ]]; then
  echo "[ERROR] This OS version ($PLATFORM_VERSION) is not supported"
  exit 1
fi

echo "[*] Checking permissions"
sudo -n cat /etc/sudoers > /dev/null
if [ $? -ne "0" ]; then
  echo "[ERROR] This script requires root permissions with the NOPASSWD option enabled for executing"
  exit 1
fi

# Get script parameters
while test $# -gt 0 ; do
  [[ $1 =~ ^-m|--mode ]] && { PARAM_MODE="$2"; shift 2; continue; };
  [[ $1 =~ ^-c|--chef ]] && { PARAM_CHEF="$2"; shift 2; continue; };
  [[ $1 =~ ^-s|--client ]] && { PARAM_CLIENT="$2"; shift 2; continue; };
  [[ $1 =~ ^-p|--path ]] && { PARAM_CLIENT_PATH="$2"; shift 2; continue; };
  [[ $1 =~ ^-u|--public ]] && { PARAM_PUBLIC_KEY="$2"; shift 2; continue; };
  [[ $1 =~ ^-r|--private ]] && { PARAM_PRIVATE_KEY="$2"; shift 2; continue; };
  [[ $1 =~ ^-e|--dockeree ]] && { PARAM_DOCKEREE="$2"; shift 2; continue; };
  [[ $1 =~ ^-o|--compose ]] && { PARAM_DOCKER_COMPOSE="$2"; shift 2; continue; };
  [[ $1 =~ ^-d|--docker ]] && { PARAM_DOCKER="$2"; shift 2; continue; };
  [[ $1 =~ ^-b|--byochef ]] && { PARAM_BYOCHEF="$2"; shift 2; continue; };
  [[ $1 =~ ^-f|--offline ]] && { PARAM_OFFLINE="$2"; shift 2; continue; };

  break;
done

# Check for the cloud provider
CLOUD_PROVIDER=$(sudo dmidecode -s bios-version)

if [[ "$PARAM_OFFLINE" == "true" ]]; then
  echo "[*] Starting offline installation"
else
  echo "[*] Updating packages"
  # Check if the script is being run as root
  if [[ $PLATFORM == *"ubuntu"* ]]; then
    wait_apt_lock
    PACKAGE_MANAGER=apt-get
    if { sudo -n apt-get -qqy update 2>&1 || echo E: update failed; } | grep -q '^[W]:'; then
      echo "[ERROR] There was an error obtaining the latest packages"
    fi
  else
    PACKAGE_MANAGER=yum
    if { sudo -n yum -y update 2>&1 || echo E: update failed; } | grep -q '^[W]:'; then
      echo "[ERROR] There was an error obtaining the latest packages"
    fi
  fi
  if [ $? -ne "0" ]; then
    echo "[ERROR] This script requires $PACKAGE_MANAGER permissions for executing"
    exit 1
  fi
fi

echo "[*] Checking available space"
# Check if there is at least 1GB of disk available
FREE_MEM=`df -k --output=avail "$PWD" | tail -n1`
if [ $FREE_MEM -lt 5242880 ]; then # 1GB = 1024 * 1024
  echo "[WARNING] This script requires at least 5GB of available disk space in $PWD, errors may occur during installation"
fi

# Check if there is at least 1GB of disk on /opt
FREE_MEM=`df -k --output=avail "/opt" | tail -n1`
if [ $FREE_MEM -lt 2097152 ]; then
  echo "[WARNING] This script requires at least 2GB of available disk space in /opt for Chef Server, errors may occur during installation"
fi

# Check if strict mode is enabled, if it is, the program will not attempt to install requirements
MODE="lenient"
if [[ $PARAM_MODE == *"strict"* ]]; then
  MODE="strict"
  echo "[*] Strict mode enabled"
fi

if [[ "$PARAM_BYOCHEF" == "true" ]]; then
  echo "[*] Using external Chef server"
fi

MASK=$(umask)
if [[ $MASK != *"022"* ]] && [[ $MASK != *"002"* ]]; then
  echo "[ERROR] There is an error with the default permissions (umask) for new users and folders. The recommended value is 022 or 002, found $MASK"
  exit 1
fi

# Get chef's URL from parameter
URL_REGEX='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
if [ -z "$PARAM_CHEF" ]; then
  PARAM_CHEF=$CHEF_VERSION
fi

if [[ $PARAM_CHEF =~ $URL_REGEX ]]; then
  echo "[*] Chef URL was provided: $PARAM_CHEF"
  CHEF_URL=$PARAM_CHEF
else
  CHEF_VERSION=$PARAM_CHEF
  if [[ $PLATFORM == *"ubuntu"* ]]; then
  		CHEF_URL=https://packages.chef.io/files/stable/chef-server/$CHEF_VERSION/ubuntu/$PLATFORM_VERSION/chef-server-core_$CHEF_VERSION-1_amd64.deb
  else
    if [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
      CHEF_URL=https://packages.chef.io/files/stable/chef-server/$CHEF_VERSION/el/$MAIN_VERSION/chef-server-core-$CHEF_VERSION-1.el$MAIN_VERSION.x86_64.rpm
    fi
  fi
  echo "[*] Using Chef installation URL: $CHEF_URL"
fi

# Get chef client URL from parameter
if [ ! -z "$PARAM_CLIENT" ]; then
  CHEF_CLIENT_VERSION=$PARAM_CLIENT
fi

if [ ! -e `dirname $0`/.advanced-runtime-config/sshkeyverified ] ; then
  # Verify the provided private and public keys match
  PM_PUBLIC_KEY=`echo $PARAM_PUBLIC_KEY | head -n1 | cut -d " " -f2`

  echo $PARAM_PRIVATE_KEY | base64 --decode > key.decoded
  chmod 600 key.decoded
  ssh-keygen -p -P '' -N '' -f key.decoded > /dev/null

  if [ $? -gt 0 ]; then
    echo "[ERROR] The provided encoded private key contains a password. Pattern Manager requires the use of a passwordless private key."
    exit 1
  fi

  PM_PRIVATE_KEY=`ssh-keygen -y -f key.decoded | head -n1 | cut -d " " -f2`
  if [[ $PM_PUBLIC_KEY == $PM_PRIVATE_KEY ]]; then
    echo "[*] The provided SSH keys for Pattern Manager were validated successfully."
  else
    echo "[ERROR] The provided SSH public and private keys for Pattern Manager do not match, please provide a matching pair of keys."
    exit 1
  fi
  rm -rf key.decoded
  touch `dirname $0`/.advanced-runtime-config/sshkeyverified
fi

# Verify the machine's hostname is in lower case
h=`hostname`
H=`hostname |tr '[:upper:]' '[:lower:]'`

if [[ "$h" =~ [A-Z] ]]; then
  echo "[*] Found an uppercase letter on the hostname"
  if [[ $MODE == *"lenient"* ]]; then
    sudo sed -i "s/$h/$H/g" /etc/hosts
    sudo sed -i "s/$h/$H/g" /etc/hostname
    sudo hostname `hostname | tr '[:upper:]' '[:lower:]'`
    echo "[*] Hostname was changed from $h to $H"
  else
    echo "[ERROR] The sever's hostname can not contain uppercase letters"
    exit 1
  fi
fi

# Add hostname to the /etc/hosts file if it isn't there
if grep -q "$h" /etc/hosts; then
  echo "[*] Hostname exists in /etc/hosts"
else
  echo "[*] Adding hostname to /etc/hosts"
  sudo sed -i "1s/^/127.0.0.1 $h\n/" /etc/hosts
fi

# Get Docker EE repo URL
if ! command_exists docker; then
  if [ -z "$PARAM_DOCKEREE" ]; then
    echo "[*] No Docker EE repository provided"
    if [[ "$PLATFORM" == *"rhel"* ]] && [ -z "$PARAM_DOCKER" ]; then
      echo "[ERROR] Docker CE for Red Hat Enterprise is not supported, please provide a valid Docker EE repository URL"
      exit 1
    fi
  else
    DOCKER_EE_REPO=$PARAM_DOCKEREE
    echo "[*] Identified Docker EE repository: $PARAM_DOCKEREE"
  fi
fi

# Check for the machine's IP Address
which ip > /dev/null
if [ $? -ne "0" ]; then
  if [[ $MODE == *"strict"* ]]; then
    echo "[ERROR] Failed obtaining the machine's IP address"
    exit 1
  else
    export PATH=$PATH:/usr/sbin
  fi
fi

# Check if a command is installed, if not, install it using rpm or apt-get
# Usage: check_command_and_install commandNameToCheck packageNameUbuntu packageNameRedHat
# Or: check_command_and_install commandNameToCheck installerFunction
function check_command_and_install() {
	command=$1
  string="[*] Checking installation of: $command"
  line="......................................................................."
  if command_exists $command; then
    # TODO I remove the substring code here allow for th bash to work as bash, the format need to be redone.
    printf "%s %s [INSTALLED]\n" "$string" "$line"
  else
    printf "%s %s [MISSING]\n" "$string" "$line"
    if [[ $MODE == *"lenient"* ]]; then # If not using strict mode, install the package
      if [ $# == 3 ]; then # If the package name is provided
        if [[ $PLATFORM == *"ubuntu"* ]]; then
          sudo $PACKAGE_MANAGER install -y $2
        else
          sudo $PACKAGE_MANAGER install -y $3
        fi
      else # If a function name is provided
        eval $2
      fi
      if [ $? -ne "0" ]; then
        echo "[ERROR] Failed while installing $command"
        exit 1
      fi
    else # If strict mode is not being used, return an error code
      RESULT=1
    fi
  fi
}

# Install a deb or rpm file from a provided binary file
# install_binary NAME URL
function install_binary() {
  if [[ $2 =~ $URL_REGEX ]]; then
    echo "[*] Installing $1 from the provided binary file: $2"
    download_file $1 $2 $1
    if [[ $PLATFORM == *"ubuntu"* ]]; then
      sudo dpkg -i $1
    else
      if [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
      	sudo rpm -ivh $1
      fi
    fi
    if [ $? -ne "0" ]; then
      echo "[ERROR] There was an error installing $1 from the provided binary file"
      exit 1
    fi
  else
    echo "[ERROR] There was an error installing $1 from the provided URL: $2"
    exit 1
  fi
}

function install_chef() {
  # pull the checksum from the install download
  CHEFCHECKSUM_URL=$CHEF_URL.sha1
  check_command_and_install curl curl curl
  download_file 'Chef checksum' $CHEFCHECKSUM_URL chef-server.sha1
  CHEFCHECKSUM=`cat chef-server.sha1`
  download_file 'Chef server' $CHEF_URL chef-server
  echo "$CHEFCHECKSUM chef-server" > chef.sums
  sha1sum -c chef.sums

  if [[ $PLATFORM == *"ubuntu"* ]]; then
  		sudo dpkg -i chef-server
  else
    if [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
    		sudo rpm -ivh chef-server
    fi
  fi
  if [ $? -ne "0" ]; then
    echo "[ERROR] There was an error installing the requested chef server"
    echo "[ERROR] The provided URL was $CHEF_URL"
    exit 1
  fi
}

# Download Chef client installation binaries to a well-known location. These binaries will be user by the Software Repository
function download_chef_client() {
  echo "[*] Downloading Chef Cients version: $CHEF_CLIENT_VERSION"
  CLIENTS_FOLDER="$runtimepath/chef-clients"
  mkdir -p $CLIENTS_FOLDER
  if [[ "$PARAM_OFFLINE" == "true" ]]; then
    if [[ -z "$PARAM_CLIENT_PATH" ]]; then
      echo "[ERROR] A path for the Chef client installers wasn't provided"
      exit 1
    else
      cp $PARAM_CLIENT_PATH/*.* $CLIENTS_FOLDER/
    fi
  else
    download_file "Chef client for Ubuntu 16.04" "https://packages.chef.io/files/stable/chef/$CHEF_CLIENT_VERSION/ubuntu/16.04/chef_$CHEF_CLIENT_VERSION-1_amd64.deb" "chef_$CHEF_CLIENT_VERSION-1_amd64.deb"
    download_file "Chef client for RHEL 6" "https://packages.chef.io/files/stable/chef/$CHEF_CLIENT_VERSION/el/6/chef-$CHEF_CLIENT_VERSION-1.el6.x86_64.rpm" "chef-$CHEF_CLIENT_VERSION-1.el6.x86_64.rpm"
    download_file "Chef client for RHEL 7" "https://packages.chef.io/files/stable/chef/$CHEF_CLIENT_VERSION/el/7/chef-$CHEF_CLIENT_VERSION-1.el7.x86_64.rpm" "chef-$CHEF_CLIENT_VERSION-1.el7.x86_64.rpm"
    download_file "Chef vault gem" "https://rubygems.org/downloads/chef-vault-2.9.0.gem" "chef-vault-2.9.0.gem"
    mv *$CHEF_CLIENT_VERSION* $CLIENTS_FOLDER/
    mv chef-vault-* $CLIENTS_FOLDER/
  fi
}

#Installs latest if overylay compat kernel otherwise 18.06
#which is the last version that supports devicemapper.
function install_edge_docker(){
	KERNEL_OVERLAY_COMPAT=$(is_kernel_overlay_compat)
	if [[ $KERNEL_OVERLAY_COMPAT == "true" ]]; then
		echo "Install latest docker ce."
    curl -fsSL https://get.docker.com/ | sudo sh
  else
  	echo "Install docker ce 18.06."
  	curl -fsSL https://get.docker.com/ | sudo VERSION=18.06 sh
	fi	
}

function install_docker() {
  # Install
  KERNEL_OVERLAY_COMPAT=$(is_kernel_overlay_compat)
  if [[ -n $PARAM_DOCKER ]]; then
    install_binary "docker" $PARAM_DOCKER
  else
    # Install Docker EE if the repo was provided
    if [[ -n $DOCKER_EE_REPO ]]; then
      if [[ $PLATFORM == *"ubuntu"* ]]; then
        wait_apt_lock
        if [[ $PLATFORM_VERSION == *"14.04"* ]]; then
          sudo apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual
        fi
        sudo apt-get -y install apt-transport-https ca-certificates software-properties-common
        curl -fsSL $DOCKER_EE_REPO/ubuntu/gpg | sudo apt-key add -
        if [[ $KERNEL_OVERLAY_COMPAT == "true" ]]; then
        	echo "Install docker ee 18.09."
        	sudo add-apt-repository "deb [arch=amd64] "$DOCKER_EE_REPO"/ubuntu $(lsb_release -cs) stable-18.09"
        else
        	echo "Install docker ee 17.03."
        	sudo add-apt-repository "deb [arch=amd64] "$DOCKER_EE_REPO"/ubuntu $(lsb_release -cs) stable-17.03"
        fi
        sudo apt-get -y update
        sudo apt-get -y install docker-ee
      else
        if [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
          # Configure the repository
          sudo sh -c 'echo "'$DOCKER_EE_REPO'/'$PLATFORM'" > /etc/yum/vars/dockerurl'
          sudo sh -c 'echo "'$MAIN_VERSION'" > /etc/yum/vars/dockerosversion'
          sudo yum install -y yum-utils device-mapper-persistent-data lvm2
          sudo yum-config-manager --add-repo $DOCKER_EE_REPO/rhel/docker-ee.repo
          if [[ $KERNEL_OVERLAY_COMPAT == "true" ]]; then
          	echo "Install docker ee 18.09."
          	sudo yum-config-manager --enable docker-ee-stable-18.09
          fi
          # Install Docker EE
          sudo yum makecache fast
          if [[ $CLOUD_PROVIDER = *"amazon"* ]]; then
            sudo yum -y install docker-ee --enablerepo=rhui-REGION-rhel-server-extras
          else
            sudo yum -y install docker-ee --enablerepo=rhel-7-server-extras-rpms
            if [ $? -ne "0" ]; then
              echo "[ERROR] There was an error enabling the rhel7-server-extras repository. Attempting installation without it."
              sudo yum -y install docker-ee
            fi
          fi
        fi
      fi
      if [ $? -ne "0" ]; then
        echo "[ERROR] There was an error installing Docker EE from the provided repository"
        echo "[ERROR] Repo: $DOCKER_EE_REPO"
        exit 1
      fi
    else # Otherwise install CE in supported platforms or install from provided binary
      if [[ $PLATFORM == *"ubuntu"* ]] || [[ $PLATFORM == *"centos"* ]]; then
          [[ $PLATFORM == *"ubuntu"* ]] && wait_apt_lock
          install_edge_docker
          if [ -z "`which docker`" ]; then # retry failed install, could be download issues
              [[ $PLATFORM == *"ubuntu"* ]] && wait_apt_lock
              install_edge_docker
          fi
      fi
      if [ $? -ne "0" ]; then
        echo "[ERROR] There was an error installing Docker CE"
        exit 1
      fi
    fi
  fi
  # Start docker as a service on reboot
  [[ `sudo systemctl is-enabled docker` = "disabled" ]] && sudo systemctl enable docker || true
}

function check_firewall {
  # Check for a firewall and allow docker through it
  if command_exists firewall-cmd; then
    sudo firewall-cmd --state > /dev/null
    if [ $? == "0" ]; then
      echo "[*] Firewall detectected, opening ports"
      sudo firewall-cmd --permanent --zone=public --change-interface=docker0
      sudo firewall-cmd --permanent --zone=public --add-port=443/tcp
      sudo firewall-cmd --reload
    fi
  fi
}

function install_docker_compose {
  if [[ -n $PARAM_DOCKER_COMPOSE ]]; then
    sudo curl -o /usr/local/bin/docker-compose -L $PARAM_DOCKER_COMPOSE
    sudo chmod +x /usr/local/bin/docker-compose
  else
   sudo curl -o /usr/local/bin/docker-compose -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m`
   if [ $? == "60" ]; then
     echo "[ERROR] There was an error validating the certificate validation when obtaining Docker Compose from the provided URL."
     exit 1
   fi
   sudo chmod +x /usr/local/bin/docker-compose
  fi
}

echo "[*] Verifying requirements"
# Easy installs
check_command_and_install python python-minimal python
check_command_and_install thin_check thin-provisioning-tools thin-provisioning-tools
check_command_and_install pvcreate lvm2 'lvm2*'

# Custom installs
if [[ "$PARAM_BYOCHEF" == "false" ]]; then
  check_command_and_install /usr/bin/chef-server-ctl install_chef
fi
check_command_and_install docker install_docker
check_command_and_install docker-compose install_docker_compose
download_chef_client

# Additional fixes
check_firewall

if [ $RESULT -eq 1 ]; then
  echo "Please ensure the installation of all requirements and execute this script again"
  exit 1
fi
EndOfFile

    destination = "./advanced-content-runtime/prereq-check-install.sh"
  }

  provisioner "file" {
    content = <<EndOfFile
#!/bin/bash
#
# Copyright : IBM Corporation 2016, 2017
#
######################################################################################
# Script to verify the installation and configuration of the content runtime
# Usage: ./verify-installation
######################################################################################

CURRENT_DIR=`dirname $0 | cut -c1`
[[ $CURRENT_DIR == '/' ]] && CONFIG_PATH=`dirname $0` || CONFIG_PATH=`pwd`/`dirname $0`

PARAM_FILE="$CONFIG_PATH/.advanced-runtime-config/.launch-docker-compose.sh"
LOG_FILE="$CONFIG_PATH/.advanced-runtime-config/verification.log"
CHEF_FILE="$CONFIG_PATH/.advanced-runtime-config/chef-install.log"
DOCKER_LOG="$CONFIG_PATH/.advanced-runtime-config/docker_ps.log"

mkdir -p "$CONFIG_PATH/.advanced-runtime-config"

. $CONFIG_PATH/utilities.sh

log_firewall() {
  if command_exists firewall-cmd; then
    echo "[*] Firewall information:"
    sudo firewall-cmd --state | tee -a $LOG_FILE
    sudo firewall-cmd --zone=public --list-all | tee -a $LOG_FILE
  fi
}

verify_docker() {
  # Verify docker installation
  if command_exists docker; then
    echo "[SUCCESS] Docker is installed" | tee -a $LOG_FILE
  else
    echo "[ERROR] Docker is currently not installed on the system" | tee -a $LOG_FILE
    exit 1
  fi

  # Verify docker is up
  pgrep -f docker > /dev/null
  if [ $? -ne "0" ]; then
    echo "[ERROR] Docker is currently not running" | tee -a $LOG_FILE
  else
    echo "[SUCCESS] Docker is currently running" | tee -a $LOG_FILE
  fi
  sudo cat /etc/docker/daemon.json >> $LOG_FILE
  echo "[INFORMATIONAL] `docker -v`" | tee -a $LOG_FILE
  echo "[INFORMATIONAL] `docker-compose -v`" | tee -a $LOG_FILE

}

verify_docker_service() {
  if [[ `which systemctl` ]] ; then
    echo "[INFORMATIONAL] Docker is `sudo systemctl is-enabled docker` on boot"
  elif [[ `ls /etc/init.d/docker` ]] ; then
    echo "[INFORMATIONAL] Docker service is started via /etc/init.d/docker  on boot"
  else
    echo "[INFORMATIONAL] Docker service /etc/init.d/docker file not found, docker service may not start on reboot"
  fi

}

verify_containers() {
  PATTERN_MANAGER_CONTAINER="camc-pattern-manager"
  SW_REPO_CONTAINER="camc-sw-repo"

  # Verify pattern manager container is up
  if [ "$(sudo docker ps | grep $PATTERN_MANAGER_CONTAINER)" ]; then
    echo "[SUCCESS] The Pattern Manager image is running correctly" | tee -a $LOG_FILE
    echo "[INFORMATIONAL] `sudo docker inspect --format='{{.Image}}' $PATTERN_MANAGER_CONTAINER`" | tee -a $LOG_FILE
  else
    echo "[ERROR] The Pattern Manager image is currently not running" | tee -a $LOG_FILE
    echo "$(sudo docker ps | grep $PATTERN_MANAGER_CONTAINER)" >> $LOG_FILE
    echo "[*] Docker Log..." | tee -a $LOG_FILE
    sudo docker ps | grep $PATTERN_MANAGER_CONTAINER | tee -a $LOG_FILE
    sudo docker ps -a | tee -a $LOG_FILE
    exit 1
  fi

  # Verify repo container is up
  if [ "$(sudo docker ps | grep $SW_REPO_CONTAINER)" ]; then
    echo "[SUCCESS] The Software Repository image is running correctly" | tee -a $LOG_FILE
    echo "[INFORMATIONAL] `sudo docker inspect --format='{{.Image}}' $SW_REPO_CONTAINER`" | tee -a $LOG_FILE
  else
    echo "[ERROR] The Software Repository image is currently not running" | tee -a $LOG_FILE
    echo "$(sudo docker ps | grep $SW_REPO_CONTAINER)" >> $LOG_FILE
    echo "[*] Docker Log..." | tee -a $LOG_FILE
    sudo docker ps | grep $SW_REPO_CONTAINER | tee -a $LOG_FILE
    sudo docker ps -a | tee -a $LOG_FILE
    exit 1
  fi
}

verify_pattern_manager() {
  # Verify connection to Pattern Manager
  # Get port number
  PM_PORT=`cat $CONFIG_PATH/camc-pattern-manager.tmpl | egrep -A1 "ports" | tail -1 | cut -f2 -d"\"" | cut -f1 -d":"`
  # Get AccessToken
  PM_ACCESSTOKEN=`cat $PARAM_FILE | egrep "ibm_pm_access_token" | cut -f2 -d"="`
  PM_CHECK=`curl -s --write-out %{http_code} --output pm_version.out --request POST -k -H "Authorization:Bearer $PM_ACCESSTOKEN" -X GET https://localhost:$PM_PORT/version`
  if [ $PM_CHECK == 200 ]; then
    echo "[SUCCESS] Connection to the Pattern Manager image was established correctly" | tee -a $LOG_FILE
  else
    echo "[ERROR] Could not establish connection to the Pattern Manager image" | tee -a $LOG_FILE
    echo "curl -s --write-out %{http_code} --output pm_version.out --request POST -k -H \"Authorization:Bearer $PM_ACCESSTOKEN\" -X GET https://localhost:$PM_PORT/version" >> $LOG_FILE
    curl -s --write-out %{http_code} --output pm_version.out --request POST -k -H "Authorization:Bearer $PM_ACCESSTOKEN" -X GET https://localhost:$PM_PORT/version | tee -a $LOG_FILE
    log_firewall
    exit 1
  fi
}

verify_sw_repo() {
  # Verify connection to Software Repo
  # Get port for software repo
  # SW_PORT=`cat camc-sw-repo.tmpl | egrep -A1 "ports" | tail -1 | cut -f2 -d"\"" | cut -f1 -d":"`
  # Get user and password for software repo
  SW_USER=`cat $PARAM_FILE | egrep "software_repo_user" | cut -f2 -d"="`
	SW_PASS=`cat $PARAM_FILE | egrep "software_repo_pass" | cut -f2 -d"="`
  SW_PORT=`cat $PARAM_FILE | egrep "software_repo_secure_port" | cut -f2 -d"="`

  if [ -z "$SW_PORT" ]; then
    SW_PORT="9999"
  fi

  SW_CHECK=000
  LOOPCOUNT=0
  while [[ $SW_CHECK == 000 ]] && [ $LOOPCOUNT -lt 6 ]; do
    SW_CHECK=`curl -s -u $SW_USER:$SW_PASS -k --write-out %{http_code} --output sw_repo.out -X GET https://localhost:$SW_PORT`
    let LOOPCOUNT=LOOPCOUNT+1
    sleep 5
    echo "[INFORMATIONAL] Obtained $SW_CHECK when attempting connection with the Software Repo image, attempt: $LOOPCOUNT/5" | tee -a $LOG_FILE
  done

  if [ $SW_CHECK == 403 ]; then
    echo "[SUCCESS] Connection to the Software Repo image was established correctly" | tee -a $LOG_FILE
  else
    if [[ $SW_CHECK == 401 ]] && [[ -z "$SW_PASS" ]] ; then
      echo "[SUCCESS] Connection to the Software Repo image was rejected correctly" | tee -a $LOG_FILE
    else
      echo "[ERROR] Could not establish connection to the Software Repo image" | tee -a $LOG_FILE
      echo "curl -s -u $SW_USER:$SW_PASS -k --write-out %{http_code} --output sw_repo.out -X GET https://localhost:$SW_PORT" >> $LOG_FILE
      curl -s -u $SW_USER:$SW_PASS -k --write-out %{http_code} --output sw_repo.out -X GET https://localhost:$SW_PORT | tee -a $LOG_FILE
      log_firewall
      exit 1
    fi
  fi
}

verify_pattern_manager_connection() {
  CHEF_IP=`cat $PARAM_FILE | egrep "chef_ip" | cut -f2 -d"="`
  BYOCHEF=`cat $PARAM_FILE | egrep "byochef" | cut -f2 -d"="`
  if [ -z "$CHEF_IP" ]; then
    CHEF_IP=`cat $PARAM_FILE | egrep "static_ip_address" | cut -f2 -d"="`
  fi
  sudo docker exec -i camc-pattern-manager /bin/bash -c "nc -v -w 30 -z $CHEF_IP 443"
  if [ $? -gt 0 ]; then
    echo "[ERROR] Couldn't establish a connection between Pattern Manager and host using port 443" | tee -a $LOG_FILE
    if [[ $BYOCHEF == "true" ]]; then
      echo "[ERROR] There might have been an error communicating with the provided Chef Server. Please check the provided IP address, FQDN and PEM file and try again."
    fi
    log_firewall
    exit 1
  else
    echo "[SUCCESS] Connection from Pattern Manager to host has been established successfully" | tee -a $LOG_FILE
  fi
}

verify_pattern_manager_config() {
  sudo docker exec -i camc-pattern-manager /bin/bash -c "sudo -u chef-user namei -m /opt/ibm/pattern-manager/config/config.json" > /dev/null
  if [ $? -gt 0 ]; then
    echo "[ERROR] There was an issue accessing the config.json from the pattern manager container /opt/ibm/pattern-manager/config/config.json, check that non-root has read: /opt/ibm/docker/pattern-manager/config/config.json" | tee -a $LOG_FILE
   sudo docker exec -i camc-pattern-manager /bin/bash -c "sudo -u chef-user namei -m /opt/ibm/pattern-manager/config/config.json" | tee -a $LOG_FILE
   namei /opt/ibm/docker/pattern-manager/config/config.json | tee -a $LOG_FILE
  else
    echo "[SUCCESS] Config.json file could be accessed with chef-user user" | tee -a $LOG_FILE
  fi

}

verify_chef() {
  # Check the status of the running nodes every second for a minute, if an error is found, exit
  BYOCHEF=`cat $PARAM_FILE | egrep "byochef" | cut -f2 -d"="`

  if [[ $BYOCHEF == "true" ]]; then
    echo "[INFORMATIONAL] An external Chef server was configured on installation"
  else
    ATTEMPT=0
    echo "[*] Verifying Chef status" | tee -a $LOG_FILE
    while [ $ATTEMPT -lt 5 ];
    do
      sudo /usr/bin/chef-server-ctl status > /dev/null
      if [ $? -gt 0 ]; then
        sudo /usr/bin/chef-server-ctl status | tee -a $LOG_FILE
        echo "[ERROR] The Chef server nodes are not running correctly" | tee -a $LOG_FILE
        exit 1
      fi
      let ATTEMPT=ATTEMPT+1
      sleep 1
    done
    echo "[SUCCESS] Chef server nodes are running correctly" | tee -a $LOG_FILE
    echo "[INFORMATIONAL] `head -n1 /opt/opscode/version-manifest.txt`"
  fi
}

verify_cookbooks() {
  INSTALL_COOKBOOKS=`cat $PARAM_FILE | egrep "install_cookbooks" | cut -f2 -d"="`
  if [[ "$INSTALL_COOKBOOKS" == "true" ]]; then
    IPADDR=`cat $PARAM_FILE | egrep "static_ip_address" | cut -f2 -d"="`
    PM_ACCESSTOKEN=`cat $PARAM_FILE | egrep "ibm_pm_access_token" | cut -f2 -d"="`
    LOOPIT=0; LOOPCOUNT=0
  	while test $LOOPIT -eq 0 # We need to loop because chef sometimes returns bad data, the response code is not 200, we will retry a few times to get past the error
  	do
  	  CHECK=`curl --max-time 120 -s -k --write-out %{http_code} --output cookbooks.out -H "Authorization:Bearer $PM_ACCESSTOKEN" -X GET https://$IPADDR:5443/v1/info/chef`
      if [ "$CHECK" == 200 ]; then
        LOOPIT=1
      else
        let 'LOOPCOUNT=LOOPCOUNT+1'
        if [ "$LOOPCOUNT" = "5" ]; then
          LOOPIT=1
        fi
      fi
  	done
  	if [ "$CHECK" == 200 ]; then
  		echo "[SUCCESS] Chef Cookbooks verified successfully" | tee -a $LOG_FILE
  	else
      echo "curl -k --write-out %{http_code} --output cookbooks.out -H 'Authorization:Bearer $PM_ACCESSTOKEN' -X GET https://$IPADDR:5443/v1/info/chef" >> $LOG_FILE
      echo "[ERROR] There was a problem verifying Chef Cookbooks" | tee -a $LOG_FILE
      if [ "$CHECK" == 401 ]; then
        echo "[ERROR] There seems to be an issue with the configured permissions in the server/Docker images"
        exit 1
      fi
  	fi
  	if [[ `egrep '"roles":' cookbooks.out` && `egrep '"cookbooks":' cookbooks.out` ]]; then
      echo "[SUCCESS] Cookbooks response verified successfully" | tee -a $LOG_FILE
    else
      echo "[ERROR] There was a problem verifying Chef Cookbook's response" | tee -a $LOG_FILE
    fi
  	# check to see if there were some roles and cookbooks written
  	CB_COUNT=0
  	CB_START=`egrep -n ' .cookbooks.: \[' cookbooks.out |cut -f1 -d:`
  	CB_END=`egrep -m 1 -n '\],' cookbooks.out|cut -f1 -d:`

  	let 'CB_COUNT=CB_END-CB_START'
  	if [ "$CB_COUNT" -gt "5" ] ; then
      echo "[SUCCESS] Total Chef Cookbook count $CB_COUNT" | tee -a $LOG_FILE
  	else
      echo "[ERROR] Total Chef Cookbook count $CB_COUNT, at least 6 expected" | tee -a $LOG_FILE
  	fi

    ROLE_COUNT=0
    ROLE_START=`egrep -n ' .roles.: \[' cookbooks.out|cut -f1 -d:`
  	ROLE_END=`egrep -n '\]$' cookbooks.out|cut -f1 -d:`
  	let 'ROLE_COUNT=ROLE_END-ROLE_START'
    if [ "$ROLE_COUNT" -gt "5" ] ; then
      echo "[SUCCESS] Total Chef role count $ROLE_COUNT" | tee -a $LOG_FILE
    else
      echo "[ERROR] Total Chef role count $ROLE_COUNT, at least 6 expected" | tee -a $LOG_FILE
    fi
    cat cookbooks.out >> $LOG_FILE
  else
    echo "[INFO] Cookbooks were not installed on the server."
  fi
}

function verify_software_repo_directory()
{
  # This is a verification of the repo directories from the repo
  FAIL_COUNT=0
  mkdirFile=$CONFIG_PATH/mkdir.properties
  ABS_PATH="/var/swRepo/private"

  set `cat $mkdirFile | egrep -v "^#"`
  while test $# -gt 0 ; do
    sudo docker exec -i camc-sw-repo /bin/bash -c "ls $ABS_PATH/$1 2> /dev/null > /dev/null"
    if [[ ! "$?" = "0" ]] ; then
      echo "    Missing directory : $ABS_PATH/$1"
      FAIL_COUNT=1
    fi
    shift
  done
  if [ "$FAIL_COUNT" -gt "0" ] ; then
     echo "[ERROR] Software repo docker $ABS_PATH is not setup as expected, see previous message. This could be a permission problem in the docker container" | tee -a $LOG_FILE
  else
    echo "[SUCCESS] Software repo docker container $ABS_PATH is setup as expected" | tee -a $LOG_FILE
  fi
}

function verify_software_directory()
{
  FAIL_COUNT=0
  mkdirFile=$CONFIG_PATH/mkdir.properties
  ABS_PATH=`egrep 'ROOT : ' $mkdirFile | cut -f2 -d':' | tr -d ' '`
  set `cat $mkdirFile | egrep -v "^#"`
  while test $# -gt 0 ; do
    ls $ABS_PATH/$1 2> /dev/null > /dev/null
    if [[ ! "$?" = "0" ]] ; then
      echo "    Missing directory : $ABS_PATH/$1"
      FAIL_COUNT=1
    fi
    shift
  done
  if [ "$FAIL_COUNT" -gt "0" ] ; then
     echo "[ERROR] Virtual machine $ABS_PATH is not setup as expected, see previous message" | tee -a $LOG_FILE
  else
    echo "[SUCCESS] Virtual machine $ABS_PATH is setup as expected" | tee -a $LOG_FILE
  fi
}

function verify_docker_ps_run()
{
  ( sudo docker system df | xargs -i echo [INFORMATIONAL] [docker system df] {} &> $DOCKER_LOG ) &
}

function verify_docker_ps_log()
{
  [[ -e "$DOCKER_LOG" ]] && { cat $DOCKER_LOG | tee -a $LOG_FILE ; }
  sudo docker system info 2>1 | xargs -i echo [INFORMATIONAL] [docker system info] {} >> $LOG_FILE
}

function verify_cronjob()
{
  grep -H "copyPMConfig.sh" /var/spool/cron/crontabs/*
  if [ $? != 0 ]; then
    echo "[INFORMATIONAL] Initializing Pattern Manager configuration cronjob"
    (crontab -l 2>/dev/null; echo "@reboot /root/advanced-content-runtime/copyPMConfig.sh") | crontab -
  else
    echo "[INFORMATIONAL] Pattern Manager configuration cronjob exists"
  fi
}

function format_disk_output()
{
  local fs=$1
  local msg=$2
  local checkfs=$1
  [[ -z "$checkfs" ]] && checkfs="/"

  echo "[INFORMATIONAL] ========================================================================================================"
  [[ -d "$checkfs" ]] &&  { sudo df -h $fs | egrep "^/dev/|^File" | xargs -i echo "[INFORMATIONAL] $msg : $fs : {}" | tee -a $LOG_FILE ; } || { echo "[INFORMATIONAL] file: $fs not found, used for : $2" | tee -a $LOG_FILE ; }
}
function disk_configuration()
{
  format_disk_output "" "File System"
  format_disk_output ~ "Current user"
  format_disk_output "/opt/opscode" "Chef Server"
  format_disk_output "/var/opt/opscode" "Chef Dependencies"
  format_disk_output "/var/lib/docker" "Docker"
  format_disk_output "/opt/ibm/docker" "Runtime docker container"
  format_disk_output "/usr/bin" "Docker/Chef commands"
  format_disk_output "/tmp" "terraform/python tmp"
  format_disk_output "/opt/ibm/docker/software-repo/var/swRepo/private" "Software Repo"
  echo "[INFORMATIONAL] ========================================================================================================"
  sudo lsblk >> $LOG_FILE
}

function echo_log_file_locations()
{
  echo "[INFORMATIONAL] Addition information can be located in log files :"
  echo -e "\tverification log : \n\t\t$LOG_FILE"
  echo -e "\tchef installation log : \n\t\t$CHEF_FILE"
  echo -e "\tpattern manager logs : \n`sudo ls -1 /var/log/ibm/docker/pattern-manager/* | xargs -i echo -e '\t\t{}'`"
}

TIMESTAMP=`date '+%Y-%m-%d %H:%M:%S'`
echo "[*] Verifying Content Runtime installation, started on $TIMESTAMP" | tee -a $LOG_FILE
echo "[*] Content Runtime template version: `cat $PARAM_FILE | egrep 'template_timestamp' | cut -f2 -d'='`"
echo "[INFORMATIONAL] Hostname : `hostname`, Domain : `hostname -d`" | tee -a $LOG_FILE
echo "[INFORMATIONAL] `cat /etc/*release | egrep PRETTY | cut -f2 -d'"'`" | tee -a $LOG_FILE
echo -e "/etc/hosts:\n`cat /etc/hosts`\n" >> $LOG_FILE

echo_log_file_locations
disk_configuration
verify_docker_ps_run
verify_chef
verify_docker
verify_docker_service
verify_containers
verify_cookbooks
verify_sw_repo
verify_pattern_manager
verify_pattern_manager_config
verify_pattern_manager_connection
verify_software_directory
verify_software_repo_directory
verify_docker_ps_log
EndOfFile

    destination = "./advanced-content-runtime/verify-installation.sh"
  }

  provisioner "file" {
    content = <<EndOfFile
#!/bin/bash
#
# Copyright : IBM Corporation 2016, 2017
#
######################################################################################
# Script that contains functions used on other files
# Usage: . ./utilities.sh
######################################################################################

# download_file name url file-name
download_file() {
  rm -rf *.prg
  curl -o $3 --retry 5 --progress-bar $2 2> $3.prg &
  CURL_PID=$!
  string="[*] Downloading: $1"
  line="....................................."
  LAST_PROGRESS='0.0'

  while kill -0 $CURL_PID > /dev/null 2>&1
  do
    sleep 10
    PROGRESS=`grep -o -a "..0..%" $3.prg | tail -n1`
    if [ "$PROGRESS%" != "$LAST_PROGRESS%" ] && [ ! -z "$PROGRESS" ]; then
      LAST_PROGRESS=$PROGRESS
      if !  egrep "[.*\d.*]$"  <<< $PROGRESS; then
        printf "%s %s [$PROGRESS%]\n" "$string" "$line"
      fi
    fi
  done
  rm -rf $3.prg
  printf "%s %s [COMPLETE]\n" "$string" "$line"
}

# Check if a command exists
command_exists() {
  type "$1" &> /dev/null;
}

# Check if the environment is offline
is_offline() {
  ping -c 3 -w 10 www.ibm.com 2> /dev/null
  if [ $? -ne "0" ]; then
    echo "true"
  else
    echo "false"
  fi
}

# Load a docker image
function load_docker_image {
  if [[ -n $1 ]] && [[ -n $2 ]]; then
    echo "[*] Loading docker image $1"
    download_file $2 $1 $2
    docker image load -q < $2
  fi
}

#Get platform
function get_platform() {
  PLATFORM=""
  if command_exists python; then
    PLATFORM=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
  else
    if command_exists python3; then
      PLATFORM=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f3 | rev | tr -d '".' | tr '[:upper:]' '[:lower:]'`
    fi
  fi

  # Check if the executing platform is supported
  if [[ $PLATFORM == *"ubuntu"* ]] || [[ $PLATFORM == *"redhat"* ]] || [[ $PLATFORM == *"rhel"* ]] || [[ $PLATFORM == *"centos"* ]]; then
    echo "$PLATFORM"
  else
    echo "ERROR"
  fi
}

#Get platform version
function get_platform_version() {
  PLATFORM_VERSION=""
  if command_exists python; then
    PLATFORM_VERSION=`python -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
  else
    if command_exists python3; then
      PLATFORM_VERSION=`python3 -c "import platform;print(platform.platform())" | rev | cut -d '-' -f2 | rev`
    fi
  fi
  if [[ -z $PLATFORM_VERSION ]]; then
    echo "ERROR"
  else
    echo $PLATFORM_VERSION
  fi
}

#True if kernel supports overlayfs.
#OverlayFS is supported on Kernel 4 and above. On RHEL from 3.10.0-693. 
function is_kernel_overlay_compat(){
	KERNEL=`uname -r | cut -d'.' -f1`
	if [ "$KERNEL" -lt 4 ]; then
		if [ "$KERNEL" -lt 3 ]; then
			#0.x, 1.x, 2.x
			echo 'false'
			return
		else
			#KERNEL 3
			MAJOR=`uname -r | cut -d'.' -f2`
			if [ "$MAJOR" -lt 10 ]; then
				#3.x (0 to 9)
				echo 'false'
				return
			elif [ "$MAJOR" -eq 10 ]; then
				#3.10.x
				MINOR=`uname -r | cut -d'.' -f3 | cut -d'-' -f1`
				if [ "$MINOR" -eq 0 ]; then
					#3.10.0
    			BUGPATCH=`uname -r | tr - . | cut -d'.' -f4`
    			if [ "$BUGPATCH" -lt 693 ]; then
          	echo 'false'
          	return
    			else
    				#3.10.693 and above
        		echo 'true'
        		return
    			fi
    		else
    			#3.10.1 and above
    			echo 'true'
    			return
    		fi
    	else
    		#3.11.x
    		echo 'true'
    		return
    	fi
    fi
	else
		#4.x and above
  	echo 'true'
  	return
	fi	
}

#True if docker engine supports devicemapper. devicemapper is deprecated in docker 18.09.
function is_devicemapper_supported(){
	ENCRYPTION_PASSPHRASE=""
	if [[ $# -eq 1 ]]; then
		ENCRYPTION_PASSPHRASE=$1
	fi	
	#Check version if not found restart docker daemon.
	VERSION_TEST=`sudo docker version --format '{{.Server.Version}}' 2>/dev/null`
	RC=$?
	if [[ $RC -eq 1 ]]; then
		[[ `which systemctl` ]] && { echo -n "$ENCRYPTION_PASSPHRASE" | sudo systemctl start docker || true ; } || { echo -n "$ENCRYPTION_PASSPHRASE" | sudo service docker start || true ; }
	fi
	major=`sudo docker version --format '{{.Server.Version}}' | cut -d'-' -f1 | cut -d'.' -f1`
	minor=`sudo docker version --format '{{.Server.Version}}' | cut -d'-' -f1 | cut -d'.' -f2 | sed 's/^0*//'`
	if [ "$major" -lt 18 ]; then
		echo 'true'
	else
		if [ "$minor" -lt 9 ]; then
			echo 'true'
		else
			echo 'false'
		fi
	fi
}
EndOfFile

    destination = "./advanced-content-runtime/utilities.sh"
  }

  provisioner "file" {
    content = <<EndOfFile
#!/bin/bash
PM_CONFIG_BACKUP_PATH="./.advanced-runtime-config/"
PM_CONFIG_PATH="/opt/ibm/docker/pattern-manager/config/"

if [ ! -d "$PM_CONFIG_PATH" ] || [ ! -f "$PM_CONFIG_PATH/config.json" ]; then
  sudo mkdir -p "$PM_CONFIG_PATH"
  sudo cp $PM_CONFIG_BACKUP_PATH/config.json $PM_CONFIG_PATH
fi
EndOfFile

    destination = "./advanced-content-runtime/copyPMConfig.sh"
  }

  provisioner "file" {
    content = <<EndOfFile
#!/bin/bash
# encoding: UTF-8
########################################################
# Copyright IBM Corp. 2016, 2016
#
#  Note to U.S. Government Users Restricted Rights:  Use,
#  duplication or disclosure restricted by GSA ADP Schedule
#  Contract with IBM Corp.
############################################################

if [ "$DEBUG" = "true" ] ; then set -x ; fi
set -o errexit
set -o nounset

# change to script path
cd /opt

# This is a patch for issue : https://github.com/chef/chef_backup/issues/26
sed -i  "s#configs\[config\]\['config'\]#configs[config]['data_dir']#g" /opt/opscode/embedded/lib/ruby/gems/2.2.0/gems/chef_backup-0.0.1/lib/chef_backup/data_map.rb || true

echo 'Pushing memory limits higher'
/sbin/sysctl -w kernel.shmmax=8589934592
/sbin/sysctl -w kernel.shmall=2097152
/sbin/sysctl -p /etc/sysctl.conf || true

# Use a random admin user password if none is provided
if [ ".$ADMIN_PASSWORD" = "."  ] ; then export ADMIN_PASSWORD=$(< /dev/urandom |head -c64 | md5sum|head -c12); fi
# Self signed SSL cert params defaults (using IBM Headquarters)
if [ ".$SSL_CERT_COUNTRY" = "."  ] ; then export SSL_CERT_COUNTRY="US"; fi
if [ ".$SSL_CERT_STATE" = "."  ] ; then export SSL_CERT_STATE="New York"; fi
if [ ".$SSL_CERT_CITY" = "." ] ; then export SSL_CERT_CITY="Armonk"; fi

echo 'Chef Server - CONFIG START'
# Make sure we have the right config
chefconfig="/etc/opscode/chef-server.rb"
certsdir="/etc/opscode/ca"

cp /opt/chef-server.rb $chefconfig
# parse config to update certificates paths if needed
custompem=`ls -1 $certsdir/*.pem 2> /dev/null|head -1`
customkey=`ls -1 $certsdir/*.key 2> /dev/null|head -1`
if test -n "$custompem" && test -n "$customkey"  && test -f $custompem && test -f $customkey; then
    # we're going to use the customer provided certs
    echo 'Using customer provided SSL certificates'
    sed -i "s#CUSTOMPEM#$custompem#g" $chefconfig
    sed -i "s#CUSTOMKEY#$customkey#g" $chefconfig
else
    # remove ssl related configs and use self-generated certs
    echo 'Using self-signed SSL certificates'
    sed -i "/ssl_/d" $chefconfig
    # generate self-signed certs with sha256 encryption instead of sha1
    certpath="/var/opt/opscode/nginx/ca/"
    [[ ! -d "$certpath" ]] && mkdir -p $certpath
    certname="/var/opt/opscode/nginx/ca/$HOSTNAME"
    openssl genrsa > "$certname.key"
    openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048\
        -key "$certname.key" -out "$certname.crt"\
        -subj "/C=$SSL_CERT_COUNTRY/ST=$SSL_CERT_STATE/L=$SSL_CERT_CITY/O=$ORG_NAME/CN=$HOSTNAME"
fi

# Start Chef own runservice
/opt/opscode/embedded/bin/runsvdir-start &

# Drop old running context
rm -f /etc/opscode/chef-server-running.json
rm -f /opt/opscode/embedded/service/oc_id/tmp/pids/server.pid

# Configure/post crash reconfigure
echo "Doing initial configuration of Chef server"
/usr/bin/chef-server-ctl reconfigure 2>&1 | tee $CHEF_LOG | egrep ": Processing directory|: Processing cookbook_file" || true  # do not display lines string w/blanks

# Initial configuration for Chef Manage Web-GUI if installed
if test -f /usr/bin/chef-manage-ctl; then
    echo "Doing initial configuration of Chef Manage"
    /usr/bin/chef-manage-ctl reconfigure
fi

# Create admin user if it's not there
if [ `/usr/bin/chef-server-ctl user-list|grep -cE $ADMIN_NAME` -eq 0 ]; then
    echo "Creating admin user: $ADMIN_NAME"; sleep 5;
    /usr/bin/chef-server-ctl user-create $ADMIN_NAME $ADMIN_NAME $ADMIN_NAME $ADMIN_MAIL "$ADMIN_PASSWORD" -f /etc/opscode/$ADMIN_NAME.pem
fi

# Create chef organization
SHORT_ORG_NAME=`echo $ORG_NAME | tr '[:upper:]' '[:lower:]'`
if [ `/usr/bin/chef-server-ctl org-list|grep -cE $SHORT_ORG_NAME` -eq 0 ]; then
    echo "Creating organization: $SHORT_ORG_NAME"; sleep 5;
    /usr/bin/chef-server-ctl org-create $SHORT_ORG_NAME $ORG_NAME -f /etc/opscode/$SHORT_ORG_NAME.pem --association_user $ADMIN_NAME
fi

echo 'Chef Server - CONFIG DONE'
echo "Chef Server - running on host: $HOSTNAME"
/usr/bin/chef-server-ctl status
rc=$?
if [ $rc -gt 0 ]; then
	tail -f $CHEF_LOG
fi
exit $rc
EndOfFile

    destination = "./advanced-content-runtime/setupchef.sh"
  }

  provisioner "file" {
    content = <<EndOfFile
#!/usr/bin/env python

"""
Create a PM config file from input values.

Note: This is the content runtime copy of this file and is the production copy.
      The copy of this file in infra-pattern-manager is used for pattern
      manager testing.
"""

import argparse
import base64
import json
import sys

parser = argparse.ArgumentParser(description="Create PM configuration file")
parser.add_argument("access_token")
parser.add_argument("admin_token")
parser.add_argument("cam_service_key_loc")
parser.add_argument("-c", nargs="?", default="unencoded")
parser.add_argument("chef_pem_loc")
parser.add_argument("-p", nargs="?", default="unencoded")
parser.add_argument("chef_fqdn")
parser.add_argument("chef_org")
parser.add_argument("chef_ip")
parser.add_argument("chef_admin_id")
parser.add_argument("software_repo_ip")
parser.add_argument("software_repo_unsecured_port")
parser.add_argument("target_file", default="pm_config.json")
parser.add_argument("chef_client_version", default="14.0.202")
args = parser.parse_args()

with open(args.cam_service_key_loc, "r") as f:
    key_data = f.read()
if args.c == "unencoded":
    cam_key_raw = base64.b64encode(key_data)
else:
    cam_key_raw = key_data

with open(args.chef_pem_loc, "r") as f:
    pem_data = f.read()
if args.p == "unencoded":
    pem_raw = base64.b64encode(pem_data)
else:
    pem_raw = pem_data

pm_config = {
    "access_tokens": {
        "access_token": args.access_token,
        "admin_token": args.admin_token
    },
    "cam_service_keys": {
        "default": {
            "raw_key": cam_key_raw
        }
    },
    "chef_servers": {
        "default": {
            "pem": pem_raw,
            "fqdn": args.chef_fqdn,
            "org": args.chef_org,
            "ip": args.chef_ip,
            "admin_id": args.chef_admin_id,
            "software_repo_ip": args.software_repo_ip,
            "software_repo_unsecured_port": args.software_repo_unsecured_port,
            "chef_client_version": args.chef_client_version
        }
    }
}

en_pm_config = base64.b64encode(json.dumps(pm_config))

with open(args.target_file, "w") as f:
    f.write(en_pm_config)

sys.exit()
EndOfFile

    destination = "./advanced-content-runtime/crtconfig.py"
  }

  provisioner "file" {
    content = <<EndOfFile
opscode_erchef['s3_url_ttl'] = 3600
nginx['ssl_certificate'] = "CUSTOMPEM"
nginx['ssl_certificate_key'] = "CUSTOMKEY"
nginx['ssl_ciphers'] = "HIGH:MEDIUM:!LOW:!kEDH:!aNULL:!ADH:!eNULL:!EXP:!SSLv2:!SEED:!CAMELLIA:!PSK"
nginx['ssl_protocols'] = "TLSv1 TLSv1.1 TLSv1.2"
nginx['stub_status'] = { :listen_port => 7777, :listen_host => '127.0.0.1' }
EndOfFile

    destination = "./advanced-content-runtime/chef-server.rb"
  }

  provisioner "file" {
    content = <<EndOfFile
{
	"authorization": { "personal_access_token": "$CAMHUB_ACCESS_TOKEN"},
        "github_hostname": "$CAMHUB_HOST",
        "org": "$CAMHUB_ORG",
        "repos": "cookbook_.*",
        "branch": "$COOKBOOK_VERSION"
}
EndOfFile

    destination = "./advanced-content-runtime/load.tmpl"
  }

  provisioner "file" {
    content = <<EndOfFile
  #camc-pattern-manager
  camc-pattern-manager:
    image: $DOCKER_REGISTRY_PATH/camc-pattern-manager:$PATTERN_MGR_VERSION
    restart: always
    container_name: camc-pattern-manager
    hostname: $PATTERN_MGR_FQDN
    volumes:
      - /var/log/ibm/docker/pattern-manager:/var/log/pattern-manager
      - /var/log/ibm/docker/pattern-manager:/var/log/apache2
      - /etc/opscode:/home/chef-user/opscode
      - /opt/ibm/docker/pattern-manager/certs:/opt/ibm/pattern-manager/flask_application/certs
      - /opt/ibm/docker/pattern-manager:/opt/ibm/pattern-manager/ssl
      - /opt/ibm/docker/pattern-manager/config:/opt/ibm/pattern-manager/config
    tmpfs: /tmp
    environment:
      - PM_CONFIG=/opt/ibm/pattern-manager/config/config.json
      - PATTERN_MGR_FQDN=$PATTERN_MGR_FQDN
    ports:
      - "5443:443"
    extra_hosts:
      - $CHEF_HOST_FQDN:$CHEF_IPADDR
      - $SOFTWARE_REPO_FQDN:$SOFTWARE_REPO_IP
EndOfFile

    destination = "./advanced-content-runtime/camc-pattern-manager.tmpl"
  }

  provisioner "file" {
    content = <<EndOfFile
  #camc-sw-repo
  camc-sw-repo:
    image: $DOCKER_REGISTRY_PATH/camc-sw-repo:$SOFTWARE_REPO_VERSION
    restart: always
    container_name: camc-sw-repo
    hostname: $SOFTWARE_REPO_FQDN
    volumes:
      - /opt/ibm/docker/software-repo/etc/nginx/auth:/etc/nginx/auth
      - /var/log/ibm/docker/software-repo/var/log/nginx:/var/log/nginx
      - /opt/ibm/docker/software-repo/etc/fstab:/etc/fstab
      - /opt/ibm/docker/software-repo/var/swRepo/private:/var/swRepo/private
      - /opt/ibm/docker/software-repo/var/swRepo/public:/var/swRepo/public
      - /opt/ibm/docker/software-repo/var/swRepo/yumRepo:/var/swRepo/yumRepo
      - /opt/ibm/docker/software-repo/etc/nginx/server-certs:/etc/nginx/ssl
    environment:
      - SOFTWARE_REPO_FQDN=$SOFTWARE_REPO_FQDN
      - SOFTWARE_REPO_PORT=$SOFTWARE_REPO_PORT
      - SOFTWARE_REPO_SECURE_PORT=$SOFTWARE_REPO_SECURE_PORT
    ports:
      - "$SOFTWARE_REPO_PORT:$SOFTWARE_REPO_PORT"
      - "$SOFTWARE_REPO_SECURE_PORT:$SOFTWARE_REPO_SECURE_PORT"
    privileged: true
EndOfFile

    destination = "./advanced-content-runtime/camc-sw-repo.tmpl"
  }

  provisioner "file" {
    content = <<EndOfFile
#
# Copyright : IBM Corporation 2016, 2016
#
###########################################################################
# Docker Compose file for deploying repo-server, chef-server and pattern-manager
###########################################################################
version: '2'
services:

EndOfFile

    destination = "./advanced-content-runtime/infra-docker-compose.tmpl"
  }

  provisioner "file" {
    content = <<EndOfFile
#!/bin/bash
#
# Copyright : IBM Corporation 2017. All rights reserved.
#
set -o errexit
set -o nounset
set -o pipefail

if [ $# -ne 2 ] ; then
  echo "Usage: image-upgrade <service> <version>"
  exit 1
fi

toolpath=`dirname $0`

if ! grep -xq ".*image:.*$1:.*" $toolpath/docker-compose.yml ; then
  echo "ERROR: Unable to find image definition for '$1' in docker-compose.yml."
  exit 1
fi

# Backup docker-compose.yml to docker-compose.yml.orig-<date_timestamp>
# Find / replace image line for <service> and update with new <version>
datetime=`date +"%Y-%m-%d_%H_%M_%S"`
sed --in-place=".orig-$datetime" -E "/\s*image:/s/($1:)(.*)/\1$2/" $toolpath/docker-compose.yml

set +e # disable checks
if ! sudo docker-compose -f $toolpath/docker-compose.yml pull; then
  echo "ERROR: Docker pull failed, restoring original config..."
  badconf="$toolpath/docker-docker-compose.yml.BAD-$datetime"
  mv $toolpath/docker-compose.yml $badconf
  mv "$toolpath/docker-compose.yml.orig-$datetime" $toolpath/docker-compose.yml
  echo "ERROR: Bad configuration saved in: $badconf"
  exit 1
fi
set -e # re-enable checks

echo "Pull done, restarting containers..."
sudo docker-compose -f $toolpath/docker-compose.yml stop
sudo docker-compose -f $toolpath/docker-compose.yml up -d

# Archive the output into the parameter file 
imagename=`grep -q ".*image:.*$1:.*" $toolpath/docker-compose.yml | rev |cut -f2 -d: | cut -f1 -d/ | rev`
sed -i "s/\(--$imagename\_version=\)\(.*\)/\1$2/" `find $toolpath -name .launch-docker-compose.sh`

echo "Done."
EndOfFile

    destination = "./advanced-content-runtime/image-upgrade.sh"
  }

  provisioner "file" {
    content = <<EndOfFile
# Properties file used to create the directory structure on the location disk
# All path are relative to ROOT : /opt/ibm/docker/software-repo/var/swRepo/private
apache/httpd/v2.4.25/rhel7
apache/tomcat/v70/base
apache/tomcat/v80/base
db2/v105/base
db2/v105/maint
db2/v111/base
db2/v111/maint
im/v1x/base
IMRepo
oracle/mysql/v5.7.17/base
wmq/v8.0/base
wmq/v8.0/maint
wmq/v9.0/base
wmq/v9.0/maint
EndOfFile

    destination = "./advanced-content-runtime/mkdir.properties"
  }

  provisioner "file" {
    content = <<EndOfFile
LayoutPolicyVersion=0.0.0.1
LayoutPolicy=Composite
#repository.url.was=./WAS9
#repository.url.liberty=./Liberty
#repository.url.jdk8=./jdk8
EndOfFile

    destination = "./advanced-content-runtime/repository.config"
  }

  provisioner "file" {
    content = <<EndOfFile
#
# Copyright : IBM Corporation 2016, 2016
#
######################################################################################
# Script to install docker-engine, docker-compose and launch the containers as per infra-docker-compose.tmpl
######################################################################################
#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

TEMPLATE_TIMESTAMP=""
. `dirname $0`/utilities.sh

function setup_aws_private() { # This is for PRIVATE network
  # AWS images do not have standard settings for IP and Hostname on the image.
	# The information in stored in metadata, which is accessable using the curl and IP address below
	# The IP is a virual address on top of the VM, and the request does not leave the machine
	# In turn the information is set back onto the VM to allow Chef and other packages to get information
	# about the configuration as they expect in a standard machine
  IPADDR=`curl http://169.254.169.254/latest/meta-data/local-ipv4` # ~ip_checker
  HOSTNAME=`curl http://169.254.169.254/latest/meta-data/local-hostname| cut -f1 -d'.' ` # ~ip_checker
  # Depending on the region there are different domains
  metadata=169.254.169.254 # ~ip_checker
  [[ "curl http://$metadata/latest/dynamic/instance-identity/document | egrep 'region.*us-east-1'" ]] && DOMAIN=ec2.internal || DOMAIN=`curl http://$metadata/latest/dynamic/instance-identity/document | cut -f4 -d'"'`.compute.internal # ~ip_checker
  # For chef local configuration, we need to fix up the host name on aws
  sudo hostname $HOSTNAME.$DOMAIN
  echo $IPADDR $HOSTNAME.$DOMAIN | sudo tee -a /etc/hosts
}

function setup_aws_public() { # This is for the PUBLIC network
  # AWS images do not have standard settings for IP and Hostname on the image.
  # The information in stored in metadata, which is accessable using the curl and IP address below
  # The IP is a virual address on top of the VM, and the request does not leave the machine
  # In turn the information is set back onto the VM to allow Chef and other packages to get information
  # about the configuration as they expect in a standard machine
  metadata=169.254.169.254 # ~ip_checker
  IPADDR=`curl http://$metadata/latest/meta-data/public-ipv4`
  DOMAIN=`curl http://$metadata/latest/meta-data/public-hostname| cut -f2- -d'.' `
  HOSTNAME=`curl http://$metadata/latest/meta-data/public-hostname| cut -f1 -d'.' `

  # It is possible that the hostname is not set, we need to fall back to private configuration
  if [[ -z "$HOSTNAME" ]] ; then  # we also assume the DOMAIN is not set in this case
    if [[ `which nslookup` ]] ; then # Since this is a public IP we should be able to get information back on the address
      local fqn=`nslookup $IPADDR | egrep "in-addr.arpa" | cut -f2 -d'=' | tr -d ' ' | rev | cut -c2- | rev`
      DOMAIN=`echo $fqn | cut -f2- -d'.'`
      HOSTNAME=`echo $fqn | cut -f1 -d'.'`
      sudo hostname $fqn
    fi
    if [[ -z "$HOSTNAME" ]] ; then # fall back to the private IP
      HOSTNAME=`curl http://$metadata/latest/meta-data/local-hostname| cut -f1 -d'.' `
      [[ "curl http://$metadata/latest/dynamic/instance-identity/document | egrep 'region.*us-east-1'" ]] && DOMAIN=ec2.internal || DOMAIN=`curl http://$metadata/latest/dynamic/instance-identity/document | cut -f4 -d'"'`.compute.internal # ~ip_checker
      [[ `echo $DOMAIN | cut -c1` == '.' ]] && DOMAIN=`echo $DOMAIN | cut -c2-` # if we filed to find the DOMAIN in the grep, fall back to compute.internal
      # For chef local configuration, we need to fix up the host name on aws
      sudo hostname $HOSTNAME.$DOMAIN
      echo $IPADDR $HOSTNAME.$DOMAIN | sudo tee -a /etc/hosts
    fi
  else
    # For chef local configuration, we need to fix up the host name on aws
    sudo hostname `curl http://$metadata/latest/meta-data/public-hostname`
  fi
}


function setup_other_private() {
  # this is used to get the domain name of the docker host, and pass to the rest of the infrastructure, based on the docker node
	IPADDR=`ip addr | tr -s ' ' | egrep 'inet ' | sed -e 's/inet //' -e 's/addr://' -e 's/ Bcast.*//' -e 's/ netmask.*//' -e 's/ brd.*//'  -e 's/^ 127\..*//' -e 's/^ 172\...\.0\.1.*//' | cut -f1 -d'/'| xargs echo`
	DOMAIN=`hostname -d`
	HOSTNAME=`hostname | cut -f1 -d.`
}

function setup_other_public() {
  # this is used to get the domain name of the docker host, and pass to the rest of the infrastructure, based on the docker node
  IPADDR=`ip addr | tr -s ' ' | egrep 'inet ' | sed -e 's/inet //' -e 's/addr://' -e 's/ Bcast.*//' -e 's/ netmask.*//' -e 's/ brd.*//'  -e 's/^ 127\..*//' -e 's/^ 172\...\.0\.1.*//' -e 's/^ 10\..*//' -e 's/^ 192.168\..*//' | cut -f1 -d'/'| xargs echo`
  DOMAIN=`hostname -d`
  HOSTNAME=`hostname | cut -f1 -d.`
}

function setup_static_public() {
  # This is the case that we have the IP address
  DOMAIN=`hostname -d`
  HOSTNAME=`hostname | cut -f1 -d.`
}

function find_disk()
{
  # Will return an unallocated disk, it will take a sorting order from largest to smallest, allowing a the caller to indicate which disk
  [[ -z "$1" ]] && whichdisk=1 || whichdisk=$1
  local readonly=`sudo parted -l | egrep -i "Warning:" | tr ' ' '\n' | egrep "/dev/" | sort -u | xargs -i echo "{}|" | xargs echo "NONE|" | tr -d ' ' | rev | cut -c2- | rev`
  diskcount=`sudo parted -l 2>&1 | egrep -v "$readonly|/dev/mapper/" | egrep -c -i 'ERROR: '`
  if [ "$diskcount" -lt "$whichdisk" ] ; then
        echo ""
  else
        # Find the disk name
        greplist=`sudo parted -l 2>&1 | egrep -v "$readonly" | egrep -i "ERROR:" |cut -f2 -d: | xargs -i echo "Disk.{}:|" | xargs echo | tr -d ' ' | rev | cut -c2- | rev`
        echo `sudo fdisk -l  | egrep "$greplist"  | sort -k5nr | head -n $whichdisk | tail -n1 | cut -f1 -d: | cut -f2 -d' '`
  fi
}

function allocate_software_disk()
{
  DISK_NAME=$(find_disk 1) # find the largest disk for formatting
  if [ ! -z "$DISK_NAME" ] ; then
     echo "Obtained disk name: $DISK_NAME"
     ONE=1
     DISK_ONE="$DISK_NAME$ONE"
     (echo n; echo p; echo " "; echo " "; echo " "; echo w;) | sudo fdisk $DISK_NAME
     sudo mkfs.ext4 $DISK_ONE
     echo "Formatting $DISK_ONE"
     sudo mkdir -p $MOUNT_POINT
     echo "Mounting formatted disk to $MOUNT_POINT"
     echo $DISK_ONE  $MOUNT_POINT   ext4    defaults    0 0 | sudo tee -a $FSTAB_FILE
     sudo mount $DISK_ONE $MOUNT_POINT
     sudo mkdir -p $REPO_DIR
     sudo mkdir -p $REPO_PUB_DIR
  fi
  # We shall just use local storage here in place of software
  [[ -e $runtimepath/mkdir.properties ]] && cat $runtimepath/mkdir.properties | egrep -v '#' | xargs -i sudo mkdir -p $REPO_DIR/{}
  [[ -e $runtimepath/repository.config ]] && sudo cp $runtimepath/repository.config $REPO_DIR/IMRepo/
}

function docker_disk()
{
  DISK_NAME=$(find_disk 1) # find the largest disk for formatting
  sudo mkdir -p /etc/docker/
  DEVICEMAPPER_SUPPORTED=$1
  if [[ $DEVICEMAPPER_SUPPORTED == "true" ]]; then
    echo "Use storage driver devicemapper."
	  # Ubuntu 14.04 fails to mount the disk because of a downlevel API, do not process the disk if present
	  if [[ ! -z "$DISK_NAME" ]] && [[ `sudo lvcreate --help | egrep wipesignatures` ]] ; then
	     echo "Obtained disk name: $DISK_NAME"
	     ONE=1
	     DOCKER_DISK_NAME=$DISK_NAME$ONE
	     (echo n; echo p; echo " "; echo " "; echo " "; echo t; echo 8e; echo w;) | sudo fdisk $DISK_NAME
	     sudo pvcreate $DOCKER_DISK_NAME
	     echo -e "{ \n\"storage-driver\": \"devicemapper\",\n\t\"storage-opts\": [\n\t\"dm.directlvm_device=$DOCKER_DISK_NAME\",\n\t\"dm.directlvm_device_force=true\"\n\t] \n}" | sudo tee /etc/docker/daemon.json
	     sudo mkdir -p /etc/lvm/profile/
	     echo -e "activation{\nthin_pool_autoextend_threshold=80\nthin_pool_autoextend_percent=20\n}\n" | sudo tee /etc/lvm/profile/docker-thinpool.profile
	     sudo mv /var/lib/docker /var/lib/docker.origin || true
	  else
	     echo -e "{\n\"storage-driver\": \"devicemapper\"\n}" | sudo tee /etc/docker/daemon.json
	  fi
  else
    echo "Use storage driver overlay2."
	  if [[ ! -z "$DISK_NAME" ]] ; then
	  	 sudo cp -au /var/lib/docker /var/lib/docker.bk
	     echo "Obtained disk name: $DISK_NAME"
	     DOCKER_MOUNT_POINT='/var/lib/docker'
	     ONE=1
	     DOCKER_DISK_NAME=$DISK_NAME$ONE
	     (echo n; echo p; echo " "; echo " "; echo " "; echo t; echo 8e; echo w;) | sudo fdisk $DISK_NAME
	     sudo mkfs.ext4 $DOCKER_DISK_NAME
	     echo $DOCKER_DISK_NAME  $DOCKER_MOUNT_POINT   ext4    defaults    0 0 | sudo tee -a $FSTAB_FILE
	     sudo mount $DOCKER_DISK_NAME  $DOCKER_MOUNT_POINT
	  fi
	  KERNEL_VERSION=`uname -r | cut -d'.' -f1`
	  PLATFORM=$(get_platform)	  
	  if [[ $KERNEL_VERSION -lt 4 ]] && [[ $PLATFORM == *"redhat"* ]]; then  	
	     echo -e "{\n\"storage-driver\": \"overlay2\",\n\"storage-opts\": [\"overlay2.override_kernel_check=true\"]\n}" | sudo tee /etc/docker/daemon.json
	  else
         echo -e "{\n\"storage-driver\": \"overlay2\"\n}" | sudo tee /etc/docker/daemon.json	  	
	  fi
  fi	   		    	  
}

function begin_message() {
  # Function is used to log the start of some configuration function
	config_name=$1
  string="============== Configure : $config_name : $TEMPLATE_TIMESTAMP =============="
  echo "`echo $string | sed 's/./=/g'`"
  echo "$string"
  echo -e "`echo $string | sed 's/[^=]/ /g'`\n"
}

function end_message() {
	string="============== Completed : $config_name, Status: $1 =============="
	echo -e "\n`echo $string | sed 's/[^=]/ /g'`"
	echo "$string"
	echo -e "`echo $string | sed 's/./=/g'`\n\n"
	config_name="unknown"
}

# In the case of retry, the script is reenterant, and can be invokes using the last set of parameters.
begin_message "Parameter File"
[[ `dirname $0 | cut -c1` == '/' ]] && runtimepath=`dirname $0/` || runtimepath=`pwd`/`dirname $0`
parmdir=$runtimepath/.advanced-runtime-config/
mkdir -p $parmdir

parmfile=$parmdir/.`basename $0`

if [[ $# -gt 0 ]] ; then
     if [[ -e $parmfile ]] ; then mv $parmfile $parmfile.`date | tr ' ' '_' | tr ':' '-'`; fi
     while [ $# -gt 0 ]
     do
         printf "%s\n" "$1" >> $parmfile
         shift
     done
fi

# Set the defaults of the script
DOCKER_REGISTRY="orpheus-local-docker.artifactory.swg-devops.com"
DOCKER_IMAGE_PATH="opencontent"

COOKBOOKS_FILE="/var/IBM-CAMHub-Open.tar"

BYOCHEF=false
OFFLINE_INSTALL=false
CHEF_ADMIN="chef-admin"
CHEF_IPADDR=""
CHEF_PEM=""
CHEF_HOST=""
CHEF_HOST_FQDN=""
CHEF_ORG="opencontent"
CHEF_VERSION=12.17.33
CHEF_CLIENT_VERSION=14.0.190
# CHEF_VERSION=12.11.1
# CHEF_CLIENT_VERSION=12.17.44
CHEF_CLIENT_PATH=''
CHEF_URL="https://packages.chef.io/files/stable/chef-server/12.11.1/ubuntu/14.04/chef-server-core_12.11.1-1_amd64.deb"
CHEF_ADMIN_PASSWORD=''
CHEF_SSL_CERT_COUNTRY=''
CHEF_SSL_CERT_STATE=''
CHEF_SSL_CERT_CITY=''

COOKBOOK_VERSION="2.0"

ENCRYPTION_PASSPHRASE=""
NFS_SERVER_IP_ADDR="format"
DOCKER_REGISTRY_USER=""
DOCKER_REGISTRY_TOKEN=""
CONFIGURATION="single-node"

SOFTWARE_REPO_IP=""
SOFTWARE_REPO_PORT="8888"
SOFTWARE_REPO_SECURE_PORT="9999"
SOFTWARE_REPO=""
SOFTWARE_REPO_FQDN=""
SOFTWARE_REPO_PASS=""
SOFTWARE_REPO_USER="repouser"
SOFTWARE_REPO_VERSION=latest
IM_REPO_PASS=""
IM_REPO_USER="repouser"

PATTERN_MGR=""
PATTERN_MGR_FQDN=""
PATTERN_MGR_VERSION=latest
PATTERN_MGR_ADMIN_TOKEN=""
PATTERN_MGR_ACCESS_TOKEN=""

CAMHUB_ACCESS_TOKEN=""
CAMHUB_HOST="github.ibm.com"
CAMHUB_ORG="CAMHub-Test"
CAMHUB_OPEN_ORG=""

UPDATE_VM_PUBLIC_KEYS="false"
CAM_PRIVATE_KEY_ENC=""
CAM_PUBLIC_KEY=""
CAM_PUBLIC_KEY_NAME=""
USER_PUBLIC_KEY=""

help=false
DEBUG=false

PRIVATE_NETWORK=`head -n1 $parmfile` # pull off the first parameter indicating this is a private network

# Parse parameters from the command line, allow a parameter name, or parameter value, - options will only consume the first character
set +o errexit
while IFS='' read -r parameter || [[ -n "$parameter" ]]; do
        [[ $parameter =~ ^-cpu|--ibm_pm_public_ssh_key_name= ]] && { CAM_PUBLIC_KEY_NAME=`echo $parameter|cut -f2- -d'='`; continue;  }; # unused
        [[ $parameter =~ ^-cpr|--ibm_pm_private_ssh_key= ]] && { CAM_PRIVATE_KEY_ENC=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cpp|--ibm_pm_public_ssh_key= ]] && { CAM_PUBLIC_KEY=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-up|--user_public_ssh_key= ]] && { USER_PUBLIC_KEY=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-dr|--docker_registry= ]] && { DOCKER_REGISTRY=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-dr|--docker_registry_path= ]] && { DOCKER_IMAGE_PATH=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-du|--docker_registry_user= ]] && { DOCKER_REGISTRY_USER=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-dt|--docker_registry_token= ]] && { DOCKER_REGISTRY_TOKEN=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-de|--docker_ee_repo= ]] && { DOCKER_EE_REPO=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-dc|--docker_configuration= ]] && { CONFIGURATION=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-bc|--byochef= ]] && { BYOCHEF=`echo $parameter|cut -f2- -d'='| tr '[:upper:]' '[:lower:]'`; continue;  };
        [[ $parameter =~ ^-of|--offline_installation= ]] && { OFFLINE_INSTALL=`echo $parameter|cut -f2- -d'='| tr '[:upper:]' '[:lower:]'`; continue;  };
        [[ $parameter =~ ^-ca|--chef_admin= ]] && { CHEF_ADMIN=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ch|--chef_host= ]] && { CHEF_HOST=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-co|--chef_org= ]] && { CHEF_ORG=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cw|--chef_admin_password= ]] && { CHEF_ADMIN_PASSWORD=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-co|--chef_ssl_cert_country= ]] && { CHEF_SSL_CERT_COUNTRY=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cs|--chef_ssl_cert_state= ]] && { CHEF_SSL_CERT_STATE=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ct|--chef_ssl_cert_city= ]] && { CHEF_SSL_CERT_CITY=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cv|--chef_version= ]] && { CHEF_VERSION=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cc|--chef_client_version= ]] && { CHEF_CLIENT_VERSION=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cl|--chef_client_path= ]] && { CHEF_CLIENT_PATH=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cu|--chef_url= ]] && { CHEF_URL=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ci|--chef_ip= ]] && { CHEF_IPADDR=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cp|--chef_pem= ]] && { CHEF_PEM=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-cf|--chef_fqdn= ]] && { CHEF_FQDN=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ik|--install_cookbooks= ]] && { INSTALL_COOKBOOKS=`echo $parameter|cut -f2- -d'='| tr '[:upper:]' '[:lower:]'`; continue;  };
        [[ $parameter =~ ^-ht|--ibm_contenthub_git_access_token= ]] && { CAMHUB_ACCESS_TOKEN=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-hh|--ibm_contenthub_git_host= ]] && { CAMHUB_HOST=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ho|--ibm_contenthub_git_organization= ]] && { CAMHUB_ORG=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-hc|--ibm_openhub_git_organization= ]] && { CAMHUB_OPEN_ORG=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ip|--ip_address= ]] && { IPADDR=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-si|--software_repo_ip= ]] && { SOFTWARE_REPO_IP=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-sr|--software_repo= ]] && { SOFTWARE_REPO=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-sp|--software_repo_port= ]] && { SOFTWARE_REPO_PORT=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-sp|--software_repo_secure_port= ]] && { SOFTWARE_REPO_SECURE_PORT=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-su|--software_repo_user= ]] && { SOFTWARE_REPO_USER=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-sp|--software_repo_pass= ]] && { SOFTWARE_REPO_PASS=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ip|--im_repo_pass= ]] && { IM_REPO_PASS=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ip|--im_repo_user= ]] && { IM_REPO_USER=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-sv|--camc-sw-repo_version= ]] && { SOFTWARE_REPO_VERSION=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pm|--pattern_mgr= ]] && { PATTERN_MGR=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pmd|--ibm_pm_admin_token= ]] && { PATTERN_MGR_ADMIN_TOKEN=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pmc|--ibm_pm_access_token= ]] && { PATTERN_MGR_ACCESS_TOKEN=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pv|--camc-pattern-manager_version= ]] && { PATTERN_MGR_VERSION=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pn|--private_network= ]] && { PRIVATE_NETWORK=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-re|--prereq_strictness= ]] && { PREREQ_STRICTNESS=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-gd|--encryption_passphrase= ]] && { ENCRYPTION_PASSPHRASE=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-n|--nfs_mount_point= ]] && { NFS_SERVER_IP_ADDR=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-tt|--template_timestamp= ]] && { TEMPLATE_TIMESTAMP=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-id|--installer_docker= ]] && { INSTALLER_DOCKER=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ic|--installer_docker_compose= ]] && { INSTALLER_DOCKER_COMPOSE=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-ri|--sw_repo_image= ]] && { SW_REPO_IMAGE=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pi|--pm_image= ]] && { PM_IMAGE=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-pp|--portable_private_ip= ]] && { PORTABLE_PRIVATE_IP=`echo $parameter|cut -f2- -d'='`; continue;  };
        [[ $parameter =~ ^-d|--debug$ ]] && { DEBUG=`echo $parameter|cut -f2- -d'='| tr '[:upper:]' '[:lower:]'`; continue;  };
        [[ $parameter =~ ^-h|--help$ ]] && { help=true;  };
        #shift
done < $parmfile
set -o errexit

if [ "$help" == true ] ; then
  help
  exit 0
fi

if [[ "$DEBUG" == "true" ]] ; then
	set -x
	export DEBUG="true"
fi
echo "[*] Template Timestamp: $TEMPLATE_TIMESTAMP"
end_message "Successful"

begin_message "Set user provided ssh key."
# Add the users key to the authorized keys on the system
[[ ! -e ~/.ssh ]] && { mkdir -p ~/.ssh/ ; chmod 700 ~/.ssh; }
echo $USER_PUBLIC_KEY >> ~/.ssh/authorized_keys
end_message "Successful"

begin_message "Requirements Checker"
# Check and install pre-requisites
chmod +x $runtimepath/prereq-check-install.sh
chmod +x $runtimepath/verify-installation.sh
chmod +x $runtimepath/copyPMConfig.sh
$runtimepath/prereq-check-install.sh -m "$PREREQ_STRICTNESS" -c "$CHEF_VERSION" -s "$CHEF_CLIENT_VERSION" -p "$CHEF_CLIENT_PATH" -u "$CAM_PUBLIC_KEY" -r "$CAM_PRIVATE_KEY_ENC" -e "$DOCKER_EE_REPO" -o "$INSTALLER_DOCKER_COMPOSE" -d "$INSTALLER_DOCKER" -b "$BYOCHEF" -f "$OFFLINE_INSTALL"
end_message "Successful"

begin_message "Disk"
FSTAB_FILE="/etc/fstab"

platform=`cat /etc/*release 2>/dev/null| egrep "^ID=" | cut -d '=' -f 2- | tr -d '"'`
MOUNT_POINT="/opt/ibm/docker/software-repo"
REPO_PUB_DIR=$MOUNT_POINT/var/swRepo/public/chef
REPO_DIR=$MOUNT_POINT/var/swRepo/private

if [[ ! -e $parmdir/mounts_setup.done ]] ; then
  case $NFS_SERVER_IP_ADDR in
    "format"|"local")
      # Allocate the software repo disk
      allocate_software_disk
      ;;
    *)
      if [[ $platform == *"ubuntu"* ]]; then
        sudo apt-get -y install nfs-common # set the common mount point
      fi
      if [[ $platform == *"redhat"* ]] || [[ $platform == *"centos"* ]]; then
        sudo yum -y install nfs-utils
      fi
      echo  "$NFS_SERVER_IP_ADDR /nfsmnt nfs4 rsize=1048576,hard,timeo=600,retrans=2,ro 0 0"  | sudo tee -a $FSTAB_FILE
      # run the mount command here, to allow for the docker container to access
      sudo mkdir -p /nfsmnt
      sudo mount /nfsmnt
      # Sym-link the software repo
      [[ ! -e $MOUNT_POINT/var/ ]] && sudo mkdir -p $MOUNT_POINT/var/
      sudo ln -s /nfsmnt/software-repo/var/swRepo/ $MOUNT_POINT/var/swRepo
  esac
  touch $parmdir/mounts_setup.done
  sudo df -Th # debug
fi
end_message "Successful"

#Install docker engine
begin_message "Docker"
if [[ ! `sudo ls /etc/docker/daemon.json 2>/dev/null` ]]; then
  sudo groupadd docker || echo ""
  sudo usermod -aG docker $USER # even though we have added the user to the group, it will not take effect on this pid/process
  # Check to see if the docker service is running
  DEVICEMAPPER_SUPPORTED=$(is_devicemapper_supported $ENCRYPTION_PASSPHRASE)
  [[ `which systemctl` ]] && { echo -n "$ENCRYPTION_PASSPHRASE" | sudo systemctl stop docker || true ; } || { echo -n "$ENCRYPTION_PASSPHRASE" | sudo service docker stop || true ; }
  docker_disk $DEVICEMAPPER_SUPPORTED
  [[ `which systemctl` ]] && { echo -n "$ENCRYPTION_PASSPHRASE" | sudo systemctl start docker || true ; } || { echo -n "$ENCRYPTION_PASSPHRASE" | sudo service docker start || true ; }
fi
end_message "Successful"

begin_message "Environment"

# The main difference between aws and other is the network and getting some information
# This line will determine if the machine is in AWS, if so, it must curl the IPAddress. Otherwise the code will sed its way thru the ip addr return removing all local, and private IPs to find the public IP
[[  "`grep amazon /sys/devices/virtual/dmi/id/bios_version`" ]] && environment="aws" || environment="other"
[[ ! "$IPADDR" = "dynamic" ]] && environment="static"
setup_"$environment"_"$PRIVATE_NETWORK"
[[ `egrep static_ip_address $parmfile` ]] && sed -i "s/--static_ip_address.*/--static_ip_address=$IPADDR/" $parmfile || echo "--static_ip_address=$IPADDR" >> $parmfile

# set values which were not provided as parameters
if [[ -z "$PORTABLE_PRIVATE_IP" ]]; then
  [[ -z "$CHEF_IPADDR" ]] && CHEF_IPADDR=$IPADDR
  [[ -z "$CHEF_HOST" ]] && CHEF_HOST="chef-server-"`echo $IPADDR | tr -d '.'`
  [[ -z "$SOFTWARE_REPO_IP" ]] && SOFTWARE_REPO_IP=$IPADDR
  [[ -z "$SOFTWARE_REPO" ]] && SOFTWARE_REPO="software-repo-"`echo $IPADDR | tr -d '.'`
  [[ -z "$PATTERN_MGR" ]] && PATTERN_MGR="pattern-"`echo $IPADDR | tr -d '.'`
else
  [[ -z "$CHEF_IPADDR" ]] && CHEF_IPADDR=$PORTABLE_PRIVATE_IP
  [[ -z "$CHEF_HOST" ]] && CHEF_HOST="chef-server-"`echo $PORTABLE_PRIVATE_IP | tr -d '.'`
  [[ -z "$SOFTWARE_REPO_IP" ]] && SOFTWARE_REPO_IP=$PORTABLE_PRIVATE_IP
  [[ -z "$SOFTWARE_REPO" ]] && SOFTWARE_REPO="software-repo-"`echo $PORTABLE_PRIVATE_IP | tr -d '.'`
  [[ -z "$PATTERN_MGR" ]] && PATTERN_MGR="pattern-"`echo $PORTABLE_PRIVATE_IP | tr -d '.'`
fi

if [[ "$CONFIGURATION" = "single-node" ]] ; then
     # If this is a local install of chef, we need to get the name of the machine from the VM, and not allow input
      CHEF_HOST=$HOSTNAME # Set the host name to the VM
fi

[[ -z "$DOMAIN" ]] && { CHEF_HOST_FQDN=$CHEF_HOST ; SOFTWARE_REPO_FQDN=$SOFTWARE_REPO ; PATTERN_MGR_FQDN=$PATTERN_MGR ; } || { CHEF_HOST_FQDN=$CHEF_HOST.$DOMAIN ; SOFTWARE_REPO_FQDN=$SOFTWARE_REPO.$DOMAIN ; PATTERN_MGR_FQDN=$PATTERN_MGR.$DOMAIN ; }

# Setup the path to images ... we support other repos
dockerhub="ibmcom"
otherhub="$DOCKER_REGISTRY/$DOCKER_IMAGE_PATH"
if [ $DOCKER_REGISTRY = "hub.docker.com" ] ; then # if the registry is docker
	DOCKER_REGISTRY_PATH="$dockerhub"
	DOCKER_REGISTRY_TOKEN="" # This line can be removed, it is a temp fix for a logging issue
else
	DOCKER_REGISTRY_PATH="$otherhub"
fi
end_message "Successful"

begin_message Chef
if [[ ! -e $parmdir/chef_setup.done ]]; then
  if [[ "$BYOCHEF" == "true" ]] && [[ -n "$CHEF_FQDN" ]] && [[ -n "$CHEF_PEM" ]] && [[ "$CHEF_IPADDR" != "$IPADDR" ]]; then
    PEM_LOC="/etc/opscode"
    echo "[*] Using provided Chef server:"
    echo "[INFO] Hostname: $CHEF_FQDN"
    echo "[INFO] IP Address: $CHEF_IPADDR"
    sudo mkdir -p $PEM_LOC
    echo $CHEF_PEM > $CHEF_ADMIN.b64
    base64 -d $CHEF_ADMIN.b64 > $CHEF_ADMIN.pem
    sudo mv $CHEF_ADMIN.b64 $PEM_LOC/$CHEF_ADMIN.b64
    sudo mv $CHEF_ADMIN.pem $PEM_LOC/$CHEF_ADMIN.pem
    CHEF_HOST_FQDN=$CHEF_FQDN
  else
    echo "[*] Configuring new Chef server"
    # This is a chef installed locally, and that the setup has not been run already
    if [[ "$CONFIGURATION" = "single-node" ]]; then
      # Install chef local on VM
      export HOSTNAME=$HOSTNAME
      export ORG_NAME=$CHEF_ORG
      export ADMIN_NAME=$CHEF_ADMIN
      export ADMIN_MAIL=donotreply@ibm.com
      export CHEF_LOG=$parmdir/chef-install.log
      [[ -z "$CHEF_ADMIN_PASSWORD" ]] && export ADMIN_PASSWORD='' || export ADMIN_PASSWORD="$CHEF_ADMIN_PASSWORD"
      [[ -z "$CHEF_SSL_CERT_COUNTRY" ]] && export SSL_CERT_COUNTRY='' || export SSL_CERT_COUNTRY="$CHEF_SSL_CERT_COUNTRY"
      [[ -z "$CHEF_SSL_CERT_STATE" ]] && export  SSL_CERT_STATE='' || export SSL_CERT_STATE="$CHEF_SSL_CERT_STATE"
      [[ -z "$CHEF_SSL_CERT_CITY" ]] && export  SSL_CERT_CITY='' || export SSL_CERT_CITY="$CHEF_SSL_CERT_CITY"
      chmod +x $runtimepath/setupchef.sh
      sudo cp $runtimepath/setupchef.sh /opt/
      sudo cp $runtimepath/chef-server.rb /opt/
      sudo -E /opt/setupchef.sh
    fi
  fi
  touch $parmdir/chef_setup.done
fi

# Move the Chef client installation file to the SW Repo public directory
CHEF_CLIENTS_FOLDER="$runtimepath/chef-clients"
if [ -d $CHEF_CLIENTS_FOLDER ]; then
  if [ -d $REPO_PUB_DIR ]; then
    echo "[*] Removing existing Chef clients"
    sudo rm -rf $REPO_PUB_DIR/*
  fi
  sudo mkdir -p $REPO_PUB_DIR
  sudo mv $CHEF_CLIENTS_FOLDER/* $REPO_PUB_DIR/
fi
end_message "Successful"

begin_message Certs
CHEF_PEM_LOC="/etc/opscode/$CHEF_ADMIN.pem"
CERTS_PATH="/opt/ibm/docker/pattern-manager/certs"
if [ ! -d $CERTS_PATH ] || [ ! "$(ls -A $CERTS_PATH)" ]; then
    echo "creating certs directory"
    sudo mkdir -p $CERTS_PATH
else
    echo "certs already exists in the path"
fi
end_message "Successful"

begin_message "Pattern Manager"
#Create SSH-Keys for Patter-Manager
CONFIG_PATH="/opt/ibm/docker/pattern-manager/config"
CONFIG_FILE="$CONFIG_PATH/config.json"
CAM_RUNTIME_KEY_FILE=$CONFIG_PATH/cam_runtime_key_`hostname`
EXISTING_CAM_PRIVATE_KEY=""
EXISTING_PORT=""
EXISTING_CHEF_IP=""
EXISTING_CHEF_PEM=""
EXISTING_CHEF_FQDN=""
UPDATE_VM_IC_KEYS=""
if [ ! -z "$CAM_PRIVATE_KEY_ENC" ] && [ -e "$CAM_RUNTIME_KEY_FILE" ]; then
    echo "Pattern manager key exists"
    EXISTING_CAM_PRIVATE_KEY=`cat $CAM_RUNTIME_KEY_FILE`
fi
if [ -e "$CONFIG_FILE" ]; then
    echo "Pattern manager config file exists"
    EXISTING_PORT=`base64 --decode $CONFIG_FILE | grep -Po '"software_repo_unsecured_port":.*?",' | cut -f2 -d' ' | cut -f2 -d\"`
    EXISTING_CHEF_ADMIN=`base64 --decode $CONFIG_FILE | grep -Po '"admin_id":.*?",' | cut -f2 -d' ' | cut -f2 -d\"`
    EXISTING_CHEF_ORG=`base64 --decode $CONFIG_FILE | grep -Po '"org":.*?",' | cut -f2 -d' ' | cut -f2 -d\"`

    if [[ "$BYOCHEF" == "true" ]]; then
      EXISTING_CHEF_IP=`base64 --decode $CONFIG_FILE | grep -Po '"ip":.*?",' | cut -f2 -d' ' | cut -f2 -d\"`
      EXISTING_CHEF_PEM=`base64 --decode $CONFIG_FILE | grep -Po '"pem":.*?",' | cut -f2 -d' ' | cut -f2 -d\"`
      EXISTING_CHEF_FQDN=`base64 --decode $CONFIG_FILE | grep -Po '"fqdn":.*?",' | cut -f2 -d' ' | cut -f2 -d\"`
      CHEF_HOST_FQDN=$CHEF_FQDN
    else
      EXISTING_CHEF_IP=$CHEF_IPADDR
      EXISTING_CHEF_PEM=$CHEF_PEM
      EXISTING_CHEF_FQDN=$CHEF_HOST_FQDN
    fi
fi

if [ ! -d $CONFIG_PATH ] || [ "$CAM_PRIVATE_KEY_ENC" != "$EXISTING_CAM_PRIVATE_KEY" ] || [ "$EXISTING_PORT" != "$SOFTWARE_REPO_PORT" ] || [ "$EXISTING_CHEF_IP" != "$CHEF_IPADDR" ] || [ "$EXISTING_CHEF_PEM" != "$CHEF_PEM" ] || [ "$EXISTING_CHEF_FQDN" != "$CHEF_HOST_FQDN" ] || [ "$EXISTING_CHEF_ADMIN" != "$CHEF_ADMIN" ] || [ "$EXISTING_CHEF_ORG" != "$CHEF_ORG" ]; then
    echo "[*] Creating Pattern Manager config directory"
    sudo mkdir -p $CONFIG_PATH

    #If we are updating the keys, get the existing ic key
    EXISTING_CAM_PUBLIC_KEY=""
    if [ -n "$EXISTING_CAM_PRIVATE_KEY" ] && [ "$CAM_PRIVATE_KEY_ENC" != "$EXISTING_CAM_PRIVATE_KEY" ] && [ -e "$CAM_RUNTIME_KEY_FILE" ]; then
        TMP_FILE=`mktemp`
        base64 --decode $CAM_RUNTIME_KEY_FILE > $TMP_FILE
        EXISTING_CAM_PUBLIC_KEY=`ssh-keygen -y -f $TMP_FILE`
        rm $TMP_FILE
    fi

    if [ "$EXISTING_PORT" != "$SOFTWARE_REPO_PORT" ] && [ -e "$CONFIG_FILE" ]; then
        TMP_FILE=`mktemp`
        ENCODED_TMP_FILE=`mktemp`
        base64 --decode $CONFIG_FILE > $TMP_FILE
        sed -i 's/\"$EXISTING_PORT\",/\"$SOFTWARE_REPO_PORT\",/' $TMP_FILE
        base64 $TMP_FILE > $ENCODED_TMP_FILE
        sudo cp $ENCODED_TMP_FILE $CONFIG_FILE
        sudo rm $TMP_FILE $ENCODED_TMP_FILE        
    fi

    #Create the Private/Public Keys for Pattern-Manager
    if [ ! -z "$CAM_PRIVATE_KEY_ENC" ]; then
      echo $CAM_PRIVATE_KEY_ENC | sudo tee $CAM_RUNTIME_KEY_FILE
    fi

    #Config File Creation Script
    chmod +x $runtimepath/crtconfig.py
    sudo python $runtimepath/crtconfig.py $PATTERN_MGR_ACCESS_TOKEN $PATTERN_MGR_ADMIN_TOKEN -c=encoded $CONFIG_PATH/cam_runtime_key_`hostname` $CHEF_PEM_LOC $CHEF_HOST_FQDN $CHEF_ORG $CHEF_IPADDR $CHEF_ADMIN $SOFTWARE_REPO_IP $SOFTWARE_REPO_PORT $CONFIG_PATH/config.json $CHEF_CLIENT_VERSION

    # Backup the generated config file
    sudo cp $CONFIG_FILE $parmdir

    #Changing created files' permissions
    sudo chmod 755 $CONFIG_PATH/cam_runtime_key_`hostname` $CONFIG_PATH/config.json

    #If we are updating keys, call the pattern manager to update the node VM's keys
    if [ ! -z "$EXISTING_CAM_PUBLIC_KEY" ]; then
      UPDATE_VM_PUBLIC_KEYS="true"
    fi
else
    echo "[*] Pattern Manager configuration file already exists in the path"
fi
end_message "Successful"

begin_message "Software Repository"
AUTH_FILE_PATH="/opt/ibm/docker/software-repo/etc/nginx/auth"
if [[ ! -z "$SOFTWARE_REPO_PASS" ]];  then
    echo "creating Auth file directory and auth file"
    sudo mkdir -p $AUTH_FILE_PATH
    echo -n "$SOFTWARE_REPO_USER:" | sudo tee $AUTH_FILE_PATH/.secure_softwarerepo
    echo $SOFTWARE_REPO_PASS | openssl passwd -apr1 -stdin | sudo tee --append $AUTH_FILE_PATH/.secure_softwarerepo
else
    echo "Software Repository remains unchanged"
fi

AUTH_CERT_PATH="/opt/ibm/docker/software-repo/etc/nginx/server-certs/"
if [[ ! -s $AUTH_CERT_PATH/secure_swrepo.key ]] ; then
   echo "create Cert file directory, and move the files"
   sudo mkdir -p $AUTH_CERT_PATH
else
  echo "Software Repository Certificates already exist."
fi
end_message "Successful"

begin_message "Docker images"
REPOSERVER_FSTAB_FILE="/opt/ibm/docker/software-repo/etc/fstab"
echo "# Empty FSTAB File as Mount IP Address as passed as N/A" | sudo tee $REPOSERVER_FSTAB_FILE

# Based on the CONFIGURATION Build the docker-compose file
if [ "$CONFIGURATION" = "single-node" ] ; then
  cp $runtimepath/infra-docker-compose.tmpl $runtimepath/docker-compose.yml
  cat $runtimepath/camc-sw-repo.tmpl >> $runtimepath/docker-compose.yml
  cat $runtimepath/camc-pattern-manager.tmpl >> $runtimepath/docker-compose.yml
else
  cp $runtimepath/infra-docker-compose.tmpl $runtimepath/docker-compose.yml
  cat $runtimepath/$CONFIGURATION.tmpl >> $runtimepath/docker-compose.yml
fi

sed -i.bak "s|\$CHEF_ADMIN|$CHEF_ADMIN|; \
    s|\$CHEF_ORG|$CHEF_ORG|; \
    s|\$CHEF_HOST_FQDN|$CHEF_HOST_FQDN|; \
    s|\$CHEF_IPADDR|$CHEF_IPADDR|; \
    s|\$CHEF_VERSION|$CHEF_VERSION|; \
    s|\$SOFTWARE_REPO_IP|$SOFTWARE_REPO_IP|; \
    s|\$SOFTWARE_REPO_FQDN|$SOFTWARE_REPO_FQDN|; \
    s|\$SOFTWARE_REPO_PORT|$SOFTWARE_REPO_PORT|g; \
    s|\$SOFTWARE_REPO_SECURE_PORT|$SOFTWARE_REPO_SECURE_PORT|g; \
    s|\$SOFTWARE_REPO_VERSION|$SOFTWARE_REPO_VERSION|; \
    s|\$PATTERN_MGR_FQDN|$PATTERN_MGR_FQDN|; \
    s|\$PATTERN_MGR_VERSION|$PATTERN_MGR_VERSION|; \
    s|\$DOCKER_REGISTRY_PATH|$DOCKER_REGISTRY_PATH|; \
    s|\$DOCKER_REGISTRY|$DOCKER_REGISTRY|" \
    $runtimepath/docker-compose.yml

# Update the pattern manager to load the software repo
cp $runtimepath/load.tmpl $runtimepath/load.json
# If there is not an access token remove from the load json, there may be cases where we want to pull from the private repo
if [[ -z $CAMHUB_ACCESS_TOKEN ]] ; then
    sed -i "/\$CAMHUB_ACCESS_TOKEN/d" $runtimepath/load.json
fi
sed -i "s|\$CAMHUB_ACCESS_TOKEN|$CAMHUB_ACCESS_TOKEN|; \
        s|\$CAMHUB_HOST|$CAMHUB_HOST|; \
        s|\$CAMHUB_ORG|$CAMHUB_ORG|; \
        s|\$COOKBOOK_VERSION|$COOKBOOK_VERSION|" $runtimepath/load.json


end_message "Successful"

begin_message "Docker Start"
docker_compose_CMD=$(echo `which docker-compose`)
if [ ! -z "$DOCKER_REGISTRY_TOKEN" ] ; then
  # A docker token was passed in on the call, generate the file
  dockerdir=`eval echo ~`/.docker
  [[ ! -e "$dockerdir" ]] && mkdir $dockerdir
  echo -e '{\n\t"auths": {\n\t\t"$DOCKER_REGISTRY": {\n\t\t\t"auth": "$DOCKER_REGISTRY_TOKEN"\n\t\t}\n\t}\n}' | sed "s|\"\$DOCKER_REGISTRY\"|\"$DOCKER_REGISTRY\"|; s|\"\$DOCKER_REGISTRY_TOKEN\"|\"$DOCKER_REGISTRY_TOKEN\"|" > ~/.docker/config.json
fi
# The sudo su $USER is to become the user which includes the inclusion in the docker group
sudo su $USER -c "$docker_compose_CMD -f $runtimepath/docker-compose.yml down" # shut down incase were are re-enterant

# Check if images exist locally or can be loaded, if not, download them
if [[ -n $PM_IMAGE ]]; then
  # Preload docker images
  echo "[*] Pattern Manager image provided"
  load_docker_image $PM_IMAGE pattern-manager
fi

if [[ -n $SW_REPO_IMAGE ]]; then
  echo "[*] Software Repository image provided"
  load_docker_image $SW_REPO_IMAGE sw-repository
fi

if [[ "$(sudo docker images -q $DOCKER_REGISTRY_PATH/camc-pattern-manager 2> /dev/null)" != "" ]] && [[ "$(sudo docker images -q $DOCKER_REGISTRY_PATH/camc-sw-repo 2> /dev/null)" != "" ]]; then
  echo "[*] Docker images found"
else
  echo "[*] Downloading Docker images"
  sudo su $USER -c "$docker_compose_CMD -f $runtimepath/docker-compose.yml pull > /dev/null"
fi
sudo su $USER -c "$docker_compose_CMD -f $runtimepath/docker-compose.yml up -d"
end_message "Successful"

begin_message "Cookbooks"
# chef-user who is not defined at the OS level needs write access to the pattern folder.
sudo chmod o+rw /var/log/ibm/docker/pattern-manager/
if [[ "$INSTALL_COOKBOOKS" == "true" ]]; then
  if [[ -e $COOKBOOKS_FILE ]]; then
    echo "[*] Copying cookbooks to Pattern Manager"
    COOKBOOKS_TAR=$(basename $COOKBOOKS_FILE)
    docker exec camc-pattern-manager mkdir /var/cookbooks
    docker cp $COOKBOOKS_FILE camc-pattern-manager:/var/cookbooks/
    docker exec camc-pattern-manager tar -xvf /var/cookbooks/$COOKBOOKS_TAR -C /var/cookbooks > /dev/null
    echo "[*] Loading cookbooks"
    curl --request POST -k -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization:Bearer $PATTERN_MGR_ACCESS_TOKEN" https://localhost:5443/v1/upload/chef -d '{"cookbooks":"True","roles":"True","source_repos":"file:///var/cookbooks/", "repos":"cookbook_*"}'
  else
    if [[ $CONFIGURATION = "single-node" ]] ; then
    	# For sure on the single-node, we want to wait for the docker chef to start, then restart the pattern-manager
    	# for the other configruations, the restart is handled in the templated, waiting for the pem file to be written
    	pemfile="/opt/ibm/docker/chef-server/etc/opscode/$CHEF_ADMIN.pem"
    	count=0
    	sleep 20 # The chef server needs a little time before servicing requests
    	# Call to the pattern manager for the initialization of the cookbooks
    	echo "Update the cookbooks on chef server"
    	echo curl --write-out %{http_code} --output /dev/null --request POST -k -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization:Bearer $PATTERN_MGR_ACCESS_TOKEN" https://localhost:5443/v1/upload/chef/git_hub --data @$runtimepath/load.json
    	response=`curl --write-out %{http_code} --output /dev/null --request POST -k -H "Accept: application/json" -H "Content-Type: application/json" -H "Authorization:Bearer $PATTERN_MGR_ACCESS_TOKEN" https://localhost:5443/v1/upload/chef/git_hub --data @$runtimepath/load.json`
    	echo "Return from the curl command : $response"
      if [ $response != 200 ]; then
        if [[ "$BYOCHEF" == "true" ]]; then
          echo "[ERROR] There was an error communicating with the provided Chef Server. Please check the provided IP address, FQDN and PEM file and try again."
        else
          echo "[ERROR] There was an error communicating with the installed Chef server."
        fi
        exit 1
      fi
    	curl -k -H "Authorization:Bearer $PATTERN_MGR_ACCESS_TOKEN" -X GET https://localhost:5443/v1/info/chef
    fi
  fi
else
  echo "[*] Skipping installation of cookbooks"
fi
if [[ "$UPDATE_VM_PUBLIC_KEYS" == "true" ]] ; then
  echo "Updating the authorized_keys on existing deployed VMs"
  curl -k -H "Authorization:Bearer $PATTERN_MGR_ADMIN_TOKEN" -X POST -d '{"new_public_key": "$CAM_PUBLIC_KEY", "old_public_key": "$EXISTING_CAM_PUBLIC_KEY"}' https://localhost:5443/v1/admin/config/reload
fi
end_message "Successful"

begin_message "Docker Containers"
sudo docker ps -a
end_message "Successful"

begin_message "Verify Installation"
$runtimepath/verify-installation.sh
end_message "Successful"

#clean up
[[ ! "$DEBUG" = "true" ]] && { sed -i -e '/^--docker_registry_token=/d' -e '/^--software_repo_pass=/d' -e '/^--im_repo_pass=/d' -e '/^--ibm_pm_private_ssh_key=/d' -e '/^--ibm_contenthub_git_access_token=/d' -e '/^--encryption_passphrase=/d'  $parmfile ; }
EndOfFile

    destination = "./advanced-content-runtime/launch-docker-compose.sh"
  }
} # End of Resource

resource "null_resource" "call_launcher" {
  depends_on = ["aws_instance.singlenode"]

  triggers {
    private_key_changed      = "${var.ibm_pm_private_ssh_key}"
    public_key_changed       = "${var.ibm_pm_public_ssh_key}"
    pm_key_name_changed      = "${var.ibm_pm_public_ssh_key_name}"
    repo_pass_changed        = "${var.ibm_sw_repo_password}"
    repo_port_changed        = "${var.ibm_sw_repo_port}"
    repo_secure_port_changed = "${var.ibm_sw_repo_secure_port}"
    chef_fqdn_changed        = "${var.chef_fqdn}"
    chef_ip_changed          = "${var.chef_ip}"
    chef_pem_changed         = "${var.chef_pem}"
    chef_org_changed         = "${var.chef_org}"
    chef_admin_changed       = "${var.chef_admin}"
    chef_client_changed      = "${var.chef_client_version}"
    cr_instance_ids          = "${join(",", aws_instance.singlenode.*.id)}"
  }

  connection {
    host                = "${var.network_visibility == "public" ? aws_instance.singlenode.public_ip : aws_instance.singlenode.private_ip}"
    type                = "ssh"
    user                = "${var.aws_userid}"
    private_key         = "${tls_private_key.ssh.private_key_pem}"
    bastion_host        = "${var.bastion_host}"
    bastion_user        = "${var.bastion_user}"
    bastion_private_key = "${ length(var.bastion_private_key) > 0 ? base64decode(var.bastion_private_key) : var.bastion_private_key}"
    bastion_port        = "${var.bastion_port}"
    bastion_host_key    = "${var.bastion_host_key}"
    bastion_password    = "${var.bastion_password}"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 775 ./advanced-content-runtime/launch-docker-compose.sh",
      "chmod 775 ./advanced-content-runtime/image-upgrade.sh",
      "bash -c \"./advanced-content-runtime/launch-docker-compose.sh ${var.network_visibility} --docker_registry_token='\"'${var.docker_registry_token}'\"' --nfs_mount_point='\"'${var.nfs_mount}'\"' --encryption_passphrase='\"'${var.encryption_passphrase}'\"' --software_repo_user='\"'${var.ibm_sw_repo_user}'\"' --software_repo_pass='\"'${var.ibm_sw_repo_password}'\"' --im_repo_user='\"'${var.ibm_im_repo_user_hidden}'\"' --im_repo_pass='\"'${var.ibm_im_repo_password_hidden}'\"'  --chef_host=chef-server --software_repo=software-repo --software_repo_port='\"'${var.ibm_sw_repo_port}'\"' --software_repo_secure_port='\"'${var.ibm_sw_repo_secure_port}'\"' --pattern_mgr=pattern --ibm_contenthub_git_host='\"'${var.ibm_contenthub_git_host}'\"' --ibm_contenthub_git_organization='\"'${var.ibm_contenthub_git_organization}'\"' --ibm_openhub_git_organization='\"'${var.ibm_openhub_git_organization}'\"' --chef_org='\"'${var.chef_org}'\"' --chef_admin='\"'${var.chef_admin}'\"' --chef_fqdn='\"'${var.chef_fqdn}'\"' --chef_ip='\"'${var.chef_ip}'\"' --chef_pem='\"'${var.chef_pem}'\"' --docker_registry='\"'${var.docker_registry}'\"' --chef_version=${var.chef_version} --chef_client_version='\"'${var.chef_client_version}'\"' --chef_client_path='\"'${var.chef_client_path}'\"' --ibm_pm_access_token='\"'${var.ibm_pm_access_token}'\"' --ibm_pm_admin_token='\"'${var.ibm_pm_admin_token}'\"' --camc-sw-repo_version='\"'${var.docker_registry_camc_sw_repo_version}'\"' --docker_ee_repo='\"'${var.docker_ee_repo}'\"' --camc-pattern-manager_version='\"'${var.docker_registry_camc_pattern_manager_version}'\"' --docker_configuration=single-node --ibm_pm_public_ssh_key_name='\"'${var.ibm_pm_public_ssh_key_name}'\"' --ibm_pm_private_ssh_key='\"'${var.ibm_pm_private_ssh_key}'\"' --ibm_pm_public_ssh_key='\"'${var.ibm_pm_public_ssh_key}'\"' --user_public_ssh_key='\"'${var.user_public_ssh_key}'\"' --prereq_strictness='\"'${var.prereq_strictness}'\"' --ip_address='\"'${var.ipv4_address}'\"' --template_timestamp='\"'${var.template_timestamp_hidden}'\"' --installer_docker='\"'${var.installer_docker}'\"' --installer_docker_compose='\"'${var.installer_docker_compose}'\"' --sw_repo_image='\"'${var.sw_repo_image}'\"' --pm_image='\"'${var.pm_image}'\"' --template_debug='\"'${var.template_debug}'\"' --portable_private_ip='\"'${var.portable_private_ip}'\"' --byochef='\"'${var.byochef}'\"' --offline_installation='\"'${var.offline_installation}'\"' --install_cookbooks='\"'${var.install_cookbooks}'\"'\"",
    ]
  }
} # End of null_resource

### AWS output variables
output "private_key" {
  value = "${tls_private_key.ssh.private_key_pem}"
}

output "public_key" {
  value = "${tls_private_key.ssh.public_key_pem}"
}

output "ip_address" {
  value = "${var.network_visibility == "public" ? "${aws_instance.singlenode.public_ip}" : "${aws_instance.singlenode.private_ip}"}"
}

output "ibm_sw_repo" {
  value = "https://${var.network_visibility == "public" ? "${aws_instance.singlenode.public_ip}" : "${aws_instance.singlenode.private_ip}"}:${var.ibm_sw_repo_secure_port}"
}

output "ibm_im_repo" {
  value = "https://${var.network_visibility == "public" ? "${aws_instance.singlenode.public_ip}" : "${aws_instance.singlenode.private_ip}"}:${var.ibm_sw_repo_secure_port}/IMRepo"
}

output "ibm_pm_service" {
  value = "https://${var.network_visibility == "public" ? "${aws_instance.singlenode.public_ip}" : "${aws_instance.singlenode.private_ip}"}:5443"
}

output "runtime_domain" {
  value = "${var.network_visibility == "public" ? replace("${aws_instance.singlenode.public_dns}", "/^[^.]*./", "") : replace("${aws_instance.singlenode.private_dns}", "/^[^.]*./", "")}"
}

output "aws_ami" {
  value = "${data.aws_ami.ubuntu_1604.id}"
}

output "ibm_im_repo_user" {
  value = "${var.ibm_sw_repo_user}"
}

output "ibm_im_repo_password" {
  value = "${var.ibm_sw_repo_password}"
}

output "template_timestamp" {
  value = "2018-06-13 19:02:50"
}

### End AWS output variables
output "docker_registry_token" {
  value = "${var.docker_registry_token}"
}

output "docker_registry" {
  value = "${var.docker_registry}"
}

output "docker_registry_camc_pattern_manager_version" {
  value = "${var.docker_registry_camc_pattern_manager_version}"
}

output "docker_registry_camc_sw_repo_version" {
  value = "${var.docker_registry_camc_sw_repo_version}"
}

output "ibm_sw_repo_user" {
  value = "${var.ibm_sw_repo_user}"
}

output "ibm_sw_repo_password" {
  value = "${var.ibm_sw_repo_password}"
}

output "ibm_sw_repo_port" {
  value = "${var.ibm_sw_repo_port}"
}

output "ibm_sw_repo_secure_port" {
  value = "${var.ibm_sw_repo_secure_port}"
}

output "chef_client_version" {
  value = "${var.chef_client_version}"
}

output "chef_client_path" {
  value = "${var.chef_client_path}"
}

output "ibm_im_repo_user_hidden" {
  value = "${var.ibm_im_repo_user_hidden}"
}

output "ibm_im_repo_password_hidden" {
  value = "${var.ibm_im_repo_password_hidden}"
}

output "ibm_contenthub_git_host" {
  value = "${var.ibm_contenthub_git_host}"
}

output "ibm_contenthub_git_organization" {
  value = "${var.ibm_contenthub_git_organization}"
}

output "ibm_openhub_git_organization" {
  value = "${var.ibm_openhub_git_organization}"
}

output "offline_installation" {
  value = "${var.offline_installation}"
}

output "docker_ee_repo" {
  value = "${var.docker_ee_repo}"
}

output "chef_org" {
  value = "${var.chef_org}"
}

output "chef_admin" {
  value = "${var.chef_admin}"
}

output "byochef" {
  value = "${var.byochef}"
}

output "install_cookbooks" {
  value = "${var.install_cookbooks}"
}

output "chef_fqdn" {
  value = "${var.chef_fqdn}"
}

output "chef_ip" {
  value = "${var.chef_ip}"
}

output "chef_pem" {
  value = "${var.chef_pem}"
}

output "ibm_pm_access_token" {
  value = "${var.ibm_pm_access_token}"
}

output "ibm_pm_admin_token" {
  value = "${var.ibm_pm_admin_token}"
}

output "ibm_pm_public_ssh_key_name" {
  value = "${var.ibm_pm_public_ssh_key_name}"
}

output "ibm_pm_private_ssh_key" {
  value = "${var.ibm_pm_private_ssh_key}"
}

output "ibm_pm_public_ssh_key" {
  value = "${var.ibm_pm_public_ssh_key}"
}

output "user_public_ssh_key" {
  value = "${var.user_public_ssh_key}"
}

output "template_timestamp_hidden" {
  value = "${var.template_timestamp_hidden}"
}

output "template_debug" {
  value = "${var.template_debug}"
}

output "aws_userid" {
  value = "${var.aws_userid}"
}

output "nfs_mount" {
  value = "${var.nfs_mount}"
}

output "portable_private_ip" {
  value = "${var.portable_private_ip}"
}

output "runtime_hostname" {
  value = "${var.runtime_hostname}"
}

output "encryption_passphrase" {
  value = "${var.encryption_passphrase}"
}

output "ipv4_address" {
  value = "${var.ipv4_address}"
}

output "aws_security_group" {
  value = "${var.aws_security_group}"
}

output "aws_subnet" {
  value = "${var.aws_subnet}"
}

output "aws_instance_type" {
  value = "${var.aws_instance_type}"
}

output "aws_region" {
  value = "${var.aws_region}"
}

output "network_visibility" {
  value = "${var.network_visibility}"
}

output "prereq_strictness" {
  value = "${var.prereq_strictness}"
}

output "installer_docker" {
  value = "${var.installer_docker}"
}

output "installer_docker_compose" {
  value = "${var.installer_docker_compose}"
}

output "sw_repo_image" {
  value = "${var.sw_repo_image}"
}

output "pm_image" {
  value = "${var.pm_image}"
}

output "chef_version" {
  value = "${var.chef_version}"
}

output "ibm_stack_name" {
 value = "${var.ibm_stack_name}"
}
