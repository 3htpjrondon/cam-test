##############################################
## Cloud-init definitions to be used when creating instances
##############################################

## Some common definitions that can be reused with different node types
data "template_file" "common_config" {
  template = <<EOF
  #cloud-config
  package_upgrade: true
  packages:
    - cifs-utils
    - nfs-common
    - python-yaml
  users:
    - default
    - name: ${var.admin_username}
      groups: [ wheel ]
      sudo: [ "ALL=(ALL) NOPASSWD:ALL" ]
      shell: /bin/bash
      ssh-authorized-keys:
        - ${tls_private_key.installkey.public_key_openssh}
EOF
}

data "template_file" "docker_disk" {
  template = <<EOF
#!/bin/bash
sudo mkdir -p /var/lib/docker
# Check if we have a separate docker disk, or if we should use temporary disk
if [ -e /dev/sdc ]; then
  sudo parted -s -a optimal /dev/disk/azure/scsi1/lun1 mklabel gpt -- mkpart primary xfs 1 -1
  sudo partprobe
  sudo mkfs.xfs -n ftype=1 /dev/disk/azure/scsi1/lun1-part1
  echo "/dev/disk/azure/scsi1/lun1-part1  /var/lib/docker   xfs  defaults   0 0" | sudo tee -a /etc/fstab
else
  # Use the temporary disk
  sudo umount /mnt
  sudo sed -i 's|/mnt|/var/lib/docker|' /etc/fstab
fi
sudo mount /var/lib/docker
EOF
}

data "template_file" "etcd_disk" {
  template = <<EOF
#!/bin/bash
sudo mkdir -p /var/lib/etcd
sudo mkdir -p /var/lib/etcd-wal
etcddisk=$(ls /dev/disk/azure/*/lun2)
waldisk=$(ls /dev/disk/azure/*/lun3)

sudo parted -s -a optimal $etcddisk mklabel gpt -- mkpart primary xfs 1 -1
sudo parted -s -a optimal $waldisk mklabel gpt -- mkpart primary xfs 1 -1
sudo partprobe

sudo mkfs.xfs -n ftype=1 $etcddisk-part1
sudo mkfs.xfs -n ftype=1 $waldisk-part1
echo "$etcddisk-part1  /var/lib/etcd   xfs  defaults   0 0" | sudo tee -a /etc/fstab
echo "$waldisk-part1  /var/lib/etcd-wal   xfs  defaults   0 0" | sudo tee -a /etc/fstab

sudo mount /var/lib/etcd
sudo mount /var/lib/etcd-wal
EOF
}

data "template_file" "load_tarball" {
  template = <<EOF
#!/bin/bash
image_file="$(basename $${tarball})"

cd /tmp
if [[ -z /tmp/azcopy.tar.gz ]]
then
  echo "package azcopy.tar.gz already installed."
else  
	wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64
	tar -xf azcopy.tar.gz
	sudo ./install.sh
fi

azcopy --source $${tarball} --source-key $${key} --destination /tmp/$image_file

#mkdir -p /opt/ibm/cluster/images
#azcopy --source $${tarball} --source-key $${key} --destination /opt/ibm/cluster/images/$image_file

#sudo cp /opt/ibm/cluster/images/$image_file /tmp/$image_file
#azcopy --source $${tarball} --source-key $${key} --destination /tmp/$image_file

#sudo chown $${user} /opt/ibm/cluster/images/$image_file
#chmod +x /opt/ibm/cluster/images/$image_file

sudo chown $${user} /tmp/$image_file
chmod +x /tmp/$image_file

mkdir -p /opt/ibm/
sudo touch /opt/ibm/.imageload_complete

EOF

  vars {
    tarball = "${var.image_location}"
    key     = "${var.image_location_key}"
    user     = "${var.admin_username}"    
  }
}

data "template_file" "load_tarball_complete" {
  template = <<EOF
#!/bin/bash

sudo mkdir -p /opt/ibm/
sudo touch /opt/ibm/.imageload_complete

EOF
}


data "template_file" "docker_load_tarball" {
  template = <<EOF
#!/bin/bash
image_file="$(basename $${tarball})"

cd /tmp

if [[ -z /tmp/azcopy.tar.gz ]]
then
  echo "package azcopy.tar.gz already installed."
else  
	wget -O azcopy.tar.gz https://aka.ms/downloadazcopylinux64
	tar -xf azcopy.tar.gz
	sudo ./install.sh
fi

mkdir -p /tmp/icp-docker
azcopy --source $${tarball} --source-key $${key} --destination /tmp/icp-docker/icp-docker.bin
chmod a+x /tmp/icp-docker/icp-docker.bin
chown $${user} /tmp/icp-docker/icp-docker.bin

EOF

  vars {
    tarball = "${var.docker_image_location}"
    key     = "${var.image_location_key}"
    user     = "${var.admin_username}"
    
  }
}

data "template_file" "master_config" {
  template = <<EOF
#cloud-config
write_files:
- path: /etc/smbcredentials/icpregistry.cred
  content: |
    username=$${username}
    password=$${password}
mounts:
- [ ${element(split(":", azurerm_storage_share.icpregistry.url), 1)}, /var/lib/registry, cifs, "nofail,credentials=/etc/smbcredentials/icpregistry.cred,dir_mode=0777,file_mode=0777,serverino" ]

EOF

  vars {
    username= "${azurerm_storage_account.infrastructure.name}"
    password= "${azurerm_storage_account.infrastructure.primary_access_key}"
    docker_tarball = "${var.docker_image_location != "" ? "var.docker_image_location" : ""}"    
    tarball = "${var.image_location}"
    key     = "${var.image_location_key}"
  }
    
}

data "template_cloudinit_config" "bootconfig" {
  gzip          = true
  base64_encode = true

  # Create the icpdeploy user which we will use during initial deployment of ICP.
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.common_config.rendered}"
  }

  # Setup the docker disk
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker_disk.rendered}"
  }

  # Load the Docker Image
  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_image_location != "" ? data.template_file.docker_load_tarball.rendered : "#!/bin/bash"}"
  }

  # Load the ICP Images
  part {
    content_type = "text/x-shellscript"
    content      = "${var.image_location != "" ? data.template_file.load_tarball.rendered : data.template_file.load_tarball_complete.rendered}"
  }

}

## Definitions for each VM type
data "template_cloudinit_config" "masterconfig" {
  gzip          = true
  base64_encode = true

  # Create the icpdeploy user which we will use during initial deployment of ICP.
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.common_config.rendered}"
  }

  # Setup the docker disk
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker_disk.rendered}"
  }

  # Setup the etcd disks
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.etcd_disk.rendered}"
  }

  # Setup the icp registry share
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.master_config.rendered}"
  }

  # Load the Docker Image
  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_image_location != "" ? data.template_file.docker_load_tarball.rendered : "#!/bin/bash"}"
  }

  # Load the ICP Images
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.load_tarball.rendered}"
  }
}


data "template_cloudinit_config" "workerconfig" {
  gzip          = true
  base64_encode = true

  # Create the icpdeploy user which we will use during initial deployment of ICP.
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.common_config.rendered}"
  }

  # Setup the docker disk
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker_disk.rendered}"
  }
  
  # Load the Docker Image
  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_image_location != "" ? data.template_file.docker_load_tarball.rendered : "#!/bin/bash"}"
  }
  
}

data "template_cloudinit_config" "proxyconfig" {
  gzip          = true
  base64_encode = true

  # Create the icpdeploy user which we will use during initial deployment of ICP.
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.common_config.rendered}"
  }

  # Setup the docker disk
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker_disk.rendered}"
  }
  
  # Load the Docker Image
  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_image_location != "" ? data.template_file.docker_load_tarball.rendered : "#!/bin/bash"}"
  }
  
}

data "template_cloudinit_config" "vaconfig" {
  gzip          = true
  base64_encode = true

  # Create the icpdeploy user which we will use during initial deployment of ICP.
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.common_config.rendered}"
  }

  # Setup the docker disk
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker_disk.rendered}"
  }
  
  # Load the Docker Image
  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_image_location != "" ? data.template_file.docker_load_tarball.rendered : "#!/bin/bash"}"
  }
  
}

data "template_cloudinit_config" "mgmtconfig" {
  gzip          = true
  base64_encode = true

  # Create the icpdeploy user which we will use during initial deployment of ICP.
  part {
    content_type = "text/cloud-config"
    content      =  "${data.template_file.common_config.rendered}"
  }

  # Setup the docker disk
  part {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.docker_disk.rendered}"
  }
  
  # Load the Docker Image
  part {
    content_type = "text/x-shellscript"
    content      = "${var.docker_image_location != "" ? data.template_file.docker_load_tarball.rendered : "#!/bin/bash"}"
  }
  
}
