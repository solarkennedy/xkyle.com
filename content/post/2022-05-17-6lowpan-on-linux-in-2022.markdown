---
title: "Configuring 6LoWPAN on Linux in 2022"
date: 2022-05-17T00:00:00-00:00
---

[6LoWPAN](https://en.wikipedia.org/wiki/6LoWPAN) is a networking protocol that enabled IPv6 connectivity over [IEEE 802.15.4](https://en.wikipedia.org/wiki/IEEE_802.15.4) instead of [802.11](https://en.wikipedia.org/wiki/IEEE_802.11).

This low energy network spec shoves IPv6 + Link layer encryption on top of Bluetooth low energy.

But wait, there are actually two types of connections here, and the landscape is confusing due to the different options.

- [RFC7668](https://datatracker.ietf.org/doc/html/rfc7668) is IPv6 over Bluetooth LE
- [RFC4944](https://datatracker.ietf.org/doc/html/rfc4944) is IPv6 over 802.15.14

6LoWPAN seems to encompass any type of IPv6 over low energy network setup.
(both of the above)
Many laptops with modern Bluetooth chips can do the first one.
An embedded device or special purpose hardware can do the latter.

This blog post will only be focusing on the first one, using Bluetooth LE.

I tried networking Linux devices together in [2015]({{< ref "2015-06-14-playing-with-ipv6-over-bluetooth-low-energy-6lowpan" >}}) using this spec, and achieved partial success. 
But now it is 2022, and even [NetworkManager](https://www.phoronix.com/scan.php?page=news_item&px=NetworkManager-6LoWPAN) supports 6LoWPAN.
In the new hot world of IOT, can we have Bluetooth LE IPv6 Networks on Linux?



<table>
<tr><td> Master Node </td> <td> Slave Node </td></tr>
<tr><td>

```bash-session
modprobe bluetooth_6lowpan
echo 1 > /sys/kernel/debug/bluetooth/6lowpan_enable
# Advertise over LE
hciconfig hci0 leadv
...
...
...
# Ping all IPv6 nodes on the network
ping6 ff02::1%bt0
```
</td><td>

```bash-session
modprobe bluetooth_6lowpan
echo 1 > /sys/kernel/debug/bluetooth/6lowpan_enable
# Scan to find the HW address of the master
hcitool lescan
...
# Connect to the master
echo "connect C4:85:08:31:XX:XX 1" >/sys/kernel/debug/bluetooth/6lowpan_control
...
...
```

</td></tr>
</table>

It does work.

For my tests I'm not even bothering with assigning IPs, I just use the link-local addresses.

Latency does seem a little high between two laptops that are right next to each other:

```bash-session
# ping6 fe80::c485:8ff:fe31:7e77%bt0 -c 10
PING fe80::c485:8ff:fe31:7e77%bt0(fe80::c485:8ff:fe31:7e77%bt0) 56 data bytes
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=1 ttl=64 time=78.3 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=2 ttl=64 time=52.7 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=3 ttl=64 time=74.7 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=4 ttl=64 time=96.8 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=5 ttl=64 time=70.1 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=6 ttl=64 time=92.8 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=7 ttl=64 time=66.1 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=8 ttl=64 time=88.7 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=9 ttl=64 time=62.0 ms
64 bytes from fe80::c485:8ff:fe31:7e77%bt0: icmp_seq=10 ttl=64 time=84.8 ms

--- fe80::c485:8ff:fe31:7e77%bt0 ping statistics ---
10 packets transmitted, 10 received, 0% packet loss, time 9012ms
rtt min/avg/max/mdev = 52.745/76.707/96.793/13.508 ms
```

Packet loss seems bad. Super bad.
`iperf` gets worse the longer you run it.

```bash-session
# iperf -c fe80::c485:8ff:fe31:7e77%bt0 -V 
------------------------------------------------------------
Client connecting to fe80::c485:8ff:fe31:7e77%bt0, TCP port 5001
TCP window size: 45.0 KByte (default)
------------------------------------------------------------
[  1] local fe80::f8ff:c2ff:fe50:f6a8 port 47580 connected with fe80::c485:8ff:fe31:7e77 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-20.5697 sec  80.3 KBytes  32.0 Kbits/sec
```

UDP seems much faster, but I'm skeptical:

```bash-session
# iperf -c fe80::c485:8ff:fe31:7e77%bt0 -V  -u
------------------------------------------------------------
Client connecting to fe80::c485:8ff:fe31:7e77%bt0, UDP port 5001
Sending 1450 byte datagrams, IPG target: 11062.62 us (kalman adjust)
UDP buffer size:  208 KByte (default)
------------------------------------------------------------
[  1] local fe80::f8ff:c2ff:fe50:f6a8 port 34445 connected with fe80::c485:8ff:fe31:7e77 port 5001
[ ID] Interval       Transfer     Bandwidth
[  1] 0.0000-10.0118 sec  1.25 MBytes  1.05 Mbits/sec
[  1] Sent 908 datagrams
read failed: Connection refused
[  3] WARNING: did not receive ack of last datagram after 10 tries.
```

In practice, the TCP communication seems only unidirectional.
Typing into `nc` into a client on the slave to a listener on the master node works fine.
The other direction doesn't seem to work at all.
Yet `ping6` works?
It seems to only work with a 1280 MTU, no pings on any other MTU.

Still requires some more investigation.
