#!/bin/sh

## CHOOSE ONE OF THE BELOW
# For current stable
wget  -P /usr/local/src  https://re4son-kernel.com/download/re4son-kernel-current/
tar -xJf re4son-kernel_current.tar.xz

# For old stable
#wget -P /usr/local/src https://re4son-kernel.com/download/re4son-kernel-old/
#tar -xJf re4son-kernel_old.tar.xz

# For next
#wget -P /usr/local/src https://re4son-kernel.com/download/re4son-kernel-next/
#tar -xJf re4son-kernel_next.tar.xz

cd /usr/local/src/re4son-kernel_4*
./install.sh
