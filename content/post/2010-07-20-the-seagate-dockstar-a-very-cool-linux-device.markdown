---
author: admin
categories:
- dockstar
- nclug
- openwrt
comments: true
date: 2010-07-20T05:35:25Z
slug: the-seagate-dockstar-a-very-cool-linux-device
title: 'The Seagate Dockstar: A Very Cool Linux Device'
wordpress_id: 511
---

What if I told you there was a computer out there, a small one, with gigabit ethernet, 4 USB 2.0 ports, runs on 5 watts, and serves as a great NAS (network attached storage) for your home.  It can share files, serve media, be a router, make backups for you, host a lamp stack, be a mail server, etc. It can do whatever you can think up.

[![](/uploads/dockstar.jpg)](/uploads/dockstar.jpg)

How much would you pay for such a neat little device? $100? $120? What if I told you that this device is ~$35. What a deal. Lose your P4 electricity guzzler and stick this on your shelf with some harddrives plugged into it.

Now the next question, what Linux distro should we use, and how does one go about installing it? After all, there is no keyboard ports, no display, no cdrom drive. No problem.

To hack this thing, all you need to do is connect to its internal serial port. Here are some instructions to hook up a [serial port to the Seagate Dockstar](http://wiki.xkyle.com/Seagate_Dockstar).

[![](/uploads/2010-07-19-23.31.22-300x224.jpg)](/uploads/2010-07-19-23.31.22.jpg)

Now, there are lots of distros, not too many that support the ARM processor. The stock OS is indeed Ubuntu 9.04, however my OS of choice for this hardware is [OpenWRT](http://openwrt.org). Openwrt is a very light, simple, linux distro, designed for embedded systems and routers.  If you wish to follow my steps, here are some instructions on [installing Openwrt on a Dockstar](http://wiki.xkyle.com/Install_Openwrt_on_a_Seagate_Dockstar). I plan to buy a bunch of these and build some sort of super cheap SAN. I'll let you know where it goes. The possibilities are only bounded by your imagination. (And I guess maybe the hardware)
