#!/bin/bash -ex

ifdown wlan0 && ifup -v wlan0
route add default gw 192.168.0.1 wlan0

/root/eth-rig1/mine.sh
