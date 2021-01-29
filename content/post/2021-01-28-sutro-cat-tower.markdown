---
title: "Sutro Cat Tower"
date: 2021-01-28T00:00:00-00:00
---

This is my "Sutro Cat Tower", modeled after the real [Sutro Tower](https://en.wikipedia.org/wiki/Sutro_Tower) in San Francisco CA.

It features:

- 7' 3" (221cm) Tall
- 369 Individually addressable RGB LEDs
- ESP8266 programming (timers, dimming, "smart" features), [code](https://github.com/solarkennedy/SutroCatTower)
- Fleece-lined platforms for the cats
- Modular wood construction

Honestly it is too tall, I'll have to come up with something to make it easier for the cats to jump up into the upper platforms.

The woodwork was difficult, requiring lots of angled cuts with the table saw.
All the wood for this tower came from:

- Two 10' 4x4s
- 3/4" Melamine for the platforms
- 12" long 3/4" Dowels for the antenna

The cable management is a bit of a mess.
I cut perfectly shaped cable hiders using my vinyl cutter to tuck away in the corners.

With so many LEDs, power consumption is a major concern.
There is a "backbone" 18awg bus cable for carrying the ground and 5v lines.
Maximum power consumption is 60 watts with full white on every LED.
Using [FastLED's power management functions](http://fastled.io/docs/3.1/group___power.html) I'm able to clamp that number to a more sane 50 watts (what the power supply is spec'd for), and it will dim in software if needed.

I intend to [anchor](https://anchorit.gov/) this large object to the wall.
Cat mischief, combined with a high center of mass means that it is likely to topple over if unsecured.

{{< gallery dir="/uploads/sutrocattower" />}} {{< load-photoswipe >}}
