#!/bin/bash

# Bail if we are not running inside VMWare.
if [[ `facter virtual` != "vmware" ]]; then
    exit 0
fi

# Install the VMWare Tools from a linux ISO.

#wget http://192.168.0.185/linux.iso -P /tmp
mkdir -p /mnt/vmware
mount -o loop /home/vagrant/linux.iso /mnt/vmware

cd /tmp
tar xzf /mnt/vmware/VMwareTools-*.tar.gz

umount /mnt/vmware
rm -fr /home/vagrant/linux.iso

/tmp/vmware-tools-distrib/vmware-install.pl -d
rm -fr /tmp/vmware-tools-distrib

# Ensure that VMWare Tools recompiles kernel modules when we update the linux images
sed -i.bak 's/answer AUTO_KMODS_ENABLED_ANSWER no/answer AUTO_KMODS_ENABLED_ANSWER yes/g' /etc/vmware-tools/locations
sed -i.bak 's/answer AUTO_KMODS_ENABLED no/answer AUTO_KMODS_ENABLED yes/g' /etc/vmware-tools/locations

# Change ownership of VMware Fusion shared folder
# @see http://askubuntu.com/questions/377029/change-ownership-of-vmware-fusion-shared-folder
sed -i.bak '\|vmhgfs_mnt="/mnt/hgfs"|a vmuser=${VMWARE_MNT_USER:-root}' /etc/vmware-tools/services.sh
sed -i.bak 's|vmware_exec_selinux "mount -t vmhgfs .host:/ $vmhgfs_mnt"|uid=id --user $vmuser\n      gid=id --group $vmuser\n      vmware_exec_selinux "mount -t vmhgfs .host:/ $vmhgfs_mnt -o uid=$uid,gid=$gid"|' /etc/vmware-tools/services.sh
sed -i.bak '\|pre-start exec /etc/vmware-tools/services.sh start|i VMWARE_MNT_USER="root"' /etc/init/vmware-tools.conf
