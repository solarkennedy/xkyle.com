---
title: "re:Invent 2023 Badge Teardown"
date: 2023-12-09T00:00:00-00:00
---

NOTE: This blog post is just a physical teardown and documentation of the device's advertised bluetooth capabilities.
No reverse engineering was done (I'm not that good).

I recently attended AWS re:Invent 2023, and the badge had a curious circular object attached to it.

In extremely small print it had some sort of serial, `00234867` silk screened on the case.

Inside was a small circular PCB and a CR2016 battery:

[![badgepcb.png text](/uploads/2023-12-09-reinvent-badge-teardown/badgepcb.thumb.png)](/uploads/2023-12-09-reinvent-badge-teardown/badgepcb.png)

(click for a larger image)

The PCB is labled with `MS60SF9_V1.0` and a `m1805` chip.
I couldn't find any documentation on this chip, but it looks related to the [MINEWSEMI M1805-MS48SF2](https://en.minewsemi.com/bluetooth-module/m1805-ms48sf2).

The bluetooth device identifies as a `Tnnow` with the following UUIDs:

```
BC:00:00:00:4C:D6 Tnnow

00001800-0000-1000-8000-00805f9b34fb Generic Access
00001801-0000-1000-8000-00805f9b34fb Generic Attribute
0000180a-0000-1000-8000-00805f9b34fb Device Information
0000180f-0000-1000-8000-00805f9b34fb Battery Service
0000fff0-0000-1000-8000-00805f9b34fb Unknown
```

Connecting to the serial port at 115200 bps gives me a single string on boot:

```
-boot-
```

And here is the full `bluetoothctl` output for the device:

```
[NEW] Primary Service (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0008
	00001801-0000-1000-8000-00805f9b34fb
	Generic Attribute Profile
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0008/char0009
	00002a05-0000-1000-8000-00805f9b34fb
	Service Changed
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0008/char0009/desc000b
	00002902-0000-1000-8000-00805f9b34fb
	Client Characteristic Configuration
[NEW] Primary Service (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service000c
	0000180f-0000-1000-8000-00805f9b34fb
	Battery Service
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service000c/char000d
	00002a19-0000-1000-8000-00805f9b34fb
	Battery Level
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service000c/char000d/desc000f
	00002902-0000-1000-8000-00805f9b34fb
	Client Characteristic Configuration
[NEW] Primary Service (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010
	0000180a-0000-1000-8000-00805f9b34fb
	Device Information
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010/char0011
	00002a29-0000-1000-8000-00805f9b34fb
	Manufacturer Name String
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010/char0013
	00002a24-0000-1000-8000-00805f9b34fb
	Model Number String
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010/char0015
	00002a25-0000-1000-8000-00805f9b34fb
	Serial Number String
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010/char0017
	00002a27-0000-1000-8000-00805f9b34fb
	Hardware Revision String
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010/char0019
	00002a26-0000-1000-8000-00805f9b34fb
	Firmware Revision String
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service0010/char001b
	00002a28-0000-1000-8000-00805f9b34fb
	Software Revision String
[NEW] Primary Service (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d
	0000fff0-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char001e
	0000fff1-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char001e/desc0020
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0021
	0000fff2-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0021/desc0023
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0024
	0000fff3-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0024/desc0026
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0027
	0000fff4-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0027/desc0029
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char002a
	0000fff5-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char002a/desc002c
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char002d
	0000fff6-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char002d/desc002f
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0030
	0000fff7-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0030/desc0032
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0033
	0000fff8-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0033/desc0035
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0036
	0000fff9-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0036/desc0038
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0039
	0000fffa-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char0039/desc003b
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char003c
	0000fffe-0000-1000-8000-00805f9b34fb
	Alliance for Wireless Power (A4WP)
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char003c/desc003e
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
[NEW] Characteristic (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char003f
	0000ffff-0000-1000-8000-00805f9b34fb
	Unknown
[NEW] Descriptor (Handle 0x0000)
	/org/bluez/hci0/dev_BC_00_00_00_4C_D6/service001d/char003f/desc0041
	00002901-0000-1000-8000-00805f9b34fb
	Characteristic User Description
```

That is all I've got.
