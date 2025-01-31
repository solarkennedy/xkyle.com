---
author: admin
categories:
- bus pirate
- hardware
- spi
- text band
comments: true
date: 2013-03-14T04:08:20Z
slug: hacking-a-hallmark-text-band-first-attempt
title: 'Hacking a Hallmark Text Band: First Attempt'
wordpress_id: 908
---

The [Hallmark Text Band](http://www.textbands.com/) is a strange thing:

[![Hallmark Text Band](/uploads/P3130076-300x235.jpg)](/uploads/P3130076.jpg)

Doesn't Hallmark know kids have cell phones now?
Anyway, it is an extremely simple micro-controller driving a led matrix and a [C-Max CMM-9201](http://www.c-max.com.hk/en/technology/rfcomm/2_4g_trans_ic). You get 10 characters, and a small reed-switch? triggers a hardware interrupt, and broadcasts your 10 characters to a friend, and you swap messages. The devices holds 24 messages, FIFO. Memory is volatile. Profanity filter included.

Oh well. Lets hack it.

I don't have any fancy hardware to listen to the RF. I decided to sniff the SPI bus with a [Bus Pirate](http://dangerousprototypes.com/docs/Bus_Pirate) (Sparkfun version).

[![](/uploads/P3130078-300x224.jpg)](/uploads/P3130078.jpg)[![](/uploads/P3130081-300x300.jpg)](/uploads/P3130081.jpg)

With the Bus Pirate I've tried using the SPISniffer and the text interface in SPI monitor mode. I've tried all sorts of variations of speed, etc, and I can't get a reliable output.

I should be able to use the bus pirate in SPI monitor mode and tap it right in the middle of the bus, right? (between the controller and the wireless modules)

Setting the Bus Pirate to only give me data when CS goes low (according to the datasheet) should give me data only when it transmits, but it doesn't. I get lots of strange output:

    
    [0x08(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x0A(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x0A(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x0A(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)]
    [0x14(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)]
    [0x08(0x28)0x00(0x29)]
    [0x14(0x28)0x00(0x29)]


When the device does transmit, I get some sort of data, but it just looks like more of this randomness:

    
    [0x6E(0x28)0x00(0x29)0x6C(0x28)0x00(0x29)0x9C(0x28)0x00(0x29)0xB8(0x28)0x00(0x29)0x10(0x28)0x00(0x29)]
    [0x81(0x28)0x00(0x29)0x1F(0x28)0x00(0x29)0x7E(0x28)0x00(0x29)0x9E(0x28)0x00(0x29)0x9E(0x28)0x00(0x29)0x3F(0x28)0x00(0x29)0x1B(0x28)0x00(0x29)0xB8(0x28)0x00(0x29)0xAA(0x28)0x00(0x29)0xAA(0x28)0x00(0x29)0xAB(0x28)0x00(0x29)0xFE(0x28)0x00(0x29)0xAB(0x28)0x00(0x29)0xF8(0x28)0x00(0x29)0xAB(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)0x55(0x28)0x00(0x29)]
    [0x9C(0x28)0x00(0x29)]
    [0xC0(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)0x00(0x28)0x00(0x29)]


Is this the message? I'm a hardware hacking noob. Criticism welcome.


## Things to Discover





	
  * Does the profanity filter get applied on sending, receiving, or both?

	
  * How is the 10 character limit imposed? Could I buffer overrun it?

	
  * There could be more uses for this if I could come up with a USB interface for one, and a high gain 2.4ghz antenna...


