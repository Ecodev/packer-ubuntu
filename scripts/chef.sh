#!/bin/bash

# Create the directory that will contain Chef configuration and keys
mkdir /etc/chef

curl -L https://www.chef.io/chef/install.sh | sudo bash -s -- -v 12.4.1
