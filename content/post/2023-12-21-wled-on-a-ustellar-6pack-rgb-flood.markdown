---
title: "WLED on a Ustellar RGB Flood 6 Pack"
date: 2023-12-21T00:00:00-00:00
---

Previously, I bought [this 6-pack of Outdoor RGBW Flood lights](https://www.amazon.com/gp/product/B09ZY5QP6K/) and [disassembled them]({{< ref 2023-01-26-ustellar-6pack-rgbw-flood-teardown >}}).

[![Ustellar RGB Flood Light Outdoor 6-pack](/uploads/2023-01-26-ustellar-6pack-rgbw-flood-teardown/ustellar-6pack.thumb.jpg)](/uploads/2023-01-26-ustellar-6pack-rgbw-flood-teardown/ustellar-6pack.jpg)

These have the SEO words of:

> Ustellar RGB Flood Light Outdoor, Smart WiFi RGBW Color Changing Landscape Lights+Warm White 2700K, 40W App Control Christmas Spotlight Works with Alexa, IP66 Waterproof Uplights, Plug & Play (6 Pack) 

They have a part number of `UT88865-RGBW-US-1`.
Fundamentally they are **a string of 6 24v WS2814A RGBW flood lights with the first flood as the controller with a Tuya CBU module for wifi control**.

## Adding An ESP8266

I wasn't planning to use the Tuya chip.
Instead, I simply desoldered it, and added in an ESP8266.
One could totally find all the solder points required to keep the ESP8266 in the case, but instead I just keep it external, and treat the string of flood lights like an external string.

This is the external downconverter I used to supply 5v to the ESP8266, reusing the existing 24v supply:

[![voltage_converter.jpg text](/uploads/2023-12-21-wled-on-a-ustellar-6pack-rgb-flood/voltage_converter.thumb.jpg)](/uploads/2023-12-21-wled-on-a-ustellar-6pack-rgb-flood/voltage_converter.jpg)

Really though, any way of getting power to the ESP8266 would work, this is just a module I had on hand.

## Wiring Up An ESP8266

The wiring between lights + the ESP8266 looks like this:

```mermaid
graph LR
    A(Power Supply)
    B[Flood 1 w/Desoldered Tuya]
    C[Flood 2]
    D[Flood N]
    E[5v Converter]
    F[ESP8266]

    A -- Gnd: White --> B
    A -- 24v: Black --> B

    A -- Gnd: White --> E
    A -- 24v: Black --> E

    E -- 5v+ --> F
    E -- Gnd --> F

    F -- Data Out Pin 2 --> B

    B -- Gnd: White --> C
    B -- 24v: Black --> C
    B -- Data: Red  --> C

    C -- Gnd: White --> D
    C -- 24v: Black --> D
    C -- Data: Red  --> D
```

Note: The power supply's wires may not be color coded like this.
Always double check the polarity with a multimeter.

There are tons of ways to wire this.
Honestly this is way overkill, but if you want, you can think of this as a string of 6 individually addressable LEDs.
They just happen to come in really robust cases and run on 24v DC.

## WLED Settings

[![wled-settings.png text](/uploads/2023-12-21-wled-on-a-ustellar-6pack-rgb-flood/wled-settings.png)](/uploads/2023-12-21-wled-on-a-ustellar-6pack-rgb-flood/wled-settings.png)

These flood lamps have both a pure white LED component and a light temperature control.

The most important setting is the fact that these flood lamps speak the SK6812 protocol.

I set the length to 5 because I just trashed the first one in the teardown, leaving 5 out of 6 intact floods.

With these settings in place, and confirming that the Tuya chip is removed, and that the right data out pin of the ESP8266 is plugged into the input line of the first Flood, you should see that nice default WLED orange!

## Conclusion

These flood lamps are really just six lamps powered by 24v DC and one SK6812 dataline.
An alternative microcontroller and WLED is more than capable of powering these lamps.
Other than voltage drop issues, there is nothing preventing one from constructing even longer strands.

With WLED, you can bring these mini flood lights into the fold, without having to use any of the Tuya stuff.
