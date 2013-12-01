---
author: admin
comments: true
date: 2011-05-21 03:02:47+00:00
layout: post
slug: how-to-benchmark-harddrives-in-linux
title: How to Benchmark Harddrives in Linux
wordpress_id: 599
categories:
- All
tags:
- benchmarks
- hard drives
- raid
---

So you have some new harddrives. Maybe you are thinking about building a DIY storage server? Maybe some Raid? Maybe you just want to know if your drives are performing as well as when you bought them? How can you know? **Measurement is Knowing**.

The thing about benchmarks is that you always must be skeptical. Each system's particular disks, controller, raid level and settings, cpu, ram, filesystem, operating system, etc can GREATLY affect the performance of a system. The only way to know is to **do it yourself**.

**_1. Super Easy Block Level Read Test: hdparm _**
This particular "benchmark" is easiest and the least reliable. It does raw reads only, good luck on where it pulls them from. Here is an example:


> root@archive:/# hdparm -tT /dev/sda

/dev/sda:
Timing cached reads:   1472 MB in  2.00 seconds = 735.81 MB/sec
Timing buffered disk reads: 360 MB in  3.02 seconds = 119.24 MB/sec


Its... something. Good for just real quick, non-destructive read tests to compare between two disks or arrays.

**_2. Better Block Level Read and Write Tests: palimpsest_**
Palimpsest operates on a block device. It has nothing to do with files and filesystems like hdparm. If performed on a whole disk you can see the how the drive slows down as the head approaches the interior of the spindle. It also does seek tests.

You can run "palimpsest" on the command line, or in a gnome environment go System->Administration -> Disk Utility. Modern versions of the program can also connect to remote servers which may not have a gui. It can also be X-forwarded from remote servers.

Here is a gallery of some examples:

[![](/uploads/Screenshot-1-10.0-GB-RAID-1-Array-–-Benchmark-150x150.png)](/uploads/Screenshot-1-10.0-GB-RAID-1-Array-–-Benchmark.png)[![](/uploads/Screenshot-1-20-GB-RAID-5-Array-–-Benchmark-150x150.png)](/uploads/Screenshot-1-20-GB-RAID-5-Array-–-Benchmark.png)[![](/uploads/Screenshot-1-30-GB-RAID-0-Array-–-Benchmark-150x150.png)](/uploads/Screenshot-1-30-GB-RAID-0-Array-–-Benchmark.png)[![](/uploads/Screenshot-64-GB-Solid-State-Disk-ATA-Corsair-CSSD-V64GB2-–-Benchmark-150x150.png)](/uploads/Screenshot-64-GB-Solid-State-Disk-ATA-Corsair-CSSD-V64GB2-–-Benchmark.png)[![](/uploads/Screenshot-2.0-TB-Hard-Disk-ATA-WDC-WD20EARS-00MVWB0-–-Benchmark-150x150.png)](/uploads/Screenshot-2.0-TB-Hard-Disk-ATA-WDC-WD20EARS-00MVWB0-–-Benchmark.png)

Notice the slow writes on the raid 5 (second picture), and the small deviation on seeks on the SSD (forth picture). Also you can see how spinning disks slow down as the approach the center of the spindle. (fifth picture)

**_3: Real World Filesystem Benchmarks: Bonnie++_**
In some way, the above benchmarks are more theoretical than what would be ideal. Unless you have a special application, you are like the rest of us: **you work on files**.

Working with normal files means you interact with a filesystem. Working on a filesystem means you have block sizes, extents, permissions, fragmentation, etc. All of these additional complexities need to be measured.

The solution here is bonnie++, which does what most applications do: write, read, seek, create, and delete files sequentially and randomly.

Here would be a typical invocation:


> kyle@archive:/tmp# bonnie++


It is better to run it as not root. Run it in the directory where you want it to make files. Its output is... a little hard to comprehend and outside the scope of this article. One can read the documentation and compile your own spreadsheet and graph with some Libreoffice Calc foo:

[![](/uploads/Bonnie-Graphs-300x178.png)](/uploads/Bonnie-Graphs.png)

Nothing too fancy. It has a lot of output, so you have to pick the numbers that are important to you. Another option is to use the bon_csv2html to output a slightly more readable output:


> cat benchmarks.csv | bon_csv2html  > bench.html

firefox bench.html


[![](/uploads/bonnie-html-300x62.png)](/uploads/bonnie-html.png)

Bonnie benchmarks are the hardest to read, but are they closest to the *reality* of the performance of your disk in your environment.

_**Conclusion**_
So that is it. Try out different raid configurations and filesystems, but benchmark them to **_know_** if it improves or degrades your performance instead of depending on hunches and superstition!
