#/bin/sh

ip link set wlan1 down
iwconfig wlan1 mode monitor
ip link set wlan1 up

ip link set wlan2 down
iwconfig wlan2 mode monitor
ip link set wlan2 up

ip link set wlan3 down
iwconfig wlan3 mode monitor
ip link set wlan3 up
