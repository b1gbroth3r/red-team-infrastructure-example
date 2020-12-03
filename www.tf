resource "digitalocean_droplet" "www" {
  image    = "Ubuntu-18-04-x64"
  name     = var.domain
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.SETUP_SSH_KEY_NAME.id]

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
      "a2enmod rewrite", 
      "a2enmod proxy", 
      "a2enmod proxy_http", 
      "a2enmod ssl",
      "rm /var/www/html/index.html",
      "service apache2 restart"
    ]
  }

  provisioner "file" {
    source      = "./sites/SETUP_WEBROOT_DIR"
    destination = "/var/www/html/SETUP_WEBROOT_DIR/"
  }

  provisioner "file" {
    source      = "./scripts/apache_document_root_change.sh"
    destination = "/root/apache_document_root_change.sh"
  }
}
# We can't execute the previously upload script immediately.
# Relies on DNS records already being provisioned, which won't have happened while this server gets deployed.
# Once DNS has propagated and you can ping/SSH/etc to the box using the domain name, you should be safe to run the script
