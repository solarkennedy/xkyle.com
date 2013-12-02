---
author: admin
comments: true
date: 2008-11-15 02:17:33+00:00
layout: post
slug: n2n-peer-to-peer-vpn
title: n2n - Peer to peer VPN?
wordpress_id: 156
categories:
tags:
- nclug
- security
- vpn
---

Most vpns... in fact... all of them, are based on a client/server model. This means that all vpn clients call home to one vpn server and connect. All traffic goes through that vpn server and then gets passed on to its original destination. But what if you could have the benefits of VPN, but be able to communicate directly to other VPN peers, so without the latency and bandwidth limitations?

[![](/uploads/2.png)](/uploads/2.png)

That is what [n2n](http://www.ntop.org/n2n/) is. The supernodes are NOT servers. They merely function as a way to punch holes in firewalls. Once the firewalls are open, the edge servers (think of them as clients) can talk directly with other edge clients. Cool!

I've tried this, and so far the only draw back is the speed, it just doesn't seem to be as fast as you would think it would be. I can't find any other people complaining about it, but I'll look into it. But so far this is the simplest vpn I've ever setup. Its a single command!
