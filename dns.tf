resource "digitalocean_record" "wwwroot" {
  domain = var.domain
  type   = "A"
  name   = "@"
  value  = digitalocean_droplet.www.ipv4_address
  ttl    = 600
}

resource "digitalocean_record" "wwwcn" {
  domain = var.domain
  type   = "CNAME"
  name   = "www"
  value  = "${var.domain}."
  ttl    = 600
}

resource "digitalocean_record" "mail-rdr-A" {
  domain = var.domain
  type   = "A"
  name   = "mail"
  value  = digitalocean_droplet.phishing-rdr.ipv4_address
  ttl    = 600
}

resource "digitalocean_record" "mail-rdr-mx" {
  domain   = var.domain
  type     = "MX"
  name     = "@"
  value    = "mail.${var.domain}."
  priority = 10
  ttl      = 600
}

resource "digitalocean_record" "mail-rdr-spf" {
  domain = var.domain
  type   = "TXT"
  name   = "@"
  value  = "v=spf1 a mx ip4:${digitalocean_droplet.phishing-rdr.ipv4_address} ~all"
  ttl    = 60
}

resource "digitalocean_record" "mail-rdr-dmarc" {
  domain = var.domain
  type   = "TXT"
  name   = "_dmarc"
  value  = "v=DMARC1; p=reject"
  ttl    = 60
}

resource "digitalocean_record" "mail-rdr-dkim" {
  domain = var.domain
  type   = "TXT"
  name   = "mail._domainkey"
  value  = "INSERT DKIM HERE"
  ttl    = 600
}

#evilginx2 requirement
resource "digitalocean_record" "evil-ns1" {
  domain = var.domain
  type   = "NS"
  name   = "ns1.${var.domain}"
  value  = digitalocean_droplet.evilginx2.ipv4_address
}

#evilginx2 requirement
resource "digitalocean_record" "evil-ns2" {
  domain = var.domain
  type   = "NS"
  name   = "ns1.${var.domain}"
  value  = digitalocean_droplet.evilginx2.ipv4_address
}

# not sure if necessary, but this record resolved a lot of my issues with hostname/certificate creation
resource "digitalocean_record" "evil-wildcard-a" {
  domain = var.domain
  type   = "A"
  name   = "*"
  value  = digitalocean_droplet.evilginx2.ipv4_address
}
