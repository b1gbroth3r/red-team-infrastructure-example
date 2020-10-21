# Declaring the source of the digitalocean provider within the Terraform registry and the current version
terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "1.22.2"
    }
  }
}
# Telling digitalocean to authenticate and create/destroy records with our personal access token
provider "digitalocean" {
  token = var.apikey
}
# Variable declarations
variable "apikey" {}
variable "domain" {
  default = "SETUP_DOMAIN_VARIABLE"
}
variable "private_ssh_key" {
  default = "SETUP_PRIVATE_SSH_KEY_FILE"
}

data "digitalocean_ssh_key" "SETUP_SSH_KEY_NAME" {
  name = "SETUP_SSH_KEY_NAME"
}
