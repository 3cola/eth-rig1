#!/bin/bash -ex

apt-get update && \
apt-get -y install software-properties-common
add-apt-repository -y ppa:ethereum/ethereum && \
apt-get update 
apt-get install git cmake libcryptopp-dev libleveldb-dev libjsoncpp-dev libjson-rpc-cpp-dev libboost-all-dev libgmp-dev libreadline-dev libcurl4-gnutls-dev ocl-icd-libopencl1 opencl-headers mesa-common-dev libmicrohttpd-dev build-essential -y

cd /root && \
git clone https://github.com/Genoil/cpp-ethereum/

cd /root/cpp-ethereum
mkdir build
cd build
cmake -DBUNDLE=miner ..

make -j4


echo -n "ethminer-genoil available at /root/cpp-ethereum/ethminer/ethminer"

