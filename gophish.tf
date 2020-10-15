resource "digitalocean_droplet" "gophish" {
  image    = "Ubuntu-18-04-x64"
  name     = "" # ENTER YOUR GOPHISH SERVER'S NAME HERE
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [] # ENTER APPROPRIATE SSH KEY VALUE HERE

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.private_ssh_key)
    timeout     = "60s"
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "apt update && apt upgrade -y",
      "apt install -y zip",
      "apt install -y postfix",
      "wget https://github.com/gophish/gophish/releases/download/v0.11.0/gophish-v0.11.0-linux-64bit.zip -O gophish.zip",
      "unzip gophish.zip -d /opt/gophish/",
      "chmod +x /opt/gophish/gophish"
    ]
  }

  provisioner "file" {
    source      = "./scripts/gophish.service"
    destination = "/lib/systemd/system/gophish.service"
  }

  provisioner "file" {
    source      = "./scripts/gophish.sh"
    destination = "/root/gophish.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /root/gophish.sh",
      "systemctl daemon-reload",
      "service gophish start"
    ]
  }

  provisioner "file" {
    source      = "./scripts/add_relay_to_postfix.sh"
    destination = "/root/add_relay_to_postfix.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x add_relay_to_postfix.sh",
      "bash /root/add_relay_to_postfix.sh",
      "service postfix restart"
    ]
  }
}