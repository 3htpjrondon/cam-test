#!/bin/bash

ubuntu_install(){
  # attempt to retry apt-get update until cloud-init gives up the apt lock
  until apt-get update; do
    sleep 2
  done

  until apt-get install -y \
    curl \
    unzip \
    python; do
    sleep 2
  done
}

crlinux_install() {
  until yum install -y \
    curl \
    unzip; do
    sleep 2
  done
}

awscli_install() {
  # already installed, exit
  export awscli=`which aws`

  if [ ! -z "${awscli}" ]; then
    ${awscli} --version
    return 0
  fi

  echo "installing aws cli ..."
  cd /tmp
  rm -rf awscli-bundle*
  curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
  unzip awscli-bundle.zip
  ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
  export awscli=/usr/local/bin/aws
}

while getopts ":c:s:" arg; do
  case "${arg}" in
    c)
      s3_config_bucket=${OPTARG}
      ;;
    s)
      s3_install_scripts=${OPTARG}
      ;;
  esac
done

#Find Linux Distro
if grep -q -i ubuntu /etc/*release; then
  OSLEVEL=ubuntu
else
  OSLEVEL=other
fi
echo "Operating System is $OSLEVEL"

# pre-reqs
if [ "$OSLEVEL" == "ubuntu" ]; then
  ubuntu_install
else
  crlinux_install
fi

awscli_install
mkdir -p /tmp/icp_scripts
for script in ${s3_install_scripts}; do
  echo "Retrieving install script s3://${s3_config_bucket}/scripts/${script} ..."
  script_name=`basename ${script}`
  ${awscli} s3 cp s3://${s3_config_bucket}/scripts/${script} /tmp/icp_scripts/${script_name}
  chmod +x /tmp/icp_scripts/${script_name}
done
