---
author: admin
categories:
- flash
- Laptop
- Personal
comments: true
date: 2007-01-20T16:38:32Z
slug: compact-flash-replacement
title: Compact Flash Replacement
wordpress_id: 48
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
[![Opened up](/uploads/dcam0093.thumbnail.JPG)](/uploads/dcam0093.JPG)[![Antenna](/uploads/dcam0100.thumbnail.JPG)](/uploads/dcam0100.JPG)[![Drive](/uploads/dcam0098.thumbnail.JPG)](/uploads/dcam0098.JPG)
You can see that this is not a normal size laptop hard drive. This is a 1.8" drive. So I bought this card and a cheap laptop IDE to flash converter off of ebay. (Sorry I don't have a picture.)

We used containers with numbers and a legend to keep track of small screws and parts. When we were done, these were left over:
[![Leftovers](/uploads/dcam0106.thumbnail.JPG)](/uploads/dcam0106.JPG)
(Don't ask me whats in compartment 8, I really don't know what it goes to. But there is the leftover drive and screws)

Second step,  spray paint it! Oh, and don't forget to put in the flash card when you put it back together.
[![Closed1](/uploads/dcam0118.thumbnail.JPG)](/uploads/dcam0118.JPG)[![Finished1](/uploads/dcam0108.thumbnail.JPG)](/uploads/dcam0108.JPG)
Can you spot the laptop?
[![Woods1](/uploads/dcam0119.thumbnail.JPG)](/uploads/dcam0119.JPG)[![Woods2](/uploads/dcam0120.thumbnail.JPG)](/uploads/dcam0120.JPG)

Of course, with only a 4GB drive, I will be running my favorite operating system of course, [Ubuntu](http://www.ubuntu.com)!

[![Screenshot](/uploads/screenshot.thumbnail.png)](/uploads/screenshot.png)

And the obligatory screen shot!

Want more? [Click here to download every picture we took.](/other/laptopproject.zip)
Closing thoughts:
I'm extremely impressed. The camo-finish is beautiful and feels great thanks to the clear coat. Nothing broke, and everything went back together correctly thanks to good documentation and pictures for reference. If you have any questions about what I did, post a comment and I'll come back and answer them.
