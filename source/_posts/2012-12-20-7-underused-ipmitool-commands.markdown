---
author: admin
comments: true
date: 2012-12-20 03:55:02+00:00
layout: post
slug: 7-underused-ipmitool-commands
title: 7 Underused IPMItool Commands
wordpress_id: 815
categories:
tags:
- bios
- ipmi
- ipmitool
- linux
---

![](/uploads/interesting-ipmi-239x300.jpg)
[IPMI](http://en.wikipedia.org/wiki/Intelligent_Platform_Management_Interface) is Awesome. But, it is underused. Most sysadmins don't even enable it. If they do enable it, they probably enable it by manually going into the BIOS, and then probably only using the Web interface. LAME.

There is no need to go to the BIOS to configure ipmi. You can use IPMItool to configure it in-band. This is my first underused command:

(disclaimer: not all IPMI interfaces / bios versions / hardware platforms are equal. Don't complain in a comment that your hardware doesn't support all of these cool things)


# 1. ipmitool lan set 1 ipsrc dhcp




## (Set your ipmi interface to grab an IP via DHCP)


Do it. Script it. Make a [puppet module](https://github.com/zoide/puppet-ipmi/). There is no reason not to have IPMI configured on every server that supports it. Except laziness.  Don't forget to set a password and enable at least one user. Seriously, this is probably the #1 under-utilized command, just configuring the darn thing.


# 2. ipmitool -H server-ipmi -U root -P root chassis power reset




## (Remote reboot via IPMI)


Once you have IPMI configured, doing a remote reboot is the next cool thing. Seriously, never press the power button, bother a noc tech, telnet to an APC, again. Notice that you need -H, -U, -P, etc. as this command must be run over the lan interface to a remote server.


# 3. ipmitool -H server-ipmi -U root -p root chassis identify 1




## (Blink the chassis LED)


Freak out a NOC tech by running this command on all your servers as soon as they replace a harddrive. Make a special Christmas youtube video with your server farm's chassis LEDs.


# 4. ipmitool -H server-ipmi -U root -P root  chassis bootparam set bootflag force_bios




## (Make your server go directly into bios on next reboot)


[![](/uploads/morpheus-ipmi-300x300.jpg)](/uploads/morpheus-ipmi.jpg)Now we are getting fancy! We've all been there. Waiting for a slow-ass HP super server to boot, waiting and waiting for the signal to start frantically pounding the F2 key to enter the bios. Then missing it because the VGA didn't show up in time. Reboot again. Repeat.

Fuck that noise. I don't wait for servers. The servers wait for me! Also works for EFI shell, PXE, disk, etc.

Maybe someday I'll combine this command with the next command (SOL) and generate bios setting macros, sending perfect sequences of keystrokes to set the BIOS like some sort of tool-assisted-server-configuring-speed-run ([YES. THIS IS HOW WE SHOULD CONFIGURE SERVERS](https://www.youtube.com/watch?v=L_AerCVhoTM)). Or if I'm lucky, just [configure the bios from Linux itself](https://wiki.xkyle.com/Configuing_BIOS_From_Linux).


# 5. ipmitool -H server01-ipmi -I lanplus -U root -P root sol activate




## (Connect to the remote server's serial console)


You know that fancy KVM over IP you have? The one that probably works like crap, needs to be rebooted all the time, lots of extra cables, special dongles, bla bla bla? You don't need it man. All a server needs is power, and network.

SOL or serial-over-lan allows you to use the server's serial console over ipmi. Configure the bios to do serial console redirection, configure your boot loader and OS to do the same, and you are set. Then load up a screen full of them and use the serial console [like a boss](https://wiki.xkyle.com/IPMI_Serial_Over_Lan#Like_a_Boss). Special props for using the magic-sysrq over SOL.


# 6. ipmitool -H ipmihost -U root -P root delloem powermonitor




## (Get server power measurements)


[![](/uploads/already-killawatt-300x300.jpg)](/uploads/already-killawatt.jpg)
Yes. On some platforms you can actually measure how much power your server is using. Scrape that shit and pump it to graphite man! I'm trying to [collect the different ways](https://wiki.xkyle.com/IPMI_Power_Measurement) to do this, as there are different vendor specific implementations.


# 7. ipmitool -H ipmihost -U root -P root sensor list




## (Retrieve low level hardware sensor output)


If you suspect you are having hardware issues, this can be super valuable. Combined with [automatic sensor monitoring via nagios](http://exchange.nagios.org/directory/Plugins/Hardware/Server-Hardware/IPMI-Sensor-Monitoring-Plugin/details), and you are an IPMI pro.
