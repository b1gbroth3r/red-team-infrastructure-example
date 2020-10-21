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
