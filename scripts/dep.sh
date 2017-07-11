#!/bin/bash
#
# Setup the the box. This runs as root

apt-get -y update

apt-get -y install unattended-upgrades unzip curl finger whois sysstat rsync screen mc tig pdftk make acl bash mosh tcpdump keychain telnet wget subversion htop git
