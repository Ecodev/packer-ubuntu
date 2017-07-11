#!/bin/bash

# Create the directory that will contain Chef configuration and keys
mkdir /etc/chef
chown root:root /etc/chef
chmod 755 /etc/chef
curl -L https://www.chef.io/chef/install.sh | sudo bash -s -- -v 12.20.3
