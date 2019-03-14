#!/bin/sh

# Ubuntu / Debian / Kali / Mint
apt-get install build-essential git libmicrohttpd-dev pkg-config zlib1g-dev libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libncurses5-dev libnm-dev libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libsensors4-dev libusb-dev

#Python add-ons development support
apt-get install python python-setuptools python-protobuf python-requests

# install rtlsdr rtl_433 support:
apt-get install librtlsdr0

# Kismet
cd /usr/local/src
git clone --depth=1 https://www.kismetwireless.net/git/kismet.git
cd kismet
# ...or update:
#git pull
./configure
make
make suidinstall
make plugins-install

# Add user(s) to kismet group:
usermod -a -G kismet root

# Kestrel plugin
cd /usr/local/src
git clone --depth=1 https://github.com/soliforte/kestrel
cd kestrel/plugin-kestrel
make install

#IoD plugin
cd /usr/local/src
git clone --depth=1 https://github.com/internetofdongs/IoD-Screwdriver.git
cd IoD-Screwdriver/plugin-iod-screwdriver
make install

# Mobile Dashboard plugin
cd /usr/local/src
git clone --depth=1 https://github.com/elkentaro/KismetMobileDashboard.git
cd KismetMobileDashboard
make install
