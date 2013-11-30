---
author: admin
comments: true
date: 2009-03-03 18:58:33+00:00
layout: post
slug: verizon-fios-wireless-key-calculator
title: Verizon FiOS Wireless Key Calculator!
wordpress_id: 276
categories:
- All
tags:
- aircrack
- nclug
- wep
- wireless
---

More Update: There are new AP's that don't conform to this pattern. If the calculator doesn't work on yours, maybe it is like these [non-conforming-wep](https://xkyle.com/2010/04/02/help-wanted-what-is-the-pattern-in-these-new-wep-keys/) keys

Update:  A cool cool guy named Dylan Taylor wrote a java implementation of this script: [http://www.fwc.dylanmtaylor.com/](http://www.fwc.dylanmtaylor.com/) if you need an offline version

Update: I wrote a bash implementation to make it easy to script, and for offline usage: [https://xkyle.com/other/fioscalc.sh](https://xkyle.com/other/fioscalc.sh)

In my [previous post](https://xkyle.com/2009/02/07/verizon-fios-wireless-security-analysis/) I showed a correlation between the WEP key of a Verizon FiOS install and the MAC address of the access point. This was simply a collection of experimental data that I gathered.

Thanks to [Fred Williams?](http://www.linkedin.com/pub/dir/Fred/Williams?trk=ppro_find_others) for pointing out the correlation between the ESSID and the WEP. With these powers combined form:
[![captain-planet](https://xkyle.com/wp-content/uploads/captain-planet-185x300.jpg)](https://xkyle.com/wp-content/uploads/captain-planet.jpeg)

Well.. Not exactly. If there was a super hero with the phrase: "Hack the Planet" instead of "Save the Planet" I would have chosen it.

So what is the deal?

[![](https://xkyle.com/wp-content/uploads/verizon_fios_250.jpg)](https://xkyle.com/wp-content/uploads/verizon_fios_250.jpg)

The first part of the key is a combination of the second and third part of the MAC, which is either 1801 or 1F90.

The second part of the key is this forumula.. hold on to your butts:


> The 5-character SSID name is a base-36 number of the lower 48 bits (6 hex digits) of the WEP key. The string is reversed, with the most significant digit on the right.

Base-36 numbers uses 0-9 followed A-Z to represent 36 digits (0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ)
It maps out like this:
    0=00, 1=01, 2=02, 3=03, 4=04, 5=05,
    6=06, 7=07, 8=08, 9=09, A=10, B=11,
    C=12, D=13, E=14, F=15, G=16, H=17,
    I=18, J=19, K=20, L=21, M=22, N=23,
    O=24, P=25, Q=26, R=27, S=28, T=29,
    U=30, V=31, W=32, X=33, Y=34, Z=35

To go through an example, the SSID name of “E3X12″ comes out as follows.

    E*(36^0) is 14 * 1 = 14
    3*(36^1) is 03 * 36 = 108
    X*(36^2) is 33 * 1296 = 42,768
    1*(36^3) is 01 * 46656 = 46,656
    2*(36^4) is 02 * 1679616 = 3,359,232
Add these up, and you get 3,448,778 decimal which is 349FCA in Hexadecimal notation.
The first 4 hex digits of the WEP key are the 2nd and 3rd byte from the MAC address as indicated in the original post above.


Thanks again Fred! To math majors this is like a beam of light coming down from the heavens

[![lightbeam](https://xkyle.com/wp-content/uploads/lightbeam.jpg)](http://www.flickr.com/photos/dorowski/456250234/)
So I wrote this Javascript calculator (my first javascript program actually) in order to aid the calculation of the keys! Just type in your neighbor's ESSID and out comes the KEY!
(Sorry about the iframe if that is an issue to you. Goto [here](https://xkyle.com/other/wep.html) if it is.)
Your browser does not support iframes.
Want to try it out? Here is a list of keys I've collected in my travels. Theres are cracked with Aircrack-ng, not calculated.


> E3X12,1801349FCA
NAMX2,18014B311F
MWXV2,180149FF66
R0LC7,1801BC5C6B
JE2K7,1801C1B02B
HH150,1F900396C5
3RA18,1801CDF4AF
OQ838,1801CF5700
7WY20,1F90021D27
C7WA0,1F9007C188
DJP80,1F90063349
BJ2Z0,1F9018F797
RSHZ0,1F901944DB
