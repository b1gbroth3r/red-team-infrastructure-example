resource "digitalocean_droplet" "www" {
  image    = "Ubuntu-18-04-x64"
  name     = var.domain
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
      "apt install -y apache2",
      "apt install -y certbot",
      "apt install -y python-certbot-apache",
      "a2enmod rewrite, proxy, proxyhttp, ssl",
      "sudo mkdir /var/www/html/ENTER WEBSITE ROOT DIRECTORY NAME HERE/",
      "rm /var/www/html/index.html",
      "service apache2 restart"
    ]
  }

  provisioner "file" {
    source      = "./sites/#ENTER WEBSITE ROOT DIRECTORY NAME HERE"
    destination = "/var/www/html/# ENTER WEBSITE ROOT DIRECTORY NAME HERE/"
  }

  provisioner "file" {
    source      = "./scripts/apache_document_root_change.sh"
    destination = "/root/apache_document_root_change.sh"
  }
}
# We can't execute the previously upload script immediately.
# Relies on DNS records already being provisioned, which won't have happened while this server gets deployed.
# Once DNS has propagated and you can ping/SSH/etc to the box using the domain name, you should be safe to run the script