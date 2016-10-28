#!/bin/bash -ex

cd /root/eth-rig1

git pull

cp /root/eth-rig1/startup.sh /root/startup.sh

chmod +x /root/startup.sh

ifdown wlan0 && ifup -v wlan0
route add default gw 192.168.0.1 wlan0

bash /root/eth-rig1/mine.sh
