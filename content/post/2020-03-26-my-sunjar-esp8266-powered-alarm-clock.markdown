---
title: "My Sunjar - An esp8266-Powered Light Alarm Clock"
date: 2020-03-26T12:54:42-07:00
---

This is my Sunjar ([code](https://github.com/solarkennedy/sunjar)).
Inspired by those (expensive) [light alarm clocks](https://www.amazon.com/Philips-Simulation-Headspace-Subscription-HF3520/dp/B0093162RM), my Sunjar gently wakes me up in the morning to this (click to see a youtube version):

[![Sunjar ocean pattern](/uploads/sunjar_ocean.gif)](https://www.youtube.com/watch?v=fExAfrpSHGU)

And then fall asleep to flames:
[![Sunjar fire pattern](/uploads/sunjar_flames.gif)](https://www.youtube.com/watch?v=G6xP6r_RCTU)

## Features

This is *my* alarm clock, so I can put in the features that *I* want:

* NTP-synced time. Never forget about DST again. Always accurate.
* Wakeup by ocean light, with a 1-hour brightness ramp-up.
* Capacitive touch-sensitive override - snooze if I want to, just touch the jar
* 1-hour red-light sleep timer for going to bed
* Cool patterns during the day
* Over the air (OTA) firmware updates

## Hardware

* An esp8266 (Wemos W1 Clone)
* 5 WS2812 LEDs
* 1 50M ohm resistor

## Wakeup / Sleep Time Algorithm

I decided I only needed two different wakeup times, one for weekedays, one for weekends.

If you would like to see a fancier light alarm clock with a web interface to set custom alarms, check out [this soothing alarm clock](https://www.instructables.com/id/SootheRefresh-Smart-Lamp/).

## Capacitive Touch Sensor

The Sunjar is just a heavily frosted mason jar and it has a stainless steal rim.
By connecting this rim to particular pins on the microcontroller, I can use the rim as a capacitive touch sensor, detecting when humans touch the jar.

The electrical schematic for this is extremely simple, requiring only two pins and a resistor:

[![Sunjar Schematic](/uploads/sunjar_schematic.png)](/uploads/sunjar_schematic.png)

My code easy to write thanks to a [library](https://github.com/PaulStoffregen/CapacitiveSensor) that handles the hard parts.

This touch sensor serves to override the lamp, for when I want to sleep early, use it as a night light, or need to snooze in the morning.

## A Love Letter to "Pacifica", the ocean pattern

"Pacifica" is the name of the ocean pattern. It powers the wakeup mode (with the ocean-inspired palette) as well as the sleep mode (with a fire-inspired palette):

{{< vimeo 379376339 >}}

[Written by Mark Kriegsman](https://gist.github.com/kriegsman/36a1e277f5b4084258d9af1eae29bac4) for the art piece "[Beneath These Waves Lies Light](https://vimeo.com/379376339)", it still looks beautiful on 5 leds:

{{< youtube fExAfrpSHGU >}}

Its beauty comes from its complexity and depth.
There are four simultaneous "waves" intersecting each other with extra effects for darker hues and whitecaps.

## Future Improvements

* I think eventually I will want an easier way to change the alarm times
* Maybe I can make the touch sensor detect long holds or double taps for more interesting commands
* Synchronized color schemes for special events copied from a [different project](https://github.com/solarkennedy/fadecandycal)
