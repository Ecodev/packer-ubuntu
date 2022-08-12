#!/bin/bash

# Add all kind of Ecodev specific dependencies

# This should be kept in sync with chef-base/attributes/default.rb
apt-get -y install \
acl \
bash \
cmake \
curl \
finger \
git \
gnupg \
htop \
keychain \
logrotate \
make \
mc \
mosh \
net-tools \
python-is-python3 \
rsync \
ruby3.0 \
ruby3.0-dev \
screen \
sysstat \
tcpdump \
telnet \
tig \
unattended-upgrades \
unzip \
vim \
wget \
whois

# Create the directory that will contain Chef configuration and keys
mkdir /etc/chef
chown root:root /etc/chef
chmod 755 /etc/chef

# Install Chef
/usr/bin/curl -L https://www.chef.io/chef/install.sh | /usr/bin/sudo bash -s -- -v 16.18.0
