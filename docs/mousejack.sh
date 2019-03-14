#!/bin/sh

apt-get update
apt-get install sdcc binutils python python-pip python-usb
# DON'T upgrade the system-managed version of pip, it breaks wrapper scripts.
#python -m pip --upgrade pip
# DON'T upgrade the system-managed version of python-usb.
#python -m pip install --upgrade --ignore-installed pyusb
python3 -m pip install --upgrade platformio

git clone --depth=1 https://github.com/BastilleResearch/mousejack
# ...or update:
#git pull
cd mousejack/
git submodule init
git submodule update
cd nrf-research-firmware
# DON'T use Makefile to completion, it's broken.
make
# Makefile terminates with Error 1.
make -n
sdcc --verbose --model-large --std-c99 -c src/radio.c -o bin/radio.rel
# Call assembler by hand:
sdas8051 -plosgffw bin/radio.rel bin/radio.asm
sdcc --verbose --xram-loc 0x8000 --xram-size 2048 --model-large bin/main.rel bin/usb.rel bin/usb_desc.rel bin/radio.rel -o bin/dongle.ihx
objcopy --verbose -I ihex bin/dongle.ihx -O binary bin/dongle.bin
objcopy --verbose --pad-to 26622 --gap-fill 255 -I ihex bin/dongle.ihx -O binary bin/dongle.formatted.bin
objcopy --verbose -I binary bin/dongle.formatted.bin -O ihex bin/dongle.formatted.ihx

# Install firmware on nRF24LU1+ over USB:
#make install
# Install firmware on Logitech Unifying (model C-U0007):
#make logitech_install

# Restore factory firmware on Logitech Unifying (model C-U0007):
#git clone --depth=1 https://github.com/Logitech/fw_updates
#./prog/usb-flasher/logitech-usb-restore.py <path-to-firmware.hex>
