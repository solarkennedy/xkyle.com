---
title: "Enabling USB Tethering on a Palm PVG100 Without Root"
date: 2023-01-27T00:00:00-00:00
---

I'm trying out the [2018 Palm PVG100](https://www.gsmarena.com/palm_palm-9290.php) as my daily driver cell phone.

[![Palm PVG100](/uploads/2023-01-27-enabling-usb-tethering-pvg-100/palm-pvg100.thumb.jpg)](/uploads/2023-01-27-enabling-usb-tethering-pvg-100/plam-pvg100.jpg)

Sure, it is ancient by smartphone standards, but it makes me _feel_ like I'm in the future whenever I use it.

Plus it pairs well with my [OneNetbook 4](https://www.1netbook.com/businesepc/onenetbook-4-platinum/):

[![Palm PVG100 plus OneNetbook 4](/uploads/2023-01-27-enabling-usb-tethering-pvg-100/palm-pvg100-one-netbook4.thumb.jpg)](/uploads/2023-01-27-enabling-usb-tethering-pvg-100/palm-pvg100-one-netbook4.jpg)

Reasons for using this:

* It is cool
* It satisfies my "under $100 device on my person" constraint
* It discourages "bad scrolling habits"
* It fits in my wallet

## Why USB Tethering

I think USB Tethering is underrated.
I always prefer it over a Wifi hotspot because:

* The phone often needs to be plugged in anyway, for power reasons.
* Wifi connections suck. Passwords, encryption, signal strength, lots of ways for it to go wrong.
* Forcing the phone to put its Wifi radio **and** Cell radio into overdrive is not necessary and causes even more power drain.
* Wifi adds a tiny bit more latency, and potentially lots more packet loss on top of an already lossy Cell network.

Contrary to popular belief, you do _not_ need root to use USB tethering, nor do you need a custom ROM.

## Enabling USB Debugging

The first step to get to USB tethering is to [enable developer options](https://developer.android.com/studio/debug/dev-options).
This is possible on almost every Android build out there, including the Palm's.

Once this is enabled, you can enable "USB Debugging", and access features of the phone using the [Android Debug Bridge (adb)](https://developer.android.com/studio/command-line/adb) command.

On debian-based distros (Ubuntu) this is a single command away:

```
$ apt install -y adb
...
$ adb devices
* daemon not running; starting now at tcp:5037
* daemon started successfully
List of devices attached
4373dd0f	device

```

This works after accepting the host device's key (the laptop) from the popup on the phone.

## Enabling USB Tethering

The build of Android that comes with the phone doesn't have any tethering options in the settings menu at all.
I'm not sure if this is intentional or not, or at the request of ... Verizon?
The hardware is absolutely capable of it, and the actual Tether settings menu **can be accessed**, just through non-standard means.

I like using adb directly to do it, since when I'm USB tethering I _already_ have USB connected, so the `adb` command will work:

```
# Brings up the "Tethering and portable hotspot" settings page
adb shell am start -n com.android.settings/.TetherSettings
```

This command will pop up this settings page:

[![Palm PVG100 Tether Settings](/uploads/2023-01-27-enabling-usb-tethering-pvg-100/tethering-screenshot.thumb.png)](/uploads/2023-01-27-enabling-usb-tethering-pvg-100/tethering-screenshot.png)

Setup a shell alias to that command, and you are one command + 1 click away from enabling tethering.

But why stop there?
Go ahead and automate the click!
The phone is tiny, save yourself the tapping:

```
# Presses the toggle for USB Tethering
adb shell input touchscreen tap 650 200
```

## Conclusion

The full script I use is just the two commands:

```
#!/bin/sh
# Brings up the "Tethering and portable hotspot" settings page
adb shell am start -n com.android.settings/.TetherSettings
# Presses the toggle for USB Tethering
adb shell input touchscreen tap 650 200
```

Run that command, and a few seconds later there will be a `usb0` (that is what it is named on my laptop) interface on the Laptop.
Standard DHCP is fine, and soon you will get a private IP that is NAT'd from the phone, enabling internet access using the phone's cell modem.
