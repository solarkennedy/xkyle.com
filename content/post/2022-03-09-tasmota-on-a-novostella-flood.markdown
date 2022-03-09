---
title: "Tasmota on a Novostella Flood Lamp"
date: 2022-03-09T00:00:00-00:00
---

I recently bought a pair of [Novostella 20W Smart LED Flood Lights](https://www.amazon.com/Novostella-2700K-6500K-Dimmable-Waterproof-Multicolor/dp/B07VH1VHYL).
These lights are RGBCW (Red/Blue/Green/Cold/Warm) and use the ubiquitous ESP8266 controller.

Based on [other](https://notenoughtech.com/home-automation/flashing-tasmota-on-novostella-smart-bulb-floodlights/) [guides](https://www.theeggeadventure.com/2019/12/connecting-novostella-20w-smart-led-flood-lights-to-smartthings/) thought that I could use the [tuya-convert](https://github.com/ct-Open-Source/tuya-convert) tool to flash them with my own software OTA (over the air).
Unfortunately the latest revision of these lights uses a patched firmware that tuya-convert [does not understand](https://github.com/ct-Open-Source/tuya-convert/wiki/Collaboration-document-for-PSK-Identity-02). This means that these Flood Lamps cannot be re-flashed without being taken apart.

So let's take them apart!
Even with a heat gun I was unable to remove the glass without destroying it.

{{< gallery dir="/uploads/WLED-on-a-Novostella-Flood-Lamp" />}} {{< load-photoswipe >}}

See the images in the image gallery for (crappy) photos of the components and pinout of the module.
I traced the pins and soldered connections required to hookup a ESP programmer.

Just using the [web installer](https://tasmota.github.io/install/) is fine.
Once the module is hooked up to a programmer, it is a "normal" ESP8266.

Based on the other prior art, I used this Tasmota template:

    {"NAME":"Novostella 13W","GPIO":[0,0,0,0,37,40,0,0,38,41,39,0,0],"FLAG":0,"BASE":18}

A Breakdown of what this configuration means:

* `"NAME"`: Just a human-friendly name of this device 
* `"GPIO"`: Maps GPIO output of the ESP8266 to the function in Tasmota. The translation here is:
  * `GPIO 0-3,6,7,11,1`: Not used
  * `GPIO 04`: PWM Channel 1
  * `GPIO 05`: PWM Channel 2
  * `GPIO 08`: PWM Channel 3
  * `GPIO 09`: PWM Channel 4
  * `GPIO 10`: PWM Channel 5
* `"FLAG"`: A value of `0` means there are no [ADC](https://tasmota.github.io/docs/ADC/)
* `"BASE"`: A value of `18` indicates that Tasmota should treat this as a generic device, and just show whatever GPIO pins there are with no translation

With this in place, Tasmota can correctly adjust the color (RGB), brightness, and temperature.
This is the 5-Channel RGBCCT [Tasmota Light Type](https://tasmota.github.io/docs/Lights/#5-channels-rgbcct-lights).

Next I intend to flash [WLED](https://kno.wled.ge/), and hopefully build a version of WLED that [supports](https://github.com/Aircoookie/WLED/issues/798) these floodlamps.
