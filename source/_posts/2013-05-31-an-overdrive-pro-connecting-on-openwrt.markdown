---
author: admin
comments: true
date: 2013-05-31 01:45:13+00:00
layout: post
slug: an-overdrive-pro-connecting-on-openwrt
title: An Overdrive Pro Connecting on OpenWrt
wordpress_id: 1013
categories:
tags:
- freedompop
- openwrt
---

Have a fancy [FreedomPop](http://www.freedompop.com/) Overdrive Pro? Want to hook it up to your OpenWrt based router to use as a backup (or primary?) internet connection? Lets do it.

Plug it into your router via USB. Then run:

    
    opkg install kmod-usb-net-cdc-ether


Run dmesg and it will report which eth device came up. Mine shows up as "eth1". Now make eth1 your "wan" interface:

    
    uci set network.wan.ifname=eth1
    uci commit
    reboot


Whoa.

Or, set it up as a second wan interface and use [Multiwan](http://wiki.openwrt.org/doc/uci/multiwan):

    
    uci set network.wan2=interface
    uci set network.wan2.proto=dhcp
    uci set network.wan2.ifname=eth1
    uci set network.wan2.dns=8.8.4.4, 8.8.8.8
    uci commit


Alternatively you could add it to your main bridge with a static ip and use it as an alternate gateway on a per-client basis. Or just plug it into a pc. Or just use the built-in wifi of the device itself, but who would want to do that?


