---
author: admin
categories:
- programming
- scripting
- security
comments: true
date: 2008-07-31T12:00:10Z
slug: dns-cache-poisoning
title: 'DNS Cache Poisoning '
wordpress_id: 96
---

Recently a DNS expert found a flaw in the way that DNS servers talk to other DNS servers to get records that allows interested parties (hackers) to insert their own records. If you need a primer: the [Wikipedia link](http://en.wikipedia.org/wiki/DNS_cache_poisoning).

Well... a DNS flaw is no fun without a tool to use it. So this guy "HD Moore" wrote a program (script) that takes advantage of this and makes it relatively easy for someone to use something called [Metasploit](http://www.metasploit.com/framework/) to tinker with it. Cool!

Turns out that it works, and people are fixing their DNS servers so that this can't happen. (I fixed mine as soon as the fix was out.) But not everyone can fix their own, often they are at the mercy of their ISP's. (Have you ever called up your ISP's help desk and told them they need to upgrade their DNS servers to protect them against cache poisoning? Heheheh.. right)

So one day, Mr. Moore goes to google.com on his computer at work, and guess what, its not the real google.com...

[The news article](http://www.networkworld.com/news/2008/073008-dns-attack-writer-a-victim.html)

Well played sir. Well played.
