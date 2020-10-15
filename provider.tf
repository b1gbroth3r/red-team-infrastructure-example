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
  default = "" # ENTER YOUR DOMAIN
}
variable "private_ssh_key" {
  default = "" # ENTER YOUR PATH TO THE PRIVATE SSH KEY
}

data "digitalocean_ssh_key" "demo" {
  name = "" # ENTER YOUR SSH KEY NAME
}
    