---
author: admin
comments: true
date: 2013-06-21 04:46:58+00:00
layout: post
slug: rebuilding-packages-for-arm-or-any-other-arch
title: Rebuilding Packages for ARM (or any other arch)
wordpress_id: 1011
categories:
---

Sometimes there are packages out there that don't come in your cool new Architecture. In my case it is ARM, and the package I wanted was Puppet. Here is how to rebuild source packages the cool way.


## Add the Puppet repo so you can get fresh source packages



    
    cd /tmp
    # Add the repo, even though it may not have arm binaries...
    wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb 
    dpkg -i puppetlabs-release-precise.deb
    # Get dependencies...
    apt-get update
    apt-get build-dep puppet facter




## Build / Install



    
    # Get sources..
    apt-get source facter
    cd facter-1.7.1
    dpkg-buildpackage
    cd /tmp
    dpkg -i facter_1.7.1-1puppetlabs1_armhf.deb




## More


Facter is easy. Only one extra missing dependency that you can apt-get.

Next try to build puppet. No problem, except when you try to install it, it depends on Hiera.

Build Hiera, install it, then try puppet again. This process takes a while to build up all the dependencies.
