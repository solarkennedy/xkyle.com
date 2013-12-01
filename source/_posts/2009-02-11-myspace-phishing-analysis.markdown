---
author: admin
comments: true
date: 2009-02-11 22:40:10+00:00
layout: post
slug: myspace-phishing-analysis
title: Myspace Phishing Analysis
wordpress_id: 251
tags:
- All
- Myspace
- passwords
- security
---

[![](/uploads/myspace.jpeg)](/uploads/myspace.jpeg)

A couple of years ago, a large list of phished Myspace accounts was leaked on the internet.
I stumpled upon them and ran a very simple analysis. Check it out:


> root@a:/# cat myspace.hackedlist | cut -f 2 -d : | sort | uniq -c | sort -n | tail -n 20
14 qwerty1
15 123456a
15 babygirl1
15 blink182
16 123456
16 123abc
16 iloveyou2
17 football1
17 nicole1
18 number1
19 password
23 myspace1
24 fuckyou1
28 iloveyou1
28 monkey1
29 fuckyou
54 abc123
74 password1


The file was in the form of "Username:password", so the first part of that command "cuts" the second column, with the colon as the delimiter. Then it is piped through sort, which sorts the list alphabetcially, then the uniq -c command, which counts the number of times that a word shows up, then I sort it again to get the most freqent passwords, and tail the last 20 lines.

It is interesting to see that a lot of these passwords just tack "1" on to them. And of course blink182 was all the rage back then aparently...
