---
author: admin
comments: true
date: 2010-01-24 19:15:09+00:00
layout: post
slug: super-paper-mario-graph
title: Super Paper Mario - Chapter 2 Graph
wordpress_id: 431
categories:
- All
tags:
- nclug
---

My girlfriend plays an interesting Wii game called [Super Paper Mario](http://en.wikipedia.org/wiki/Super_Paper_Mario) where Mario can shift between a 2-dimensional and a 3-dimensional world. Pretty interesting. In chapter 2 section 4 there is a maze of rooms where one must find the last room, room 10. Of course there are walk-throughs all over the internet, but I had her read to me what room she was in, which door she walked through, and what in what room she emerged. Like this:


> "Room 9 BR" -> "Room 5 Top"


This means that Room 9's Bottom Right door drops you into Room 5's top door. I inputed all the all of the connections, and let one of my favorite programs, [graphviz](http://www.graphviz.org/) do the rest!

Using the graphviz mediawiki plugin, all I have to do is input the graph text into a page on my wiki, click save, and it will spit out a graphical version (click to see the full size):

[![](https://xkyle.com/wp-content/uploads/papergraph-255x300.png)](https://xkyle.com/wp-content/uploads/papergraph.png)

It could use some tweaking for the overlaps, but its pretty good as is if you ask me. It certainly gives you an insight into the developers thinking when creating the maze. This would certainly be very difficult to do on paper and have it come out clean.

[Here is the link to my actual wiki article](http://wiki.xkyle.com/Paper_Mario_Map). Feel free to edit the graph and click save to see what change happens. (You will have to create an account. Really feel free, I don't mind, edit away!)

And if you have some suggestions to make the graph look even better, just make them! I watch the recent changes rss feed and I will see it.
