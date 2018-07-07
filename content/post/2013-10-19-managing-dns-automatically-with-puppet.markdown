---
author: admin
categories:
- dns
- Puppet
- puppetdb
- stored configs
comments: true
date: 2013-10-19T23:05:02Z
slug: managing-dns-automatically-with-puppet
title: Managing DNS Automatically with Puppet
wordpress_id: 1038
---

# Why


So you have a decent amount of things configured in Puppet. Great!

Are you finding that you have to manually update your DNS entries when things change, like when new hosts or added, or additional services are created?

Why? Your DNS zone files will forever be out of date, waiting for humans to update them. Just say no. Puppet already knows what the ip addresses and hostnames of your servers, why not take advantage of that existing data?


# How


Most of the credit for this has to go do [Adam Jahn](https://github.com/ajjahn) for his [original work](https://github.com/ajjahn/puppet-dns). But there is a lot of work to be done and many outstanding pull requests. Until things are more unified, I'm going to recommend installing my version of the module:

    
    puppet module install KyleAnderson/dns


Once the module is installed, you can setup bind on your nameserver:

    
    node 'ns1.example.com' {
      include dns::server
      ...


Warning: Don't try to use this on top of an existing configuration, Puppet will take control and break your existing stuff.

You can also create zones, right from puppet:

    
     dns::zone { 'example.com':
        soa         => $::fqdn,
        soa_email   => "admin.${::domain}",
        nameservers => ["${::hostname"]
      }


Now you can add A records:

    
    dns::record::a { $hostname:
       zone => 'example.com',
       data => $::ipaddress, 
    }




# Going Further


Using the [exported resources pattern](http://docs.puppetlabs.com/guides/exported_resources.html) and stored configs with say, [PuppetDB](https://docs.puppetlabs.com/puppetdb/latest/), you can create records on different hosts and then collect them on your name server. For example:

    
    node 'mycoolserver.example.com' {
      @@dns::record::a { $hostname: zone => $::domain, data => $::ipaddress, }
    }
    
    node 'ns1.example.com' {
      dns::zone { $::domain:
        soa         => $::fqdn,
        soa_email   => "admin.${::domain}",
        nameservers => [ 'ns1' ],
      }
      # Collect all the records from other nodes
      Dns::Record::A <<||>>
    }


In this example, an A record was requested on the mycoolserver node, but it could have been included on any class that includes lots of servers. In the end they show up on the ns1.example.com node with the <<||>> operator.


# Other Possibilities





	
  * Have your [HAProxy](https://forge.puppetlabs.com/puppetlabs/haproxy) or [F5 load balancer](https://forge.puppetlabs.com/puppetlabs/f5) configs automatically generate the new CNAMEs and A records they need to operate.

	
  * Setup your [Apache vhosts](https://github.com/puppetlabs/puppetlabs-apache#configure-a-virtual-host) to automatically point to the right server.

	
  * Never have to remember to update IPMI addresses by using the combining this with the [BMCLib](https://github.com/logicminds/bmclib) module.

	
  * Setup new hosts in [DHCP](https://forge.puppetlabs.com/zleslie/dhcp), and have them automatically get an A record to go with them.

	
  * Have [NTP](http://forge.puppetlabs.com/puppetlabs/ntp) servers? Did you remember to update their DNS records? Oh wait, puppet does that for you.




# Future Work


I will continue to send my pull requests and maintaining my own fork. [Join the fun](https://github.com/solarkennedy/puppet-dns)!
