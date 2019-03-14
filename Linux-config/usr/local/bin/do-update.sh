#!/bin/sh

/usr/bin/apt-get update
/usr/bin/apt-get dist-upgrade
/usr/bin/apt-get autoremove
/usr/bin/apt-get autoclean
