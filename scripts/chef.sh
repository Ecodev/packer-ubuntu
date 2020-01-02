#!/bin/bash

# Create the directory that will contain Chef configuration and keys
mkdir /etc/chef
chown root:root /etc/chef
chmod 755 /etc/chef
/usr/bin/curl -L https://www.chef.io/chef/install.sh | /usr/bin/sudo bash -s -- -v 14.5.33
