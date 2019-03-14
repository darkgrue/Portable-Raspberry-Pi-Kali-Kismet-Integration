#!/bin/sh

apt-get update
apt-get install whiptail parted lua5.1 alsa-utils psmisc
wget -P /usr/local/bin/ https://raw.githubusercontent.com/Re4son/RPi-Tweaks/master/kalipi-config/kalipi-config
chmod 755 /usr/local/bin/kalipi-config
