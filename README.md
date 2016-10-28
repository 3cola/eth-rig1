# Prepare the base OS

Create a new VM on vmware, linux Ubuntu64, 4CPUs, set up a 14Gb hard drive in a single file, do not launch the vm

Configure EFI support in vmware : VM > Settings > Options > Advanced, and check Boot with EFI instead of BIOS.

Install ubuntu 14.04.05, hostname=rig1 

Poweron in vmware, login and go root

> sudo -i

edit /etc/network/interfaces, add this:
> vim /etc/network/interfaces
```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-ssid TP-LINK_M7350_M41
wpa-psk <your_wpa_key>
```

```
auto wlan1
allow-hotplug wlan1
iface wlan1 inet dhcp
wpa-ssid TP-LINK_M7350_M41
wpa-psk <your_wpa_key>
```

add ~/.ssh/authorized_keys to the current user and to root
> mkdir .ssh
vim ~/.ssh/authorized_keys 

copy the content of your local ~/.ssh/id_rsa.pub

do it again for the normal user

disable password authentication through ssh in /etc/ssh/sshd_config 

poweroff
> poweroff

close the VM and convert the vmdk into an iso
> qemu-img convert -f vmdk -O raw ~/vmware/Rig1/Rig1.vmdk ~/vmware/Rig1/Rig1.iso 

clone the iso to the disk
> sudo dd if=/home/x41/vmware/Rig1/Rig1.iso of=/dev/sdb bs=32M conv=noerror,sync status=progress

resize your partitions if needed with gparted

plug the hardrive in the rig and poweron

log in to your machine with 
> ssh root@rig1


get the scripts
> git clone git@github.com:3cola/eth-rig1.git

install ethminer-genoil
> /root/eth-rig1/install_ethminer-genoil.sh

review the mining script
> vim /root/eth-rig1/mine.sh

> Do the crontab
> crontab -e
```
@reboot sh /root/eth-rig1/mine.sh &> /root/miner.log
```

