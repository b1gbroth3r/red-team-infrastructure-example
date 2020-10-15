output "outputs" {
  value = [
    "Hostname: ${digitalocean_droplet.www.name}          - IP: ${digitalocean_droplet.www.ipv4_address}",
    "Hostname: ${digitalocean_droplet.gophish.name}                  - IP: ${digitalocean_droplet.gophish.ipv4_address}",
    "Hostname: ${digitalocean_droplet.phishing-rdr.name}     - IP: ${digitalocean_droplet.phishing-rdr.ipv4_address}",

    "2 Remaining Steps:",
    "1. SSH into ${digitalocean_droplet.www.name} and run the script in the root directory (once DNS has propagated).",
    "2. SSH into ${digitalocean_droplet.phishing-rdr.name} and copy the content of the dkim.txt file into a DNS TXT record to finish the DNS record management."
  ]
}
# The awkward spacing is for getting the alignment right when running `terraform output` or for the results at the end of the deployment