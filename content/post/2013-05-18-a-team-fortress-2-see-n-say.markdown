---
author: admin
categories:
- arduino
- Personal
- See N Say
- Team Fortress 2
comments: true
date: 2013-05-18T21:12:21Z
slug: a-team-fortress-2-see-n-say
title: A Team Fortress 2 See 'n Say!
wordpress_id: 977
---

Hopefully Valve will offer me a job instead of suing me? :)


## Teardown




## [gallery ids="991,992,993,994,995,996,999,1001,1002,1000,1003,997"]




## Parts





	
  * Many [See N' Says](http://en.wikipedia.org/wiki/See_'n_Say) to destroy (I burned through 3)

	
  * An [Arduino](http://arduino.cc/en/) (yes, because I'm a lazy noob)

	
  * [Wave shield](http://www.ladyada.net/make/waveshield)

	
  * Some sort of ISP programmer

	
  * Speaker / Switch / Hot-glue / Resistors / etc




## How It Works





	
  * A user pulls the handle, activating the normally-open switch and powering the arduino

	
  * When the handle is released and the spinner starts spinning, a resistor sensor detects at least two succsessive reistor changes, indicating that the spinner is in motion and noting the first value of the resistor for the next step

	
  * The wave shield plays a prelude for the class, "The scout says..." and a random wave file in the "Scout" folder.

	
  * By the time the handle gets back to the top, the wave file is over, the spinner stops spinning, and the swich is pushed open again, to power everyhing off and save the batteries.




## Battery Math





	
  * .09 Amps * 5 Volts = .45 Watts

	
  * .45 Watts * 6 Seconds per Spin = 2.7 Joules per Spin

	
  * 4 Batteries * 9,000 Joules per Battery = 36,000 Joules

	
  * 36,000 Joules / 2.7 Joules per Spin = 13,333 Spins?


Realistically the batteries will ooze before we run out of juice?


## Source Code


Source code is on my [Github](https://github.com/solarkennedy/TeamFortress2-SeeNSay). Includes code for extracting sounds from TF2 and Arduino code.
