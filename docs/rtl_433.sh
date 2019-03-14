#!/bin/sh

apt-get update
apt-get install libtool libusb-dev librtlsdr-dev rtl-sdr build-essential autoconf cmake pkg-config

cd /usr/local/src
git clone --depth=1 https://github.com/merbanan/rtl_433

cd rtl_433/
# ...or update:
#git pull
mkdir build
cd build
cmake ../
make
make install
