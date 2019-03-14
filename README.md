<img src="https://github.com/darkgrue/Portable-Raspberry-Pi-Kali-Kismet-Integration/raw/master/docs/images/kismet-in-a-box.jpg" alt="Kismet-in-A-Box" width="500" height="500">

# Introduction

This is the basic documentation and model support files for a software and hardware integration project to build a transit-case-portable version of [Kismet](https://www.kismetwireless.net/) running on [Offsensive Security Kali Linux](https://www.offensive-security.com/kali-linux-arm-images/) (Kali Linux RaspberryPi 2 and 3) and a Raspberry Pi 3 Model B+.

The goal is to have a fully-functional Kismet platform that integrates all supported data sources in a completely portable form factor. In this case, the data sources being used are:
* Linux Wi-Fi (3x Alfa AWUS036ACH, RTL8812AU 802.11ac/a/b/g/n chipset)
* Linux Bluetooth (Cypress CYW43455 Bluetooth 4.2 chipset, onboard Raspberry Pi 3 Model B+)
* SDR RTL433 ([rtl_433](https://github.com/merbanan/rtl_433), 433.92 MHz generic data receiver)
* [Mousejack](https://github.com/BastilleResearch/mousejack) / nRF (Nordic Semiconductor nRF24LU1+ Logitech Unifying dongle, model C-U0007)
* GPS (u-blox 7, geolocation coordinates for devices)

There is room for expansion, and the as-built includes external connections for power, ethernet, and USB. A [DSTIKE Deauth Detector V2(Pre-flashed)](https://www.tindie.com/products/lspoplove/dstike-deauth-detector-v2pre-flashed/) has been included on the hub to independently monitor [deauthentication attacks](https://en.wikipedia.org/wiki/Wi-Fi_deauthentication_attack) on the 2.4GHz band.

# Bill of Materials
NOTE: Some items were bought in quantity (i.e. 3-pack, etc.) because of ease of procurement. In some cases there will be leftover/spare parts. Required quantities from packages are given for the as-built.

## Hardware
Qty. | Item | Approx. Price
------------ |------------ | -------------
1 |	[1/8" X 3" 6061 T6511 Aluminum extruded flat bar 12" long](https://www.ebay.com/itm/2-Pieces-1-8-X-3-ALUMINUM-6061-FLAT-BAR-12-long-T6511-New-Mill-Stock-125-x-3/350926360885) | $5.89
1 |	[Stanley National S838-946 2-1/2" Zinc Corner Brace- DPB113](https://www.amazon.com/dp/B00KQVM8E4) | $6.82
1 |	[Apache 3800 Weatherproof Protective Case - 16-5/16 In.](https://www.harborfreight.com/3800-weatherproof-protective-case-16-516-in-63927.html) | $39.99
as-needed | Misc screws, nuts and washers | varies
as-needed | 3M Dual Lock™ Reclosable Fastener SJ3560, Clear, 1 in | varies

## Computing Platform
Qty. | Item | Approx. Price
------------ |------------ | -------------
1 |	[CanaKit Raspberry Pi 3 B+ (B Plus) with 2.5A Power Supply (UL Listed)](https://www.amazon.com/dp/B07BC6WH7V) | $48.99
1 | [Samsung 128GB 100MB/s (U3) MicroSD EVO Select Memory Card with Adapter (MB-ME128GA/AM)](https://www.amazon.com/dp/B06XWZWYVP) | $28.99
1 |	[ModMyPi Modular (variable height) case for Raspberry Pi 2/3 - complete set with covers, spacers, screws & feet](https://www.amazon.com/dp/B01LYARY5D) | $19.95
1 | [SIIG 7-Port Industrial USB 3.0 Hub with 15KV ESD Protection](https://www.ebay.com/itm/SIIG-4-Port-and-7-Port-Industrial-USB-3-0-Hub-with-15KV-ESD-Protection/132678192728) | $34.99
1 | [Spell Foundry Sleepy Pi 2](https://spellfoundry.com/product/sleepy-pi-2/) | $56.33
1 |	[7inch HDMI 1024×600 Capacitive Touch Screen with Bicolor Case for Raspberry Pi](https://www.ebay.com/itm/7-HDMI-LCD-with-Case-800-480-Capacitive-Touch-Screen-for-Raspberry-Pi-BB-Black/262125842620) |  $67.15
1 | [Rii i8+ 2.4GHz Mini Wireless Keyboard with Touchpad Mouse,LED Backlit,Rechargable Li-ion Battery (Updated 2017,Backlit)](https://www.amazon.com/dp/B00WQG6A8C) | $21.95
1 | [Hard EVA Case for (Updated 2017,Backlit) Rii i8+ 2.4GHz Mini Wireless Keyboard by Hermitshell](https://www.amazon.com/dp/B01E8ILR60) | $9.99

## Power
Qty. | Item | Approx. Price
------------ |------------ | -------------
1 | [DC 12V 45A Anderson Powerpole Connector Power Distribution 1 input - 4 output](https://www.ebay.com/itm/DC-12V-45A-Anderson-Powerpole-Connector-Power-Distribution-1-input-4-output/183445188417) | $30.00
3 | 2A ATO blade fuse [2 required, 1 spare] | varies
1 | [TalentCell Rechargeable 72W 132WH 12V/11000mAh 9V/14500mAh 5V/26400mAh DC Output Lithium Ion Battery Pack For LED Strip and CCTV Camera, Portable Li-ion Power Bank, Black](https://www.amazon.com/dp/B016BJCRUO) | $64.99
1 | [[Real 18AWG 43x2pcs Wires] 10 Pairs DC Power Pigtail Cable, 12V 5A Male & Female Connectors for CCTV Security Camera and Lighting Power Adapter by MILAPEAK (2.1mm x 5.5 mm, Ultra Thick 18AWG)](https://www.amazon.com/dp/B072BXB2Y8) [1 M/F pair required]| $9.69
1 | [30 Amp Unassembled Red/Black Anderson Powerpole Connectors Complete with Roll Pin (10 sets)](https://www.amazon.com/dp/B01HDZ91G8) [5 sets required] | $16.47
1 | [Brccee AC 10PCS FR PVC Cover Flame Retardant Sleeve for ANDERSON Powerpole Connector Housing](https://www.amazon.com/dp/B07DCSGS9R) [4 required] | $6.99
as-needed | red-black hookup wire | varies

## Radios
Qty. | Item | Approx. Price
------------ |------------ | -------------
1 | [Stratux GPYes u-blox 7 GPS unit](https://www.amazon.com/dp/B0716BK5NT) | $15.99
3 | [Alfa Long-Range Dual-Band AC1200 Wireless USB 3.0 Wi-Fi Adapter w/2x 5dBi External Antennas – 2.4GHz 300Mbps/5GHz 867Mbps – 802.11ac & A, B, G, N](https://www.amazon.com/dp/B00VEEBOPG) | $149.97
1 | [NooElec NESDR Mini USB RTL-SDR & ADS-B Receiver Set, RTL2832U & R820T Tuner, MCX Input. Low-Cost Software Defined Radio Compatible with Many SDR Software Packages. R820T Tuner & ESD-Safe Antenna Input](https://www.amazon.com/dp/B009U7WZCA) | $19.95
1 | [Logitech C-U0007 Unifying receiver for mouse and keyboard works with any product that display the Unifying Logo (orange star, connects up to 6 devices) (C-U0007)](https://www.amazon.com/dp/B0058OU8VY) | $9.79
1 | [Stratux GPYes u-blox 7 GPS unit](https://www.amazon.com/dp/B0716BK5NT) | $15.99
1 | [DSTIKE Deauth Detector V2(Pre-flashed)](https://www.tindie.com/products/lspoplove/dstike-deauth-detector-v2pre-flashed/) | $11.00

## Antennas & RF
Qty. | Item | Approx. Price
------------ |------------ | -------------
1 | [433MHz GSM GPRS RP-SMA male Tilt-Swivel 20cm radio Antenna](https://www.ebay.com/itm/433MHz-GSM-GPRS-RP-SMA-male-Tilt-Swivel-20cm-radio-Antenna/321117288367) | $4.80
4 | [6inch RP-SMA MALE RIGHT ANGLE to RP-SMA Female RF Extension Cable RG316](https://www.ebay.com/itm/RP-SMA-MALE-RIGHT-ANGLE-to-RP-SMA-Female-RF-Extension-Cable-RG316-2in-10feet/131159786419) | $15.38
2 | [8inch RP-SMA MALE RIGHT ANGLE to RP-SMA Female RF Extension Cable RG316](https://www.ebay.com/itm/RP-SMA-MALE-RIGHT-ANGLE-to-RP-SMA-Female-RF-Extension-Cable-RG316-2in-10feet/131159786419) | $17.80
1 | [Dust Cap For SMA Jack Female or RP-SMA RF Connector With Ring Chain Silver UE](https://www.ebay.com/itm/Dust-Cap-For-SMA-Jack-Female-or-RP-SMA-RF-Connector-With-Ring-Chain-Silver-UE/332591617374) | $5.15

## Cabling
Qty. | Item | Approx. Price
------------ |------------ | -------------
1 | [Monoprice 113576 Ultra Slim Series High Speed HDMI Cable, 1ft Black](https://www.amazon.com/dp/B014RONV5K) | $9.80
1 | [VCE 2 Combos HDMI 90 and 270 Degree Male to Female Vertical Flat Adapter](https://www.amazon.com/dp/B06Y6743TL) [1 required] | $7.99
1 | [Coiled Micro USB Cable – Rerii Coiled USB to Micro USB, Right Angled, Spring, Coiled Micro USB Cable, for Micro B Device, Charging and Data SYNC, Samsung, HTC, Huawei, Sony and More](https://www.amazon.com/dp/B01HPSRYYO) | $6.99
1 | [Besgoods 3-Pack Short 1.5ft Braided Super Speed USB 3.0 Cable - Type A Male to Micro B Cable Cord for Hard Drive, Samsung Galaxy S5, Note 3 and More, Black White Blue](https://www.amazon.com/dp/B078RZG6XS) [3 required] | $11.99
1 | [SaiTech IT 4 Pack (15cm - 6inch) Adjustable Flexible USB 2.0 Male to Female Extension Plug/Socket Adapter Cable - Worlds Shortest USB 2.0 Extension Cable](https://www.amazon.com/dp/B01GA1GKYW) [2 required] | $8.59
1 | [1 ft / 30cm SuperSpeed USB 3.0 Cable A to B - USB 3 A (m) to USB 3 B (m)](https://www.amazon.com/dp/B004395680) | $6.61

## Optional
The items below are optional, to plumb the power, USB, and Ethernet connections to the outside of the case. While they are present in the as-built, they're not essential to operation.
NOTE: The external power connection is constructed of a custom Y-cable and mating connector for the Li-ion charger that uses additional PowerPole connectors, sleeves, and 2.1mm x 5.5 mm pigtail connectors, and assumes purchase of components in quantity.

Qty. | Item | Approx. Price
------------ |------------ | -------------
1 | [CNLINKO RJ45 Dual Port Ethernet Connector, Panel Mount Receptacles Socket Jack, Outdoor Waterproof IP67, Fast Data, Industrial](https://www.amazon.com/dp/B073RZHPKS) | $11.39
1 | [CNLINKO USB 3.0 Connector, Type A Female to Female, Panel Mount Receptacles Socket Jack, Dual USB Port, Outdoor Waterproof IP67, Data + Power, Panel Pass, Industrial Standard](https://www.amazon.com/dp/B01N6ERRX7) | $12.62
1 | [Threaded Panel Mount, Anderson PowerPole PP15-PP45](https://www.ebay.com/itm/Threaded-Panel-Mount-Anderson-PowerPole-PP15-PP45/173536212677) | $7.38
1 | [LOHASIC USB 3.0 Ultra High Speed Cable , 1 Feet , Male A Plug to A Plug -Blue,1FT](https://www.amazon.com/dp/B00KMQ7O5G) | $6.99
1 | [Monoprice Flexboot Cat6 Ethernet Patch Cable - Network Internet Cord - RJ45, Stranded, 550Mhz, UTP, Pure Bare Copper Wire, 24AWG, 1ft, Yellow](https://www.amazon.com/dp/B00AJHCMG4) | $2.22
