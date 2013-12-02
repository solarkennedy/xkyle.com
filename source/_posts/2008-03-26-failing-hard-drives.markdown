---
author: admin
comments: true
date: 2008-03-26 14:14:12+00:00
layout: post
slug: failing-hard-drives
title: Failing Hard Drives
wordpress_id: 95
categories:
- All
tags:
- All
- drives
- hardware
- nclug
---

So lots of people use computers, and lots of people have harddrives.

At my work I deal with lots and lots of computers and lots and lots of drives. So during a week I see plenty of failing drives, just because of the statistics.

![](http://www.techchee.com/wp-content/uploads/2007/11/double-boil-your-failed-hard-drive-to-recover-its-precious-data-271107.jpg)

So now-a-days I run a "smart test" on the drive to see how it is. Unfortunately most drive testers and smart tests are crap. So I made my own and I want to share it with you....

It runs in Linux of course, and all it needs is a program called smartctl. (If you don't have it and you are running Ubuntu, just run "apt-get install smartmontools" )

Here is how you can get it and run it:


> $ wget a.xkyle.com/smarttest
$ bash smarttest


Thats it! Just give it about 2 minutes to run.  Here is an example output:


> Hours: 27519
SMART Errors: 0
Reallocated / Pending: 2 / 0
Read Speed: 41 MB/s

WARNING: This drive has over 26,280 (3 years) hours on it and should not be used as a Primary
WARNING: This drive has some reallocated sectors, this shouldn't be used as a primary and requires judgment if it is to be used for a secondary


Its  pretty self explainitory if you know about drives. If you want to know more about smart paramaters, check out the [wikipedia article.](http://en.wikipedia.org/wiki/Self-Monitoring,_Analysis,_and_Reporting_Technology)
