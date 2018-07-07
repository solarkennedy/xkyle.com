---
categories: null
comments: true
date: 2015-06-14T18:18:03Z
title: Playing with IPv6 Over Bluetooth Low Energy (6LoWPAN)
---

I like Bluetooth Low Energy (BTLE). I also like IPv6. Did you know you could but both together?

Technically 6LoWPAN

## Requirements

    modprobe bluetooth_6lowpan
    echo 'bluetooth_6lowpan' >> /etc/modules

## Establishing the Connection

### Set the Bluetooth L2CAP PSM

First you need to set the Protocol/Service Multiplexer value on both sides to "62" (0x3E) on both sides:

    echo 62 > /sys/kernel/debug/bluetooth/6lowpan_psm

This PSM value lets the driver know that you are going to multiplex this special
new protocol on top of whatever your bluetooth device mith also be doing.

0x25 is the magic value for "Internet Protocol Support Profile"
https://www.bluetooth.org/en-us/specification/assigned-numbers/logical-link-control
which I think is supposed to be the correct value?

0x3E is some sort of temporary value I had to use to get this working, as 0x25 ended up
as a being not supported per the messages in my wireshark dump.

I'm not aware of any other way to set it other than this kernel debug setting.

### Making the slave advertise

The slave must be doing Low-Energy advertisements in order for the master to connect to it.

    hciconfig hci0 leadv

### Connect

On the master you should be able to watch the slave advertise:

    ⮀hcitool lescan
    LE Scan ...
    C4:85:08:31:XX:XX (unknown)
    C4:85:08:31:XX:XX ubuntu-0

Establish a connection from the master to the slave:

    echo "connect C4:85:08:31:XX:XX 1" >/sys/kernel/debug/bluetooth/6lowpan_control

Afterwards a bt0 device should show up in ifconfig. Run `hcitool conn` to verify
a connection is actually established. Use wireshark on bluetooth mon mode on the
hci device to confirm commands are being sent.

The proof is in the ping:

    ~ ⮀ # ⮀ping6 fe80::1610:9fff:fee0:1432%bt0
    PING fe80::1610:9fff:fee0:1432%bt0(fe80::1610:9fff:fee0:1432) 56 data bytes
    64 bytes from fe80::1610:9fff:fee0:1432: icmp_seq=1 ttl=64 time=158 ms
    64 bytes from fe80::1610:9fff:fee0:1432: icmp_seq=2 ttl=64 time=236 ms
    64 bytes from fe80::1610:9fff:fee0:1432: icmp_seq=3 ttl=64 time=113 ms

## Problems

After a small number of packets, the connection seems to drop, and on the master side
I get:

    [  368.947193] Bluetooth: hci0 link tx timeout
    [  368.947202] Bluetooth: hci0 killing stalled connection c4:85:08:31:XX:XX

No matter what rmmod or stopping I tried, a reboot was the only thing I could to
rebuild the connection. Obviously this is pretty new stuff, hopefully it will
stabilize in later versions of the kernel.

At this time though, on 3.19.0-21-generic (Ubuntu Vivid), this feature is not
yet usable.
