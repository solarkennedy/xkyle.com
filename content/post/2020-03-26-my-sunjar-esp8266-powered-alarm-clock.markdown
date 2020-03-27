---
title: "My Sunjar - An esp8266-Powered Light Alarm Clock"
date: 2020-03-26T12:54:42-07:00
draft: true
---

This is my Sunjar ([code](https://github.com/solarkennedy/sunjar)).
Inspired by those (expensive) [light alarm clocks](https://www.amazon.com/Philips-Simulation-Headspace-Subscription-HF3520/dp/B0093162RM), my Sunjar gently wakes me up in the morning to this:

[![Sunjar ocean pattern](/uploads/sunjar_ocean.gif)](/uploads/sunjar_ocean.gif)

## Features

This is my alarm clock, so I can put in the features that *I* want:

* NTP-synced time. Never forget about DST again. Always accurate.
* Wakeup by ocean light, with a 1-hour brightness ramp-up.
* Capacitive touch-sensitive override - still snooze if I want to, just touch the jar
* 1-hour red-light sleep timer for going to bed
* Cool patterns during the day

## Wakeup / Sleep Time Algorithm

## Capacitive Touch Sensor

The Sunjar is just a heavily frosted mason jar, and it has a stainless steal rim.
By connecting this rim to particular pins on the microcontroller, I can use the rim as a capacitive touch sensor, detecting when humans (or cats) touch the jar.

The electrical schematic for this is extremely simple, requiring only two pins and a resistor:

[![Sunjar Schematic](/uploads/sunjar_schematic.png)](/uploads/sunjar_schematic.png)

## A Love Letter to "Pacifica", the ocean pattern

"Pacifica" is the name of the ocean pattern. It powers the wakeup mode (with the ocean-inspired pallette) as well as the sleep mode (with a fire-inspired pallette).

{{< youtube ydqEkpHzb54 >}}
