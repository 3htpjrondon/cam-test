resource "null_resource" "install_ansible_dependsOn" {
  provisioner "local-exec" {
    command = "echo The dependsOn output for Single Node is ${var.dependsOn}"
  }
}

resource "null_resource" "install_ansible" {
  depends_on = ["null_resource.install_ansible_dependsOn"]

  # Specify the ssh connection
  connection {
    type        = "ssh"
    user        = "${var.vm_os_user}"
    password    = "${var.vm_os_password}"
    private_key = "${var.private_key}"
    host        = "${var.vm_ipv4_address_list[count.index]}"
  }

  # Create the installation script
  provisioner "file" {
    content = <<EOF
#!/bin/bash
LOGFILE="/var/log/install_ansible.log"
retryInstall () {
  n=0
  max=5
  command=$1
  while [ $n -lt $max ]; do
    $command && break
    let n=n+1
    if [ $n -eq $max ]; then
      echo "---Exceed maximal number of retries---"
      exit 1
    fi
    sleep 15
  done
}

UNAME=$(uname | tr "[:upper:]" "[:lower:]")
PLATFORM=""
if [ "$UNAME" == "linux" ]; then
    if [ -f /etc/lsb-release -o -d /etc/lsb-release.d ]; then
        PLATFORM=$(lsb_release -i | cut -d: -f2 | sed s/'^\t'// | tr "[:upper:]" "[:lower:]" )
    else
        PLATFORM=$(ls -d /etc/[A-Za-z]*[_-][rv]e[lr]* | grep -v "lsb" | cut -d'/' -f3 | cut -d'-' -f1 | cut -d'_' -f1 | tr "[:upper:]" "[:lower:]")
    fi
fi
string="[*] Checking installation of: ansible"
line="......................................................................."
if [[ $PLATFORM == *"ubuntu"* ]]; then
    wait_apt_lock
    sudo apt-get update
    wait_apt_lock
    echo "---start installing Ansible---" | tee -a $LOGFILE 2>&1
    retryInstall "apt-get install -y ansible" >> $LOGFILE 2>&1 || { echo "---Failed to install Ansible---" | tee -a $LOGFILE; exit 1; }
    echo "---finish installing Ansible---" | tee -a $LOGFILE 2>&1
  else
    echo "---start installing Ansible---" | tee -a $LOGFILE 2>&1
    retryInstall "yum install -y ansible" >> $LOGFILE 2>&1 || { echo "---Failed to install Ansible---" | tee -a $LOGFILE; exit 1; }
    echo "---finish installing Ansible---" | tee -a $LOGFILE 2>&1
  fi
EOF

    destination = "/tmp/installation.sh"
  }

  # Execute the script remotely
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/installation.sh; bash /tmp/installation.sh",
    ]
  }
}

resource "null_resource" "install_ansible_finished" {
  depends_on = ["null_resource.install_ansible"]

  provisioner "local-exec" {
    command = "echo 'Ansible Binaries installed'"
  }
}
