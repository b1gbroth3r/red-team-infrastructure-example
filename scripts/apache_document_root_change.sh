#!/bin/bash
certbot --apache --preferred-challenges http --register-unsafely-without-email --agree-tos -d <YOUR DOMAIN> -n --redirect # obtain SSL cert for domain
sed -i 's/\/var\/www\/html/\/var\/www\/html\/YOUR WEBSERVER DOCUMENT ROOT/g' /etc/apache2/sites-enabled/000-default.conf # change document root to /var/www/html/domain/
sed -i 's/\/var\/www\/html/\/var\/www\/html\/YOUR WEBSERVER DOCUMENT ROOT/g' /etc/apache2/sites-enabled/000-default-le-ssl.conf # same as previous line only for HTTPS site
service apache2 restart
# your site should now be accessible over HTTP and HTTPS, with a valid certificate on the HTTPS site.
# We can't run this during the terraform deployment due to DNS records not being set yet, plus time for DNS to propagate is usually necessary.
# Run this script once the DNS records have been propagated (ie. if you can ping the domain and it resolves)
