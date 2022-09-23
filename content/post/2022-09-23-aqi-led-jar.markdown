---
title: "An AQI LED Jar"
date: 2022-09-23T00:00:00-00:00
---

In California we have wildfire season in the summer.
Sometimes the air can be bad enough that it is unhealthy to breath for an extended period of time.
This problem of course is not specific to California.

One of my favorite tools for visualizing air quality is [Purple Air](https://map.purpleair.com/):

![Purple Air Map](/uploads/2022-09-23-aqi-led-jar/purple-air-map.png)

Using crowd-sourced sensors, you can get hyper-local readings of your surrounding air quality.
Try finding the closest sensor available to you on the [map](https://map.purpleair.com/).

But I don't want to have to check on the website all the time.
What if I had a real physical object that could reflect the current air quality?

![AQI LED Jar on a Yellow Day](/uploads/2022-09-23-aqi-led-jar/aqi-led-jar.jpg)

This LED Jar shows the color representation of the EPA AQI of my local Purple Air sensor, updated hourly!

## Hardware

The hardware for this project is already documented in [this post]({{< relref "2020-03-26-my-sunjar-esp8266-powered-alarm-clock.markdown" >}})

## Software

### WLED

The Jar just runs [WLED](https://kno.wled.ge/).
WLED is an excellent piece of software for running on an ESP8266.
It allows the LEDs to be controlled remotely, as well as configuration for beautiful patterns, timers, palettes, and more.
For this AQI project, I'm taking advantage of the fact that WLED has an easy-to-use API to control the colors.

### Cron Job

To periodically update the color of the jar, I'm using a [python script](https://github.com/solarkennedy/aqi2wled) running on an hourly [cron](https://en.wikipedia.org/wiki/Cron) schedule.

The script is small, but does a lot of work:

1. Fetches the local sensor data from the [Purple Air API](https://api.purpleair.com/).
   It uses the existing [`purpleair`](https://pypi.org/project/purpleair/) python module.
   Purple Air gives out API keys at no charge, simply email their support for one.
1. Converts the local sensor data into the EPA AQI value.
   This conversion is non-trivial.
   Feel feel to read the [technical details](https://www.airnow.gov/sites/default/files/2020-05/aqi-technical-assistance-document-sept2018.pdf) for what goes into the formula for computing AQI, but it is complex.
   In the end I used another existing [python module](https://pypi.org/project/python-aqi/) for computing the AQI correctly.
1. Convert the AQI to a real RGB color.
   With the help of another useful [python module](https://pypi.org/project/colour/), I can compute a pleasing color outside the normal 6 color blocks [specified](https://aqs.epa.gov/aqsweb/documents/codetables/aqi_breakpoints.html) by the EPA.
1. Call the [WLED API](https://kno.wled.ge/interfaces/http-api/) to set the color.

## Conclusion

WLED is such a flexible piece of software, I run it on ever LED toy I have now.
I'm also grateful for Purple Air for giving free access to their API for integrations like this.

![AQI LED Jar](/uploads/2022-09-23-aqi-led-jar/aqi-led-jar2.jpg)
