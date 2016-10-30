# Prepare the base OS

Create a new VM on vmware, linux Ubuntu64, 4CPUs, set up a 14Gb hard drive in a single file, do not launch the vm

Install ubuntu 16.04.01, hostname=rig1

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

# AMD GPU Pro drivers
Download https://www2.ati.com/drivers/linux/amdgpu-pro_16.30.3-306809.tar.xz
```
tar -Jxvf amdgpu-pro_16.30.3-306809.tar.xz
.amdgpu-pro/amdgpu-pro-install
```
reboot

# Basic Firewalling
> apt-get install -y iptables-persistent

> invoke-rc.d netfilter-persistent save

> service netfilter-persistent stop

> vim /etc/iptables/rules.v4

```
*filter
# Allow all outgoing, but drop incoming and forwarding packets by default
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]

# Custom per-protocol chains
:UDP - [0:0]
:TCP - [0:0]
:ICMP - [0:0]

# Acceptable UDP traffic

# Acceptable TCP traffic
-A TCP -p tcp --dport 22 -j ACCEPT
-A TCP -p tcp --dport 3333 -j ACCEPT

# Acceptable ICMP traffic

# Boilerplate acceptance policy
-A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
-A INPUT -i lo -j ACCEPT

# Drop invalid packets
-A INPUT -m conntrack --ctstate INVALID -j DROP

# Pass traffic to protocol-specific chains
## Only allow new connections (established and related should already be handled)
## For TCP, additionally only allow new SYN packets since that is the only valid
## method for establishing a new TCP connection
-A INPUT -p udp -m conntrack --ctstate NEW -j UDP
-A INPUT -p tcp --syn -m conntrack --ctstate NEW -j TCP
-A INPUT -p icmp -m conntrack --ctstate NEW -j ICMP

# Reject anything that's fallen through to this point
## Try to be protocol-specific w/ rejection message
-A INPUT -p udp -j REJECT --reject-with icmp-port-unreachable
-A INPUT -p tcp -j REJECT --reject-with tcp-reset
-A INPUT -j REJECT --reject-with icmp-proto-unreachable

# Commit the changes
COMMIT
*raw
:PREROUTING ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT

*nat
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT

*security
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
COMMIT

*mangle
:PREROUTING ACCEPT [0:0]
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
:POSTROUTING ACCEPT [0:0]
COMMIT
```

> vim /etc/iptables/rules.v6

```
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
COMMIT

*raw
:PREROUTING DROP [0:0]
:OUTPUT DROP [0:0]
COMMIT

*nat
:PREROUTING DROP [0:0]
:INPUT DROP [0:0]
:OUTPUT DROP [0:0]
:POSTROUTING DROP [0:0]
COMMIT

*security
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
COMMIT

*mangle
:PREROUTING DROP [0:0]
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT DROP [0:0]
:POSTROUTING DROP [0:0]
COMMIT
```

> service netfilter-persistent start

# SSD optimisation
> apt-get install zfs

# Install crypto tools ###not required
Download https://github.com/weidai11/cryptopp/releases/tag/CRYPTOPP_5_6_3

> tar xzvf crypto*

> cd crypto*

> make

# Install etherminer genoil ### Does not work !!!###
> apt-get install git cmake libleveldb-dev libboost-all-dev libgmp-dev libreadline-dev libcurl4-gnutls-dev ocl-icd-libopencl1 opencl-headers mesa-common-dev libmicrohttpd-dev build-essential libjsoncpp-dev -y

> git clone -b 110 https://github.com/Genoil/cpp-ethereum

> mkdir build

> cd build

> cmake -DBUNDLE=miner ..

> make

# Install sgminer  ### Does Not Work !!!###
> apt-get install libcurl4-openssl-dev pkg-config libtool libncurses5-dev autoconf

> git clone https://github.com/genesismining/sgminer-gm

Copy you ADL Headers into sgminer
> cp ADL_SDK/includes/* sgminer-gm/ADL_SDK

build
```
git submodule init
git submodule update
autoreconf -i
CFLAGS="-O2 -Wall -march=native -std=gnu99" ./configure <options>
make
```

# Claymore Dual miner
Extract Claymor Dual miner and review the config

# CRON
Do the crontab
> crontab -e

```
# On reboot start mining
@reboot bash /root/Claymore-v7.3/start.bash > /dev/null
# Every 10 minutes, check that everything is good
*/10 * * * * bash /root/Claymore-v7.3/checkup.sh > /dev/null
# Every Day remove old logs > 2 days old
@daily find /root/Claymore-v7.3/*_log.txt -mtime +2 | xargs rm -f
```

# Convert VMDK to RAW

close the VM and convert the vmdk into an iso
> qemu-img convert -f vmdk -O raw ~/vmware/Rig1/Rig1.vmdk ~/vmware/Rig1/Rig1.iso

# Clone the RAW to a physical ssd

clone the iso to the disk
> sudo dd if=/home/x41/vmware/Rig1/Rig1.iso of=/dev/sdb bs=32M conv=noerror,sync status=progress

resize your partitions and fix the errors with gparted

# Let's turn it on !

plug the hardrive in the rig and poweron

log in to your machine with
> ssh root@rig1
