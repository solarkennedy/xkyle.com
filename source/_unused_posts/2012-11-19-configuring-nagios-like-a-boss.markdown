---
author: admin
comments: true
date: 2012-11-19 05:41:17+00:00
layout: post
slug: configuring-nagios-like-a-boss
title: Configuring Nagios Like a Boss!
wordpress_id: 790
categories:
- All
tags:
- linux
- nagios
- Puppet
---

I'm tired of configuring Nagios by hand. Just tired. I always forget to do stuff. I'll add a new host, or stick in a raid card, add a new website, whatever, and forget to add a nagios check for it.

[![](/uploads/nagiosforget.png)](/uploads/nagiosforget.png)

So it happened. You setup a server, put critical infrastructure on it, but forgot to monitor it. It goes down, bad stuff happens. Your boss asks, why weren't we monitoring this? Let me supply a few options to prevent this from happening in the future:



	
  1. Enforce draconian punishment for people who forget to do it (one cutoff finger per service check?)

	
  2. Have strict workflows/bkms/procedures for doing things like adding a vhost, starting a server, etc that include a step for adding them to Nagios

	
  3. Invent a fake sysadmin named Paco, and blame all the mistake on him.

	
  4. Automate it with puppet. Then blame puppet when it goes wrong!




# A Migration Plan


Let's do it. Let's make puppet do the work. After all, puppet is aware of my hosts, and it even knows what services are running them.

You don't have to switch all at once, you can have a mix of automatically generated and manually configured checks. I like to put my automated definitions go into folders called hosts.d and services.d. Do what makes sense for your environment.


# Howto


First, define a "virtual resource" wherever a service is defined. Lets take a really simple, but overlooked example of health-checking raid:

    
    class nagios_checks::raid {
       file { "/usr/lib64/nagios/plugins/check_raid":
          mode => 555,
          source => "puppet:///modules/nagios_checks/check_raid",
       }
       @@nagios_service { "${fqdn}_raid":
          ensure => present,
          host_name => "$fqdn",
          use => "generic-service",
          target => "/etc/nagios/services.d/$fqdn-raid.cfg",
          check_command => "check_nrpe!check_raid",
          service_description => "raid",
          notify => Service["nagios"],
       }
    }


So what is going on here? In this class we define a Nagios plugin, and we copy it over. (I like making things that puppet copies over set to 555 as a reminder that I shouldn't be editing them)

The virtual resource is "@@nagios_server". The @@ means that the resource is just saved on the puppet master, and not instantiated on the client. (this assumes you have [stored configs](http://projects.puppetlabs.com/projects/puppet/wiki/Using_Stored_Configuration) enabled in your puppet setup.)

With "target =>" I'm dumping the config into /etc/nagios/services.d/$fqdn-raid.cfg. It's a good idea to let puppet put service definitions in separate files. Making puppet scan a single file chock full of definitions will be slow.

If this virtual resource is defined on a bunch of clients, on some nagios server we need to let puppet dump these files:

    
    class nagios::server {
       package { nagios:
          ensure => latest;
       }
       service { "nagios":
          ensure => running,
          enabled => true,
       }
    
       # Hack for bug #3299 where nagios stuff is root:600
       file { ["/etc/nagios/hosts.d/", "/etc/nagios/services.d/"]:
          ensure => directory,
          mode => 644,
          recurse => true,
       }
    
       # Collect and instantiate all the puppet stuff
       Nagios_host <||>
       Nagios_service <||>
    
    }


That is a basic recipe for a Nagios server. We get the package, make sure the package is running, fix some permissions... when what the crap is that?

The <||> operator takes virtual resources that were defined on other servers, and then makes them real. This means the $fqdn-host.cfg files will be created wherever this nagios::server is setup.

So go forth, and define @@nagios_services's whenever you have a puppet server setup. Like a boss.

[![](/uploads/gravitron-300x225.jpg)](/uploads/gravitron.jpg)
