resource "digitalocean_droplet" "evilginx2" {
  image    = "debian-9-x64"
  name     = "evilginx2"
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.SETUP_SSH_KEY_NAME.id]

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.private_ssh_key)
    timeout     = "120s"
  }

  provisioner "remote-exec" {
    inline = [
      "export DEBIAN_FRONTEND=noninteractive",
      "wget https://github.com/kgretzky/evilginx2/releases/download/2.4.0/evilginx-linux-amd64.tar.gz",
      "tar zxvf evilginx-linux-amd64.tar.gz",
      "chmod 700 evilginx/install.sh",
      "cd evilginx && ./install.sh"
    ]
  }
}
