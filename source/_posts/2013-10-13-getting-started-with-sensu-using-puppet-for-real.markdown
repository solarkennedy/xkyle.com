---
author: admin
comments: true
date: 2013-10-13 01:55:41+00:00
layout: post
slug: getting-started-with-sensu-using-puppet-for-real
title: 'Getting Started With Sensu Using Puppet. For Real. '
wordpress_id: 1023
categories:
- All
tags:
- nagios
- Puppet
- sensu
---

Nagios. So familiar. I feel like I've run Nagios at every job I have ever had.

Talk to most ops people, even at really big places, and they will probably admit to using it.

Puppet's [exported resources](http://docs.puppetlabs.com/guides/exported_resources.html) takes away some of the pain, but sometimes I think to myself, there must be a better way to do this. [Sensu](http://sensuapp.org/) might be that better way.

Let's try it out, but gosh, I am SO lazy. I cannot be bothered to read the installation instructions. All I want to do is install the puppet module, add a couple of lines to my manifest, and let puppet do the rest. Then I can run puppet agent in debug mode so when my boss comes by it looks like I'm REALLY busy.


# [![sensu_logo](/uploads/sensu_logo_large-300x260.png)](/uploads/sensu_logo_large.png)




# Step 1: Game plan


I've got a test server I know I want to be my sensu server. I know I'm going to have enable the sensu client run on the servers I want monitored. Here are my goals:



	
  * Have **sensu-server** configured on my server (call it _mon1_)

	
  * Have **sensu-client** configured on my client (call it _client1_)

	
  * I want a **dashboard**

	
  * I want a an **email alert**

	
  * I **don't** want to have to ssh to my clients to do anything. (I have puppet to do that for me, duh.)




# Step 2: Puppet Module


My puppet master is not _mon1_, but it doesn't matter. I run on the puppetmaster

    
    puppet module install example42/redis
    puppet module install puppetlabs/rabbitmq
    puppet module install sensu/sensu


Ok, good start. So...  the "For Real" part in the blog post title is about those *other* things that most howto's don't mention. Unless you already have RabbitMQ and Redis installed, you will need those modules. Don't know how to run Redis or configure RabbitMQ? It's ok, neither do I.


## Step 2A: SSL Certs


Yea, I know what you are thinking. Kyle, I already have SSL certs for my infrastructure, do I have make another set? Yes. I think so. I'm not smart enough to use existing certs.

Joe Miller has made a pretty easy script to generate some. For RabbitMQ you can basically use a single client and server key and let puppet distribute them:

    
    git clone git://github.com/joemiller/joemiller.me-intro-to-sensu.git
    cd joemiller.me-intro-to-sensu
    ./ssl_certs.sh generate
    mkdir -p /etc/puppet//files/sensu/
    cp *.pem testca/*.pem /etc/puppet/files/sensu/


You  can see that I just stick all the files in my "files/sensu" directory for puppet to distribute for me.


## Step 2B: Puppet config


Here is the configuration I needed to get a full system running:

    
    node mon1 {
      file { '/etc/rabbitmq/ssl/server_key.pem':
        source => 'puppet:///files/sensu/server_key.pem',
      }
      file { '/etc/rabbitmq/ssl/server_cert.pem':
        source => 'puppet:///files/sensu/server_cert.pem',
      }
      file { '/etc/rabbitmq/ssl/cacert.pem':
        source => 'puppet:///files/sensu/cacert.pem',
      }
      class { 'rabbitmq':
        ssl_key => '/etc/rabbitmq/ssl//server_key.pem',
        ssl_cert => '/etc/rabbitmq/ssl//server_cert.pem',
        ssl_cacert => '/etc/rabbitmq/ssl//cacert.pem',
        ssl => true,
      }
      rabbitmq_vhost { '/sensu': }
      rabbitmq_user { 'sensu': password => 'password' }
      rabbitmq_user_permissions { 'sensu@/sensu':
        configure_permission => '.*',
        read_permission => '.*',
        write_permission => '.*',
      }
      class {'redis': }
      class {'sensu':
        server => true,
        purge_config => true,
        rabbitmq_password => 'password',
        rabbitmq_ssl_private_key => "puppet:///files/sensu/client_key.pem",
        rabbitmq_ssl_cert_chain => "puppet:///files/sensu/client_cert.pem",
        rabbitmq_host => 'mon1',
        subscriptions => 'sensu-test',
      }
    }


Take note that the Sensu module lets you stick in a puppet:/// url for the certs, but the RabbitMQ module does not. Distributing them using the "file" directive is pretty easy though.

I personally believe that **purge_config** should default to true. We are using puppet here. If you are hand placing json, you are doing it wrong.


# Step 3: Clients


With your SSL certs in place, adding clients is pretty easy:

    
    node client1 {
      class { 'sensu':
        purge_config => true,
        rabbitmq_password => 'password', 
        rabbitmq_host => 'mon1',
        subscriptions => 'sensu-test',
        rabbitmq_ssl_private_key => "puppet:///files/sensu/client_key.pem",
        rabbitmq_ssl_cert_chain => "puppet:///files/sensu/client_cert.pem", 
      }
    }


Not too bad. Notice that there is nothing server-side to generate the config for this host.

After your puppet runs converge, you should be able to access the Sensu dashboard. By default it is on the sensu server, in this example it would be [http://sensu:secret@mon1:8080](http://sensu:secret@mon1:8080)

If all of this is working, you should see client1 in the clients list.


# Step 4: Handlers


Sensu [handlers](http://docs.sensuapp.org/0.11/handlers.html) are scripts that are called with event data. For getting started I use the simplest example:

    
    sensu::handler { 'default':
      command => 'mail -s "sensu alert" kyle@xkyle.com',
    }


You are going to get json in your body, but we can make it pretty later.


## Step 5A: Your first client-side check


This type of check is what you might consider an NRPE check, it runs on the client:

    
    node client1 {
    ...
      package { 'nagios-plugins-basic': ensure => latest } 
      sensu::check { "cron":
        handlers    => 'default',
        command     => '/usr/lib/nagios/plugins/check_procs -C cron -c 1:10',
        subscribers => 'sensu-test'
      }


Run puppet, stop cron, you should get an email.


#  Step 5B: Your first server-side check


Sometimes you need to have the servers do the checking. Not everything can be a client-side check. Sometimes you really do want your monitor server to be able to ping your clients (or check http, etc).

The Sensu documentation doesn't seem to have examples of this. The only way I know how to do it is with [stored configs](http://docs.puppetlabs.com/guides/exported_resources.html) with something like [puppetdb](http://docs.puppetlabs.com/guides/exported_resources.html):

    
    node client1 {
    ...
    @@sensu::check { "check-ping-$fqdn":
        handlers    => 'default',
        command     => "/usr/lib/nagios/plugins/check_ping -H $::ipaddress -w 100.0,60% -c 200.0,90% ",
        subscribers => 'sensu-test'
      }
    }
    
    node mon1 {
    ...
      Sensu::Check <<||>>
    }


In this case, the @@ in front of the sensu check tells puppet to not actually make it, just store it. Then the <<||>> operator on the server side will take those stored configs, and make them.


# Conclusion


Sensu is still new, but it shows a lot of promise. It is built from the ground up to be configured by machines, not by humans. It is also designed to scale, allowing you to grow your RabbitMQ cluster and your Sensu-servers at will.

Absent from Sensu (at the time of this writing) is the infrastructure for complicated time periods, escalations, etc. Maybe it is better that way? It does feel a little more unixy, with each individual Sunsu piece handling a very particular function.

Not mentioned in this post is how to manage subscriptions, making new handlers, adding [mutators](http://docs.sensuapp.org/0.11/mutators.html), supplementing the checks with [metrics](http://docs.sensuapp.org/0.11/adding_a_metric.html) and having Sensu handle them by shipping them [off to a metric system](http://docs.sensuapp.org/0.11/adding_a_metric.html), [sensu-admin](https://github.com/sensu/sensu-admin), having Sensu automatically detect [downed AWS nodes and not alert](https://github.com/agent462/sensu-handler-awsdecomm) on them, etc.

In the brave new elastic-compute-config-management-controlled world, Sensu looks like a lot better option than Nagios in my opinion.


