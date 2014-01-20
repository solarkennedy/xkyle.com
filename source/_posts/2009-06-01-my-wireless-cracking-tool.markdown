---
author: admin
comments: true
date: 2009-06-01 08:00:51+00:00
layout: post
slug: my-wireless-cracking-tool
title: My Wireless Cracking Tool
wordpress_id: 136
categories:
- security
- wep
- wifi
- wireless
---

I've become a semi-expert on wireless networking and their security features.. and how to get around them. Before I continue I want to emphasize:


> The act of cracking encryption is not illegal just like picking a lock is not illegal. It is the unauthorized access of that network which is illegal, just like breaking and entering is illegal.


So. To sum it up, there are two types of encryption. There is the weak kind ([wep](http://en.wikipedia.org/wiki/Wired_Equivalent_Privacy)) and the strong kind ([wpa](http://en.wikipedia.org/wiki/Wi-Fi_Protected_Access)). WEP can be broken in about 5-10 minutes. WPA can be broken in about 24 hours (as long as their password is in your password try-out list).

The actual process or hacking into a network like this requires a suite of tools called the [aircrack-ng suite](http://www.aircrack-ng.org). You can read their tutorials and such, and I highly recommend you do if you want to get into this sort of thing. It's a lot of FUN! Be prepared to learn linux while you are at it....

But, once you understand what you are doing, you will appreciate the tool I have written. It automates the process of getting the keys. I wrote it as a type of "set-it-and-forget-it" tool that I could just leave running. It isn't too clean, but if you can read bash scripting you can figure it out.

[caption id="attachment_137" align="aligncenter" width="500" caption="Here is a screen shot of my tool cracking wep"][![Here is a screen shot of my tool cracking wep](/uploads/screenshot.jpg)](/uploads/screenshot.jpg)[/caption]

Remember! Don't try to just run this tool without understanding what it does and how to read it. If you haven't breaking a wep key manually you don't want to run this. It does WEP and WPA cracking (saving the handshake for later). Good luck! I will provide minimal support via comments on this post. Don't forget to have your radio in monitor mode first, and if you are  going to do wpa you need the [mdk3](http://homepages.tu-darmstadt.de/~p_larbig/wlan/) tool.

Here is the download link to [Kyle's Wireless Cracking Tool](/other//superscanner.tgz).

Here is a link to a more updated versio of my [Cracking Tool](/other//superscanner2.tgz).
