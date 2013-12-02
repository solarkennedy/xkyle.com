---
author: admin
comments: true
date: 2010-08-01 05:07:57+00:00
layout: post
slug: computer-assisted-jenga-with-the-wii-balance-board-and-linux
title: Computer Assisted Jenga with the Wii Balance Board and Linux
wordpress_id: 518
categories:
tags:
- cwiid
- nclug
- pygame
- python
- wii
---

I like to think about how games work, in the case of [Jenga](http://en.wikipedia.org/wiki/Jenga), it is just physics!

But don't you wish you could peel back reality and see what is happening with the physics from the inside? Well now you can, with the help of a Wii Balance Board.

[![](/uploads/wii-jengasetup-300x224.jpg)](/uploads/wii-jengasetup.jpg)

For the setup you need these ingredients:



	
  * Wii Balance Board

	
  * Computer with Bluetooth

	
  * Linux, preferably Ubuntu

	
  * Jenga Set, alternatively "[Tension Tower](http://www.argos.co.uk/static/Product/partNumber/3904172.htm)"

	
  * Some know-how to compile a trunk version of [Cwiid](http://abstrakraft.org/cwiid/)

	
  * Some other python stuff (see the build instructions for details)

	
  * [And my code](http://wiki.xkyle.com/WiiJenga)


I'm going to maintain all instructions on how to setup all the technical details on my wiki: [http://wiki.xkyle.com/WiiJenga](http://wiki.xkyle.com/WiiJenga)

Once you have it setup, you can see where the real center of balance is of your game, and you can tell how close it is to toppling over.

In reality, the balance board isn't quite sensitive enough to very accurately detect the center of balance of the Jenga blocks, or detect how many Jenga blocks there are, but it is fun to watch:


