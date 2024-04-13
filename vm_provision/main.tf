terraform {
  required_version = ">= 1.5" 
  required_providers {
    virtualbox = {
      source = "terra-farm/virtualbox"
      version = "0.2.2-alpha.1"
    }

    time = {
      source = "hashicorp/time"
      version = "0.11.1"
    }
  }
}

resource "virtualbox_vm" "master" {
  count = 1
  name      = "master"
  #image     = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20210916.0.0/providers/virtualbox.box"
  image = "${path.module}/ubuntu.box"
  cpus      = 2
  memory    = "2048 mib"

  network_adapter {
    type           = "bridged"
    host_interface = "Intel(R) Wi-Fi 6E AX211 160MHz"
  }
  
  provisioner "file" {
    source      = "${path.module}/../env/ssh-key.pub"
    destination = "/tmp/ssh-key.pub"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /root/.ssh",
      "sudo mv /tmp/ssh-key.pub /root/.ssh/authorized_keys",
      "sudo chmod 600 /root/.ssh/authorized_keys"
    ]
  }

  connection {
    type        = "ssh"
    user        = "vagrant"
    password = "vagrant"
    #private_key = file("${path.module}/../env/ssh-key.pub")
    host        = self.network_adapter[0].ipv4_address
  }
}

resource "virtualbox_vm" "worker" {
  count      = 2
  name       = "worker-${count.index}"
  #image     = "https://app.vagrantup.com/ubuntu/boxes/bionic64/versions/20210916.0.0/providers/virtualbox.box"
  image = "${path.module}/ubuntu.box"
  cpus      = 2
  memory    = "2048 mib"
  
  network_adapter {
    type           = "bridged"
    host_interface = "Intel(R) Wi-Fi 6E AX211 160MHz"
  }
  
  provisioner "file" {
    source      = "${path.module}/../env/ssh-key.pub"
    destination = "/tmp/ssh-key.pub"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo mkdir -p /root/.ssh",
      "sudo mv /tmp/ssh-key.pub /root/.ssh/authorized_keys",
      "sudo chmod 600 /root/.ssh/authorized_keys"
    ]
  }

  connection {
    type        = "ssh"
    user        = "vagrant"
    password = "vagrant"
    #private_key = file("${path.module}/../env/ssh-key.pub")
    host        = self.network_adapter[0].ipv4_address
  }

}

resource "time_sleep" "wait_2_minutes" {
  depends_on = [virtualbox_vm.master, virtualbox_vm.worker]

  create_duration = "2m"
}

output "master_ip" {
  depends_on = [ 
    time_sleep.wait_2_minutes
   ]
  value = virtualbox_vm.master[0].network_adapter[0].ipv4_address
}

output "worker_ips" {
  depends_on = [ 
    time_sleep.wait_2_minutes
    ]
  value = virtualbox_vm.worker[*].network_adapter[0].ipv4_address
}