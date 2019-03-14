#!/bin/sh

apt-get update
apt-get install build-essential git libmicrohttpd-dev pkg-config zlib1g-dev libnl-3-dev libcap-dev libpcap-dev libnm-dev libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compilier libsensors4-dev
apt-get install python python-setuptools python-protobuf python-requests
apt-get install librtlsdr0 python-usb python-paho-mqtt
apt-get install libusb-1.0-0-dev

wget -O - https://www.kismetwireless.net/repos/kismet-release.gpg.key | apt-key add -

## CHOOSE ONE OF THE BELOW
# For current stable
echo 'deb https://www.kismetwireless.net/repos/apt/release/kali kali main' | tee /etc/apt/sources.list.d/kismet.list

# For nightly git
#echo 'deb https://www.kismetwireless.net/repos/apt/git/kali kali main' | tee /etc/apt/sources.list.d/kismet.list

#apt-get install kismet2018
