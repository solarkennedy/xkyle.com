---
author: admin
comments: true
date: 2007-01-20 16:38:32+00:00
layout: post
slug: compact-flash-replacement
title: Compact Flash Replacement
wordpress_id: 48
tags:
- flash
- Laptop
- Personal
---

My laptop is a Sharp MM20, which I knew I was going to spraypaint eventually, I just needed a reason to. After about a year of wear and scratches from abuse, it was time.

I'm replacing the harddrive in my laptop with a 4GB flash card.
It should be faster:

/dev/sdb:
Timing cached reads:   3532 MB in  2.00 seconds = 1766.79 MB/sec
Timing buffered disk reads:   58 MB in  3.10 seconds =  18.69 MB/sec
root@kyle-desktop:~# hdparm -tT /dev/sda

/dev/sda:
Timing cached reads:   3532 MB in  2.00 seconds = 1766.13 MB/sec
Timing buffered disk reads:   78 MB in  3.04 seconds =  25.67 MB/sec

Pros: Faster seeks and sustained I/O. Lifetime Warranty.
Cons: Expensive. 25% Disk Space. Bad blocks over time.

So lets do it! I started with instructions from [this guy.](http://www.evilblobbie.com/mm20.php)

First step, disassembling the laptop:
[![Opened up](https://xkyle.com/wp-content/uploads/dcam0093.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0093.JPG)[![Antenna](https://xkyle.com/wp-content/uploads/dcam0100.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0100.JPG)[![Drive](https://xkyle.com/wp-content/uploads/dcam0098.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0098.JPG)
You can see that this is not a normal size laptop hard drive. This is a 1.8" drive. So I bought this card and a cheap laptop IDE to flash converter off of ebay. (Sorry I don't have a picture.)

We used containers with numbers and a legend to keep track of small screws and parts. When we were done, these were left over:
[![Leftovers](https://xkyle.com/wp-content/uploads/dcam0106.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0106.JPG)
(Don't ask me whats in compartment 8, I really don't know what it goes to. But there is the leftover drive and screws)

Second step,  spray paint it! Oh, and don't forget to put in the flash card when you put it back together.
[![Closed1](https://xkyle.com/wp-content/uploads/dcam0118.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0118.JPG)[![Finished1](https://xkyle.com/wp-content/uploads/dcam0108.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0108.JPG)
Can you spot the laptop?
[![Woods1](https://xkyle.com/wp-content/uploads/dcam0119.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0119.JPG)[![Woods2](https://xkyle.com/wp-content/uploads/dcam0120.thumbnail.JPG)](https://xkyle.com/wp-content/uploads/dcam0120.JPG)

Of course, with only a 4GB drive, I will be running my favorite operating system of course, [Ubuntu](http://www.ubuntu.com)!

[![Screenshot](https://xkyle.com/wp-content/uploads/screenshot.thumbnail.png)](https://xkyle.com/wp-content/uploads/screenshot.png)

And the obligatory screen shot!

Want more? [Click here to download every picture we took.](https://xkyle.com/other/laptopproject.zip)
Closing thoughts:
I'm extremely impressed. The camo-finish is beautiful and feels great thanks to the clear coat. Nothing broke, and everything went back together correctly thanks to good documentation and pictures for reference. If you have any questions about what I did, post a comment and I'll come back and answer them.
