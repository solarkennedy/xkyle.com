---
categories:
- etherhouse
comments: true
date: 2014-11-16T16:28:24Z
title: Etherhouse Part 2 - Software
---

The software that powers the Etherhouse project is open source. This blog
post describes that software and how it interacts with all the pieces. 

## Client

You can see the [Client software](https://github.com/solarkennedy/ether_house)
that runs on the Arduino. This uses one external library and is in the native
Arduino C++.

The Arduino runs a limited TCP/IP stack and interacts with the http api.

The code plenty of defensive code in place to ensure the client continues to run
without interruption or interaction. No one should need to "turn it off and on
again."

## Server

The [Server software](https://github.com/solarkennedy/ether_housed) is also open
source.

In designing the software, I aimed for longevity. I want the software to
continue to run for many years without maintenance. I decided to use golang. 

* Go binaries are statically compiled, which means the same binary I compile now
  will continue to run on new platforms for years to come.
* With godeps I can include all compatible libraries together with no external
  dependencies, regardless of their long term state.
* I use Heroku to deploy the code. Heroku is free for small installs and a
  stable platform. They can probably keep this server up better than I can.
* I use a DNS name I can control for service discovery. This gives me the
  flexibility to change platforms over time if necissary.

