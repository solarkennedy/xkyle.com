---
author: admin
comments: true
date: 2012-06-24 17:05:04+00:00
layout: post
slug: build-systems-out-of-poured-concrete-not-bricks
title: Build Systems out of Poured Concrete, not Bricks
wordpress_id: 739
categories:
- All
tags:
- it
- platforms
---

Personally, I don't have any kind of battle-hardened wisdom. Most of what I know comes from the wisdom of others. In particular I would like to acknowledge the real geniuses up front:



	
  * [My First Petabyte: Now What?](http://www.youtube.com/watch?v=Eu430bqbK5w) ([Jacob Farmer](http://www.cambridgecomputer.com/management.cfm) from [Cambridge Computer](http://www.cambridgecomputer.com))

	
  * [Google Platforms Rant](https://plus.google.com/112678702228711889851/posts/eVeouesvaVX) ([Steve Yegge](https://plus.google.com/110981030061712822816/posts) of Google)

	
  * [http://perspectives.mvdirona.com/](http://perspectives.mvdirona.com/) ([James Hamilton](http://perspectives.mvdirona.com/) of Amazon)

	
  * [Ted Dzuiba](https://github.com/teddziuba/teddziuba.github.com)

	
  * Tons of blogs posts, LISA talks, that I can't site specifically.

	
  * Seriously, we are all a product of the RSS feeds we read?


I'm not saying [IT is dead](https://www.networkworld.com/news/2008/010908-carr-wrong.html). But IT is changing.

Look at how building houses has changed over time:
[![](/uploads/brick.jpg)](/uploads/brick.jpg)[![](/uploads/cinderblock.jpg)](/uploads/cinderblock.jpg)[![](/uploads/concrete-1024x731.jpg)](/uploads/concrete.jpg)[![](/uploads/Prefabricated_house_construction-300x225.jpg)](/uploads/Prefabricated_house_construction.jpg)



	
  * Brick - small pieces, one at a time

	
  * Cinder Block - Big pieces, one at a time

	
  * **Poured Concrete - continuous pieces, poured continuously**

	
  * **Prefab Houses - one house at a time?**




> 

> 
> I don't have book to sell, I have a job to do. That job it to help build systems, and I will **not** be doing it one at a time.










You might think that I'm talking about "The Cloud". Well, I don't know what you are talking about. You might think I'm talking about things like Amazon's EC2. While that is part of the puzzle, Amazon is just making it easier for us to rent bricks from them. [Amazon DynamoDB](https://aws.amazon.com/dynamodb/) however is more like poured concrete...







In the end, there is so much work to be done on internal stuff. Like it or not, lots and lots of computing just can't be run on public infrastructure. (Utility Computing?) For that, we need private infrastructure. A "Private Cloud" you might say? Yes, but that is only the beginning of the story.  It is certainly a good start: get really good a supplying bricks. (Or prefab houses)







The rest of the infrastructure story (I believe) has to do with simplifying and unifying our bricks, or concrete. It is not enough to be able to spin up VM's on demand. A big scalable SAN is not enough. Who cares how fast you can provision, what is it that you are provisioning?




Here is what we need to make it happen:







## 1. Blur the lines of Storage / Compute / Networking


You system engineers should be [configuring your networking](http://puppetlabs.com/blog/puppet-network-device-management/). Your network should be [configuring itself](https://en.wikipedia.org/wiki/Software_Defined_Networking). The Storage should not just be salable, but agile and dynamic. The data should migrate to where it can be served the most efficiently. IaaS can enable this to happen as the apps are abstracted from the hardware. _Imagine a setup where every server node has internal SSDs and an agile filesystem automatically moves the most requested objects to its local storage (for the lowest latency)_.


## 2. Devops


Destroy the Silos! There should be no difference between development and ops. Make your developers keep their apps running. This gives them an incentive to build them better. The trick is of course to have the infrastructure in place for them to use. _Imagine a place where Developers own the end-to-end lifecycle of their application_.


## 3. Forward thinking business-people


"IT" provides a huge competitive advantage for business, even more than it has in the past. There is no industry where IT is not a critical business component. Evolving IT helps lift up everything. _Imagine a world where the CTO can see the vision and imagine how cutting edge infrastructure provides real value to the business_.


## 4. Apps that assume they are distributed


We can't keep building our systems with single points of failure, whether they are in a "cloud" or not. Think about the pain of going from one MySQL server to two. How about the three? It is too hard. We need a more Mongodb-like approach. _Imagine a world where every app can be "poured" to one node or a hundred nodes_.


## 5. Design Apps to use Objects instead of Files


The S3 approach is good. We need to learn from this. Web-apps are not the only things that can benefit from the transition from file to objects. HTTP based object stores are much easier to scale and can keep a higher availability than traditional filesystems. _Imagine a world where applications can take advantage of distributed object stores as easily as they can use local filesystems_.

Those are my predictions for the future. I'm excited to be a part of it!


