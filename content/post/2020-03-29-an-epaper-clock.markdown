---
title: "An ePaper Clock"
date: 2020-03-29T12:54:42-07:00
---

I'm calling my ePaper (eInk) watch "done" (click on the image for a full resolution): 
[![epaper clock](/uploads/epaper_clock-thumb.jpg)](/uploads/epaper_clock.jpg)

It uses a [database of literary quotes](/epaper-watch-Cleaning-the-Literary-Quotes-Database/) to display what time it is, highlighting the quote in <font color="red">red</font>.

This project originally started as a wrist watch with battery management and a custom PCB:

[![epaper watch_prototype](/uploads/epaper_watch_prototype-thumb.jpg)](/uploads/epaper_watch.jpg)

The wrist watch version was too ambitious and too distracting, so I gave up and just left it as a wall-clock. Originally I took inspiration from this [clock that used a kindle](https://www.instructables.com/id/Literary-Clock-Made-From-E-reader/), but wanted more control over the hardware.

## Hardware

* 2.9inch (296x128 pixels) Waveshare eink [module](https://www.waveshare.com/wiki/2.9inch_e-Paper_Module_(B))
* esp8266 development board
* Picture frame

## Software

* [Source code](https://github.com/solarkennedy/epaper-watch)
* NTP-sourced time
* Ubuntu font
* Literary quotes for (most) minute of the hour

## Usage

It isn't the most accurate or easy to read clock, but it is interesting and looks nice when it has a good quote on it.

The refresh is a bit ugly and could be improved (click for the youtube version):

[![epaper clock refresh](/uploads/epaper_clock_refresh.gif)](https://www.youtube.com/watch?v=ptu6fU2wjEg)

The tri-color epaper requires two refresh cycles, one to clear the screen and put down black, then a second pass for the red. See [Ben Krasnow's (Applied Science) notes](https://benkrasnow.blogspot.com/2017/10/fast-partial-refresh-on-42-e-paper.html) on these epaper displays for some interesting low-level technical details on how they work.

