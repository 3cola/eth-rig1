# Prepare the base OS

Create a new VM on vmware, linux Ubuntu64, 4CPUs, set up a 14Gb hard drive in a single file, do not launch the vm

Configure EFI support in vmware : VM > Settings > Options > Advanced, and check Boot with EFI instead of BIOS.

Install ubuntu 14.04.05, hostname=rig1 

# Configuration for wifi connexion

Poweron in vmware, login and go root

> sudo -i

Setup wpa wifi
> wpa_passphrase "YOUR_SSID" SSID_PASSWORD | sudo tee /etc/wpa_supplicant/wpa_supplicant.conf

edit /etc/network/interfaces, add this:
> vim /etc/network/interfaces

```
auto wlan0
allow-hotplug wlan0
iface wlan0 inet dhcp
wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

# Configure ssh

add ~/.ssh/authorized_keys to the current user and to root
> mkdir .ssh

> vim ~/.ssh/authorized_keys 

copy the content of your local ~/.ssh/id_rsa.pub

do it again for the normal user

disable password authentication through ssh in /etc/ssh/sshd_config 

# Install the scripts

install git
> apt-get -y install git

get the scripts
> git clone https://github.com/3cola/eth-rig1.git

install ethminer-genoil
> chmod +x /root/eth-rig1/install_ethminer-genoil.sh && /root/eth-rig1/install_ethminer-genoil.sh

review the startup script
> chmod +x /root/eth-rig1/startup.sh && vim /root/eth-rig1/startup.sh

review the mining script
> chmod +x /root/eth-rig1/mine.sh && vim /root/eth-rig1/mine.sh

Do the crontab
> crontab -e

```
@reboot cd /root/eth-rig1 && git pull && chmod +x /root/eth-rig1/startup.sh && bash /root/eth-rig1/startup.sh &> /root/server.log
```

# Convert VMDK to RAW

close the VM and convert the vmdk into an iso
> qemu-img convert -f vmdk -O raw ~/vmware/Rig1/Rig1.vmdk ~/vmware/Rig1/Rig1.iso 

# Clone the RAW to a physical ssd

clone the iso to the disk
> sudo dd if=/home/x41/vmware/Rig1/Rig1.iso of=/dev/sdb bs=32M conv=noerror,sync status=progress

resize your partitions if needed with gparted

# Let's turn it on !

plug the hardrive in the rig and poweron

log in to your machine with 
> ssh root@192.168.0.2

