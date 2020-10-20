#!/bin/bash

sed -i 's/relayhost = /relayhost = [mail.SETUP_DOMAIN_VARIABLE]/g' /etc/postfix/main.cf
