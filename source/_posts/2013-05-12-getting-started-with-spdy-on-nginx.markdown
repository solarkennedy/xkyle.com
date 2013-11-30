---
author: admin
comments: true
date: 2013-05-12 21:29:09+00:00
layout: post
slug: getting-started-with-spdy-on-nginx
title: Getting Started With SPDY on Nginx
wordpress_id: 972
categories:
- All
tags:
- httpd
- nginx
- SPDY
---

[SPDY](http://en.wikipedia.org/wiki/SPDY) is a fancy new way to do HTTP, pioneered by Google. Pretty much all modern browsers support it now, except for of course, IE.

If you have SSL enabled and are using nginx, they you are pretty close to running your sites with SPDY. What how easy it is!


## Step 1: Get a version of nginx with spdy enabled.




### Ubuntu


Get some [packages](http://nginx.org/en/linux_packages.html). The **Ubuntu** packages have "--with-http_spdy_module" compiled, so you can install them with no problem:

    
    cd /tmp
    wget http://nginx.org/keys/nginx_signing.key
    apt-key add nginx_signing.key
    rm nginx_signing.key
    
    echo "deb http://nginx.org/packages/ubuntu/ precise nginx
    deb-src http://nginx.org/packages/ubuntu/ precise nginx" > /etc/apt/sources.list.d/nginx.list
    apt-get update
    apt-get remove nginx
    apt-get autoremove
    apt-get install nginx




### Centos / RHEL


The **Centos** packages need to be rebuilt. And you need a new openssl. (carefully)

    
    yum install yum-utils rpmdevtools
    yum-builddep nginx
    rpm -i http://nginx.org/packages/centos/6/SRPMS/nginx-1.4.1-1.el6.ngx.src.rpm
    
    cd /tmp
    wget http://www.openssl.org/source/openssl-1.0.1e.tar.gz
    tar xzf openssl-1.0.1e.tar.gz


Now add these lines to the two configure commands (one normal, one debug) in the spec file (~/rpmbuild/SPECS/nginx.spec):

    
     --with-http_spdy_module \
     --with-openssl=/tmp/openssl-1.0.1e/ \


Now build yourself and RPM:

    
    cd ~/rpmbuild/
    rpmbuild -ba SPECS/nginx.spec
    rpm -e nginx
    rpm -Uvh RPMS/i386/nginx-1.4.1-1.el6.ngx.i386.rpm
    /etc/init.d/nginx restart




##  Configuring nginx


Take your listen line, and add "ssl spdy" to it:

    
    server {
          listen 443 ssl spdy;




## Testing


Try this [SPDY testing page](http://spdycheck.org/#xkyle.com).
And try a [Chrome plugin](https://chrome.google.com/webstore/detail/spdy-indicator/mpbpobfflnpcgagjijhmgnchggcjblin?hl=en) that will visually indicate if the server you are talking to supports SPDY.

[![spdy indicator](https://xkyle.com/wp-content/uploads/Screenshot-from-2013-05-16-174759.png)](https://xkyle.com/wp-content/uploads/Screenshot-from-2013-05-16-174759.png)
