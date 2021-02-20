#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

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
rsync \
ruby2.7 \
ruby2.7-dev \
screen \
subversion \
sysstat \
tcpdump \
telnet \
tig \
unattended-upgrades \
unzip \
vim \
wget \
whois
