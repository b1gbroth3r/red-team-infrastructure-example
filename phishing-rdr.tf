resource "digitalocean_droplet" "phishing-rdr" {
  image    = "ubuntu-18-04-x64"
  name     = "mail.${var.domain}"
  region   = "nyc1"
  size     = "s-1vcpu-1gb"
  ssh_keys = [data.digitalocean_ssh_key.SETUP_SSH_KEY_NAME.id] # ENTER APPROPRIATE SSH KEY VALUE HERE

  connection {
    host        = self.ipv4_address
    user        = "root"
    type        = "ssh"
    private_key = file(var.private_ssh_key)
    timeout     = "60s"
  }

  provisioner "remote-exec" {
    inline = [
      # postfix
      "export DEBIAN_FRONTEND=noninteractive; apt update && apt-get -y -qq install socat postfix opendkim opendkim-tools certbot",
      "echo ${var.domain} > /etc/mailname",
      "echo ${digitalocean_droplet.phishing-rdr.ipv4_address} ${var.domain} > /etc/hosts",
      "postconf -e myhostname=${var.domain}",
      "postconf -e milter_protocol=2",
      "postconf -e milter_default_action=accept",
      "postconf -e smtpd_milters=inet:localhost:12345",
      "postconf -e non_smtpd_milters=inet:localhost:12345",
      "postconf -e mydestination=\"${var.domain}, $myhostname, localhost.localdomain, localhost\"",
      "postconf -e mynetworks=\"127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128 ${digitalocean_droplet.gophish.ipv4_address}\"",

      # dkim
      "mkdir -p /etc/opendkim/keys/${var.domain}",
      "cd /etc/opendkim/keys/${var.domain}; opendkim-genkey -t -s mail -d ${var.domain} && tr -d \"\\n\\t\\\" \" < mail.txt | cut -d\"(\" -f2 | cut -d \")\" -f1 > /root/dkim.txt; sudo chown opendkim:opendkim mail.private",
      "echo mail._domainkey.${var.domain} ${var.domain}:mail:/etc/opendkim/keys/${var.domain}/mail.private > /etc/opendkim/KeyTable",
      "echo *@${var.domain} mail._domainkey.${var.domain} > /etc/opendkim/SigningTable",
      "echo \"SOCKET=\"inet:12345@localhost\"\" >> /etc/default/opendkim",
      "echo ${digitalocean_droplet.gophish.ipv4_address} > /etc/opendkim/TrustedHosts",
      "echo *.${var.domain} >> /etc/opendkim/TrustedHosts",
      "echo localhost >> /etc/opendkim/TrustedHosts",
      "echo 127.0.0.1 >> /etc/opendkim/TrustedHosts",

      "echo \"@reboot root socat TCP4-LISTEN:80,fork TCP4:${digitalocean_droplet.gophish.ipv4_address}:80\" >> /etc/cron.d/mdadm",
      "echo \"@reboot root socat TCP4-LISTEN:443,fork TCP4:${digitalocean_droplet.gophish.ipv4_address}:443\" >> /etc/cron.d/mdadm"
    ]
  }

  provisioner "file" {
    source      = "./configs/header_checks"
    destination = "/etc/postfix/header_checks"
  }

  provisioner "file" {
    source      = "./configs/master.cf"
    destination = "/etc/postfix/master.cf"
  }

  provisioner "file" {
    source      = "./configs/opendkim.conf"
    destination = "/etc/opendkim.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "shutdown -r"
    ]
  }
}
