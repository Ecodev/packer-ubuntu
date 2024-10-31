#!/bin/bash

# Add all kind of Ecodev specific dependencies

# To avoid blocking on iptables-persistent interactive question during install
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections

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
iptables-persistent \
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

# Create the directory that will contain Cinc configuration and keys
mkdir /etc/cinc
chown root:root /etc/cinc
chmod 755 /etc/cinc

# Install Cinc
/usr/bin/curl -L https://omnitruck.cinc.sh/install.sh | /usr/bin/sudo bash -s -- -v 17.10.165
