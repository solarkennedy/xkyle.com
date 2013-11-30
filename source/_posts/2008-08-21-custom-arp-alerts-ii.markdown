---
author: admin
comments: true
date: 2008-08-21 11:59:57+00:00
layout: post
slug: custom-arp-alerts-ii
title: Custom Arp Alerts II!
wordpress_id: 112
categories:
- All
tags:
- All
- nclug
- programming
- scripting
- security
---

So I've found a better way to do what I did in the previous post. Instead of running a separate script to parse the arp alert logs, I have arp alert itself send the alerts! The key is this line in the arpalert.conf





> 

> 
> action on detect = "/etc/scripts/arp-alert"
> 
> 





Its so simple, it just runs that script sending the information about the alert as certain arguments. With this I have more control over the formatting of arpalert messages:




[![](https://xkyle.com/wp-content/uploads/screenshot2.png)](https://xkyle.com/wp-content/uploads/screenshot2.png)




In order to do this, I had to write that script, and make it executable of course. Also I had to change the running user of arpalert to root, because the "arpalert" user didn't have permission to notify my user "kyle". This is a much more clean solution, allowing me to make different types of alerts look different, having different timeouts and such. If you want my /etc/scripts/arp-alert you can download what I have so far [here](https://xkyle.com/other/arp-alert).
