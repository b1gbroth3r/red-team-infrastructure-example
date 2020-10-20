#!/bin/bash

##### VARIABLES #####

# Change these
domain=""  # --> SETUP_DOMAIN_VARIABLE
private_ssh_key_file="" # --> SETUP_PRIVATE_SSH_KEY_FILE
ssh_key_name="" # --> SETUP_SSH_KEY_NAME
webroot_dir="" # --> SETUP_WEBROOT_DIR
gophish_server_name="" # --> SETUP_GOPHISH_SERVER_NAME

private_ssh_key_file_escaped=$(echo "$private_ssh_key_file" | sed -z "s/\//\\\\\\//g")

##### REPLACEMENTS #####

mv "./sites/RENAME TO WEBSERVER DOCUMENT ROOT" "./sites/$webroot_dir"

find . ! -name "setup.sh" -exec sed -i -e "s/SETUP_DOMAIN_VARIABLE/$domain/g" {} \; 2>/dev/null
find . ! -name "setup.sh" -exec sed -i -e "s/SETUP_PRIVATE_SSH_KEY_FILE/$private_ssh_key_file_escaped/g" {} \; 2>/dev/null
find . ! -name "setup.sh" -exec sed -i -e "s/SETUP_SSH_KEY_NAME/$ssh_key_name/g" {} \; 2>/dev/null
find . ! -name "setup.sh" -exec sed -i -e "s/SETUP_WEBROOT_DIR/$webroot_dir/g" {} \; 2>/dev/null
find . ! -name "setup.sh" -exec sed -i -e "s/SETUP_GOPHISH_SERVER_NAME/$gophish_server_name/g" {} \; 2>/dev/null

##### TERRAFORM ISH #####

terraform init
terraform fmt
terraform validate
terraform plan --out $domain.plan

echo "Terraform setup complete, when ready run 'terraform apply $domain.plan' to officially set up infrastructure"
