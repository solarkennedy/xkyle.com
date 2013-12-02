---
author: admin
comments: true
date: 2013-01-06 23:16:33+00:00
layout: post
slug: cool-things-to-do-after-installing-openwrt
title: Cool Things to Do After Installing OpenWrt
wordpress_id: 830
categories:
tags:
- openwrt
- plug computers
- pxe
- security
---

[OpenWrt](https://openwrt.org/) is the bomb. Think all the power of a full Linux distro on your tiny home router or plug computer.


# Install an External Root Overlay


What the heck does that mean? OpenWrt uses an ingenious system were the root filesystem is a super compressed squashfs, merged with a read/write jffs2 filesystem called the overlay. This maximizes your available space on the device. Instead of using part of your remaining flash for read/write, you can use a larger, external device for the overlay.

Lots of modern routers have USB ports. Special bonus points if you hack on an SD card mod to a device using only GPIO, like the venerable [WRT54G](http://wiki.openwrt.org/toh/linksys/wrt54g#adding.an.mmcsd.card).

Instructions: [http://wiki.openwrt.org/doc/howto/extroot](http://wiki.openwrt.org/doc/howto/extroot)


# Security Tools


A classic thing to do with any linux device, install every security tool there is. Apparently there are people out there who make a killing pre-installing security tools on small linux devices and selling them back to people who are ignorant of the ways of "opkg install nmap"

You are smarter than that. If you know if a security tool, there is probably a package for it for you to "opkg install". If not, do the world a favor and port it and upload your makefile to the OpenWrt devel mailing list.

Instructions: [http://wiki.openwrt.org/doc/howto/wireless.overview](http://wiki.openwrt.org/doc/howto/wireless.overview)


# Make a PXE Boot Server


Believe it or not, a stock OpenWrt install has all the pieces necessary to be a PXE boot server, out of the box. Dnsmasq is awesome.

My Instructions: [https://wiki.xkyle.com/OpenWrt_PXE_Server
](https://wiki.xkyle.com/OpenWrt_PXE_Server)Official Documentation: [http://wiki.openwrt.org/doc/uci/dhcp](http://wiki.openwrt.org/doc/uci/dhcp)


# [ ](https://wiki.xkyle.com/OpenWrt_PXE_Server)Make a Guest Hotspot


This is a cool thing to do. Once only a feature the highest end wireless routers, now possible with almost any router with OpenWrt.

Instructions: [http://wiki.openwrt.org/doc/recipes/guest-wlan](http://wiki.openwrt.org/doc/recipes/guest-wlan)
