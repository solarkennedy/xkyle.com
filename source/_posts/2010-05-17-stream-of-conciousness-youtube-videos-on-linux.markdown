---
author: admin
comments: true
date: 2010-05-17 03:20:20+00:00
layout: post
slug: stream-of-conciousness-youtube-videos-on-linux
title: Stream of Conciousness Youtube Videos on Linux
wordpress_id: 502
categories:
- All
tags:
- nclug
- totem
- youtube
---

While sitting watching TV I yearned for a more [stream-of-consciousness](http://en.wikipedia.org/wiki/Stream_of_consciousness_%28psychology%29) experience. Youtube was the answer.

However, Youtube requires too much interaction. I wanted to vege out and let it just feed me the stream of random images and sound. Selecting purely random youtube videos sounded like a bad idea though...

I decided to do a twitter search for anything with a youtube link, and then let a script just enqueue them into totem, ad-infinitum. Here is my abomination:

    
    #!/bin/bash
    while [ 1 ]; 
    do
     for EACHVIDEO in `wget -O - -q "http://search.twitter.com/search.atom?q=youtube.com" | grep http://www.youtube.com | grep "<content" | sed 's/quot;/\n/g' | grep "http://www.youtube.com" | cut -f 1 -d "&" `
     do
     totem --enqueue `youtube-dl -g -b "$EACHVIDEO" ` &
     sleep  2s
     done
     sleep 30s
    done
    


You need a recent version of the youtube-dl script, located [here](http://bitbucket.org/rg3/youtube-dl/wiki/Home). Put it in your path as appropriate. Press N for next! Next! Next!

    
    
    
    
