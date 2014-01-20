---
author: admin
comments: true
date: 2008-12-05 17:17:50+00:00
layout: post
slug: my-home-made-laptop-security-program
title: 'My Home-Made Laptop Security Program '
wordpress_id: 174
categories:
- eeepc
- nclug
- security
---

The NetworkManager program in linux has a create feature called a dispatcher, which can run arbitrary programs when certian things about the network change. For instance it can turn on a firewall or notify a user when the network comes up, or [start up an arp alert program](/custom-arp-alerts-ii/)!

I wanted a program that would alert me of my laptop's where-a-bouts, as well as use the webcam to take a picture, in order to aid me in tracking it down if it got stolen. I wanted something simple and didn't way to pay for anything... I know I'm cheap :)

The code is pretty simple:

```bash
    fswebcam -F 2 -S 1 -r 640x480 --jpeg 60 --save /tmp/capture.jpg
    ifconfig > /tmp/ifconfig.txt
    wget -q -O - checkip.dyndns.org >> /tmp/ifconfig.txt
    FILENAME=`date +%F-%H-%M-%S`
    mv /tmp/ifconfig.txt /tmp/$FILENAME.txt
    mv /tmp/capture.jpg /tmp/$FILENAME.jpg
    scp /tmp/$FILENAME.jpg /tmp/$FILENAME.txt root@X.0.0.0:OBSCURED FOR SECURITY REASONS
    rm /tmp/$FILENAME.jpg /tmp/$FILENAME.txt
```

You can see that it takes a picture, grabs my ifconfig and public ip, then ships it all to my server.  I just saved it in my /usr/local/bin/ and added the program to my /etc/network/if-up.d/openvpn program. This program is called whenever the interface comes up, so it will also run this program too when it's ready.

[![](/uploads/2008-12-05-11-51-571-300x225.jpg)](/uploads/2008-12-05-11-51-571.jpg)

It's not amazing, but its good. Feel free to take my script and adjust for your needs. You may have a different command-line tool to take a picture with your webcam or whatever. You could even go crazy and setup something to email you or whatver, its YOUR program!
