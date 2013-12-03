---
author: admin
comments: true
date: 2013-10-03 05:07:55+00:00
layout: post
slug: dropbear-with-mosh-on-a-low-end-server
title: Dropbear with Mosh on a Low End Server
wordpress_id: 1021
categories:
- dropbear
- mosh
- Puppet
---

I love my [low end boxes](http://lowendbox.com/). I also love [mosh](http://mosh.mit.edu/).

Low end boxes usually are tight on resources, so Dropbear is often used as a lightweight ssh server. Mosh is mostly tested with openssh-client/server, so I think there are some bugs.

But it can work, just make sure:



	
  1. You are using the same version of mosh on the **server** as you are on your **client**. (otherwise they may not support the same command line options)

	
  2. Make sure you have have a en_US.UTF-8. Mosh requires UTF8, and low end boxes usually have a bare install without this local. Run:

    
    locale-gen --no-archive en_US.UTF-8


For a reproducible puppet snipped:

    
    package { 'mosh': ensure => latest }
    ensure_packages(['locales'])
    exec { "/usr/sbin/locale-gen --no-archive en_US.UTF-8":
     creates => '/usr/lib/locale/en_US.utf8',
    }




	
  3. Run mosh more than once. There is some sort of race condition or bug which prevents mosh from grabbing a tty. Running it multiple times will get it to work eventually. I haven't tracked down the root cause.


