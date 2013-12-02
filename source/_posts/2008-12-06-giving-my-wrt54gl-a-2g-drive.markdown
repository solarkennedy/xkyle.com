---
author: admin
comments: true
date: 2008-12-06 22:05:55+00:00
layout: post
slug: giving-my-wrt54gl-a-2g-drive
title: Giving My WRT54GL a 2G Drive
wordpress_id: 178
categories:
tags:
- hacking
- hardware
- linksys
- nclug
- openwrt
- wrt54gl
---

The [WRT54GL](http://en.wikipedia.org/wiki/Linksys_WRT54G_series) is a pretty cool little toy. Yes it is a router with a cheezy web interface for grandmas with ESSID's named "linksys". But you can flash it with your own linux and solder in your own SD card to turn it from a 4MB machine to a 2GB machine... far out!

[![](/uploads/imag0053-300x225.jpg)](/uploads/imag0053.jpg)

Above it the bare board that I've unscrewed out of the thing. Some solder + a card.....

[![](/uploads/imag0060-300x225.jpg)](/uploads/imag0060.jpg)

Now we are talking. For the record this thing is exremely well documented and has a large userbase. I had no problems figureing out how to solder this in. If you want to go to the source of this type of documentation:

[http://wiki.openwrt.org/OpenWrtDocs/Hardware/Linksys/WRT54GL](http://wiki.openwrt.org/OpenWrtDocs/Hardware/Linksys/WRT54GL)

Now all I have to do is format and mount it...

[![](/uploads/screenshot-kylekyle-home-300x216.png)](/uploads/screenshot-kylekyle-home.png)

Holy cow it worked. 2G. Now all I have to do is [chroot into it](http://wiki.openwrt.org/OpenWrtDocs/KamikazeConfiguration/PackagesOnExternalMediaHowTo). Doing a time on a DD gives about 160kBytes/Second. Now I will turn this into something amazing........
