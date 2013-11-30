---
author: admin
comments: true
date: 2009-02-07 18:29:04+00:00
layout: post
slug: verizon-fios-wireless-security-analysis
title: Verizon FiOS Wireless Security Analysis
wordpress_id: 243
categories:
- All
tags:
- aircrack
- All
- hacking
- nclug
- scripting
- wep
---

[![](https://xkyle.com/wp-content/uploads/verizon_fios_250.jpg)](https://xkyle.com/wp-content/uploads/verizon_fios_250.jpg)

Take a look at some wireless keys that I've collected from some Verizon FiOS installs around Tampa:


> 00-18-01-EA-3D-99,E3X12,6,WEP,1801349FCA
00-18-01-F0-6D-C4,NAMX2,1,WEP,18014B311F
00-18-01-F0-95-78,MWXV2,11,WEP,180149FF66
00-18-01-FD-4F-0E,R0LC7,1,WEP,1801BC5C6B
00-18-01-FE-15-46,JE2K7,1,WEP,1801C1B02B
00-18-01-FF-DF-DD,HH150,1,WEP,1F900396C5
00-1F-90-E0-B1-F8,3RA18,6,WEP,1801CDF4AF
00-1F-90-E0-B5-AC,OQ838,6,WEP,1801CF5700
00-1F-90-E2-7E-61,7WY20,6,WEP,1F90021D27
00-1F-90-E3-1E-90,C7WA0,6,WEP,1F9007C188
00-1F-90-E3-2E-07,DJP80,6,WEP,1F90063349
00-1F-90-E6-A7-D5,BJ2Z0,11,WEP,1F9018F797
00-1F-90-E6-D4-E3,RSHZ0,4,WEP,1F901944DB


What you are looking at here is MAC, SSID, Channel, Encryption, Key.

Notice that they are all WEP, 64bit, with 5 Alpha numeric SSID's.

I want to emphasize that these are the defaults, and only geeks, nerds and the like change the defaults. :)

Here is a typical type of router (actiontec) that does this:

[![](https://xkyle.com/wp-content/uploads/mi424wr-300x216.gif)](https://xkyle.com/wp-content/uploads/mi424wr.gif)

Take a real close look at two of the examples:


> 00-18-01-FE-15-46,JE2K7,1,WEP,1801C1B02B
00-1F-90-E2-7E-61,7WY20,6,WEP,1F90021D27


Notice the relationship the MAC and the key have. Let me split up the bytes for you:


> 00:18:01:FE:15:46   -  18:01:C1:B0:2B


Verizon, or Actiontec, or someone is setting the first byte of the 40bit key to the second byte of the MAC of the unit. And then they are setting the second byte of the key to the third byte of the MAC!

You can look on the list, and this is mostly the case, there is some overlap on the OIDs. (sometimess it is 1801, sometimes 1f90) Why is this useful? Well if you know it is a FiOS install, you have already decreased your "64bit" key to a real "40bit" key, and you already know 16 bits of it, so you only have to crack 24 bits. This is insane. This is like guessing 3 letters.

The way to use this is with the [Aircrack-ng](http://www.aircrack-ng.org) program. Capture some packets, and use the -d option to tell it what the key starts with.


> aircrack-ng -d 1801 stupid-fios.cap


You will get the key in No time! Silly Verizon, you didn't think we would notice you weren't using constructed (not random) keys?

Have FiOS yourself? Want to share your MAC and default key in the comments? :)


> 
