---
author: admin
categories: null
comments: true
date: 2009-09-30T20:12:35Z
slug: my-jar-of-fireflies
title: My Jar of Fireflies
wordpress_id: 397
---

I've seen a lot of electronic fireflies on the internet. [Here](http://negativeacknowledge.com/2008/10/18/led-fireflies-in-a-jar/), [here](http://www.instructables.com/id/Jar-of-Fireflies/), and probably others. The theory is simple, just small LED's [charlieplexed](http://en.wikipedia.org/wiki/Charlieplexing) with a microcontroller. I wanted to take it a step futher, with a light sensor, solar panel, and more complex firmware.

This is my first microcontroller project from scratch, and I got to learn all sorts of interesting things like SPI programming, Watchdog Timers, Sleep states, and many other things...

[![IMAG0001](/uploads/IMAG0001-300x225.jpg)](/uploads/IMAG0001.JPG)[![IMAG0002](/uploads/IMAG0002-300x225.jpg)](/uploads/IMAG0002-fireflies.JPG)

I wanted to flash more than just one firefly at a time, so I couldn't do true PWM with all 12 with an ATtiny85. So I came up with my own way to control varying levels of brightness. Also I wanted a light sensor so the fireflies could come out slowly during the night, and the quickly disappear when the lights come on. The hardware was pretty difficult to solder, involving stripping [magnet wire](http://www.radioshack.com/product/index.jsp?productId=2036277) and hand soldering SMD LEDs.

[![IMAG0016](/uploads/IMAG0016-300x225.jpg)](/uploads/IMAG0016.JPG)[![IMAG0005](/uploads/IMAG0005-300x225-fireflies.jpg)](/uploads/IMAG0005-fireflies.JPG)

Sorry for the poor pictures, my camera doesn't do well in low light.

[flashvideo file="video/fireflies.flv" /]

All the code is located [here](https://github.com/solarkennedy/fireflies). You can check it out using svn or just download it directly. I was hoping to use a solar panel to make them self-sufficient, but they required too much power for them to be useful unless they were in direct sunlight.

The parts list and schematic and more info are on my [wiki](http://wiki.xkyle.com/Fireflies).
