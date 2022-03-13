---
title: "WLED on a Novostella Flood Lamp"
date: 2022-03-13T00:00:00-00:00
---

I recently bought a pair of [Novostella 20W Smart LED Flood Lights](https://www.amazon.com/Novostella-2700K-6500K-Dimmable-Waterproof-Multicolor/dp/B07VH1VHYL).
These lights are RGBCW (Red/Blue/Green/Cold/Warm) and use the ubiquitous ESP8266 controller on the [Tuya TYLC4-IPEX](https://developer.tuya.com/en/docs/iot/wifilc4module?id=K9605t0d19jiy).

From the [previous blog post]({{< ref "2022-03-09-tasmota-on-a-novostella-flood" >}}) we learned that the ESP8266 is connected to the LED controller in the following way:

* `GPIO 04`: PWM Channel 1 (Red)
* `GPIO 05`: PWM Channel 5 (Color Temp)
* `GPIO 12`: PWM Channel 2 (Green)
* `GPIO 13`: PWM Channel 4 (White)
* `GPIO 14`: PWM Channel 3 (Blue)
* `GPIO 0-3,6,7,11,1`: Not used

My particular version of this Novostella Flood Light had the latest version of their software, which means I did have to break the glass and solder up a programmer to flash [WLED](https://kno.wled.ge/) on it.

I tried using the [Web-based WLED installer](https://install.wled.me/), which did work, except for some reason the settings would not persist across reboots.
Instead I flashed WLED manually, and after that it worked fine.

## Novostella WLED Settings

Once WLED has been flashed, you must next configure WLED for this light fixture.

* Red: GPIO 4
* Green: GPIO 12
* Blue: GPIO 14
* White: GPIO: 13
* Color Correction: GPIO: 5

{{< figure src="/uploads/WLED-on-a-Novostella-Flood-Lamp/WLED-novostella-flood-settings1.png" alt="WLED LED Settings" >}}

This configuration will give you an additional slider for the White LEDs, and then one more slider for color temperature (CCT).

I additionally set these settings to make WLED automatically use the white LEDs for me:

{{< figure src="/uploads/WLED-on-a-Novostella-Flood-Lamp/WLED-novostella-flood-settings2.png" alt="WLED LED White Settings" >}}

But this is a matter of taste and application.
See [the WLED CCT Docs](https://kno.wled.ge/features/cct/#ic-cct) for more information about how to use the White+CCT settings.

## In Action

{{< youtube "p6jBBS5iCtk" >}}
