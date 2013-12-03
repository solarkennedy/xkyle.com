---
author: admin
comments: true
date: 2011-01-10 02:33:49+00:00
layout: post
slug: new-technologies-for-a-new-year
title: New Technologies for a New Year
wordpress_id: 571
categories:
- dnssec
- ipv6
- nclug
- ssl
---

Starting with the new year, I decided to move my xkyle.com domain and related stuff away from my account at [Dreamhost](http://www.dreamhost.com/), a shared hosting server, to my virtual machine at [Tummy.com](http://www.tummy.com/). I have nothing but good things to say about Dreamhost though, they are excellent at what they do. However, I wanted to do more than what a shared hosting provider could do for me, I needed Root!

Moving my websites and dns to a dedicated server grants me the ability to implement a few technologies to usher in the new year. Here they are:



	
  * **SSL-On-Everything**! I don't like things listening and editing and manipulating traffic in transit between me and a server. Deep packet inspection, proxy servers, tcp monitors, etc all give me the jibblies. There are a couple things that might prevent one from implementing SSL on a site though.Historically websites here hosted with one website per ip address. Then we came out with virtual hosting (vhosts), which allowed multiple websites to be on a single ip address. (See [http://www.myipneighbors.net/](http://www.myipneighbors.net/) for a tool to see this in action) The problem was, SSL couldn't do this. Recently, something called [SNI](http://en.wikipedia.org/wiki/Server_Name_Indication) (Server Name Identification) enabled this to work. There are some legacy systems that do not support this technology though, so be aware. Of course with IPV6 on the horizon, this will become less of an issue.The other barrier to entry for SSL is getting the cert itself. I am a believer that a self-signed cert is better than no cert at all, but we can do better. [Startcom](http://www.startcom.org/) is a SSL provider that provides free Level 1 certificates. Startcom's CA is in almost all browsers. I'm a big fan. So now with a combination of some apache rewrite lines:

    
    <VirtualHost *:80>
    RewriteEngine On
    RewriteCond %{HTTPS} off
    RewriteRule (.*) https://%{HTTP_HOST}%{REQUEST_URI} [R=301,L]
    </VirtualHost>


And that is my only vhost on :80, everything else is on :443.

	
  * **DNSSEC!**[ ](http://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions)[DNSSEC](http://en.wikipedia.org/wiki/Domain_Name_System_Security_Extensions) is a security extension to our DNS infrastructure that sets up a chain of trust, going from the ROOT name servers all the way down, to ensure that the answer you get for a dns query can be cryptographically verified. Kinda like SSL, it makes sure that the DNS server you are talking to is giving good answers. This works by sticking your public keys one level up the chain, and then that chain above you signs them. For example, I would submit my keys to the .com registry, and they would sign them.

But, .com is not yet participating in this. So as a temporary measure until all the TLDs are signing, ISC has setup a temporary trust anchor called [DLV](https://dlv.isc.org/). I've generated my keys and submitted to them. Using a great DNSSEC visualization tool, [dnsviz.net](http://dnsviz.net/), you can graphically see how the chain of trust flows (click to make it bigger):

[![A Graph Representing the DNSSEC Trust Relationships for xkyle.com](/uploads/auth_graph-300x300.png)](/uploads/auth\_graph.png)
At the top right you can see the root, represented with a "." You can see the black line means that it is not securely delegating to the .com part. But, the dlv.isc.org is, and it is giving a big blue arrow to my domain. See This for the full [visualization](http://dnsviz.net/d/xkyle.com/dnssec/), including a legend and explanation for all the little things. Its great! I use this [firefox extension](https://addons.mozilla.org/en-US/firefox/addon/64247/) to help let me know what sites are signed and which are not. You don't even have to be using actual DNSSEC nameservers for this to work. DNSSEC is a huge topic, probably deserving a dedicated blog post...

	
  * **IPV6!**IPv6 is the next generation Internet protocol. It uses 128bit ip addresses instead of 32 bit ones to solve the problem of [rapidly depleting address space](http://ipv6.he.net/statistics/). It is not all doom and gloom, certainly nothing to lose sleep over. But as a system administrator, I like being informed and up to speed on emerging technologies. Honestly though, IPv6 is not exactly new, it has been around in the Linux kernel since 1996...

Setting up IPv6 was pretty straightforward. I signed up for a tunnel from [He.net](http://tunnelbroker.net/main.php), ran the provided commands on my server, then initialized AAAA (quad A) records for my domain names. Restart apache and you are done (assuming it is running on \*:80)

This of course is me setting up IPv6 on the server side. To do it on the client side (at my house) I intend to investigate [Comcast's IPv6 trials](http://www.comcast6.net/). Currently I just take that same server side tunnel and use radvd to advertise it as an ipv6 router to my vpn. This is not as efficient as it could be, Comcast's IPv6 should provide lower latency. To give myself a warm fuzzy feeling, I use the [ShowIP Firefox extension](https://addons.mozilla.org/en-US/firefox/addon/590/?id=590) so I can see when I'm connected to an IPv6 enabled website. If you've got it all setup, check out [https://xkyle.com](https://xkyle.com) directly, and it should show a nice green IPv6 number in the lower right hand corner:
[![](/uploads/xkyle-ipv6.png)](/uploads/xkyle-ipv6.png)


So you might be thinking to yourself, "Wow Kyle, that is a lot of new things. I'm scared." Don't be scared. Learning about these technologies is a lot of fun, and actually implementing them is even more fun! So now you might be thinking, "Ok, this is cool, but I don't have a server or any of this stuff". What would you say if I told you that everything I did here was done for free? (With the exception of actually buying the domain name) If you have a pet domain name to play with already, what else do you need? SSL certs: free at [startcom](http://www.startssl.com/). IPv6 Addresses: Free at [he.net](http://tunnelbroker.net/). DNSSEC: [ISC](https://dlv.isc.org/) provides this for free to encourage DNSSEC adoption. Dedicated server: Amazon provides a [free micro virtual server](http://aws.amazon.com/free/) for a year for your Linux enjoyment. So lets get cracking! I challenge you to join the cutting edge of the Internet and trace to me with "mtr -6 xkyle.com" and verify my domain with "dig +dnssec xkyle.com"!
