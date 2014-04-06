---
layout: post
title: "Managing Ssh Known Hosts With-Serf"
date: 2014-04-06 05:33:58 -0800
comments: true
published: true
categories: 
- puppet
- serf
---

[Serf](http://www.serfdom.io/) is a very interesting service discovery mechanism.
Its dynamic membership and tags capability make it very flexible. Can we use it
to generate a centralized `ssh_known_hosts` file?

## Installing and Configuring Serf 

I like to use configuration management to manage servers. Here I use a 
[Puppet module](https://github.com/justinclayton/puppet-module-serf) to 
install and configure Serf:

```puppet
class { 'serf':
  config_hash   => {  
    'node_name'  => $::fqdn, 
    'tags'       => {
      'sshrsakey' => $::sshrsakey
    },          
    'discover'   => 'cluster',
  }     
}
```

This particular module uses a hash to translate directly into the `config.json`
file on disk. Notice how I'm using the new `tags` feature, and adding a `sshrsakey` 
tag, populated by Puppet's facts.

## Querying The Cluster

Once the servers have Serf installed and configured, the cluster can be queried
using the serf command line tool:

```
$ serf members
server1.xkyle.com    192.168.1.67:7946    alive    sshrsakey=AAAA...
server2.xkyle.com    192.168.1.69:7946    alive    sshrsakey=AAAA...
```

## Using the Data

Lets use this data to write out our `/etc/ssh/ssh\_known\_hosts` file,
emulating the the functionality of ssh-keyscan:

```bash
$ serf members -format=json | jq -r '.members | .[] | "\(.name) ssh-rsa \(.tags[])" ' | tee /etc/ssh/ssh_known_hosts
server1.xkyle.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTfPpmHhc+LoD05puxC...
server2.xkyle.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCmzk+Chzrq73c5ytU9I...
```

So... you can see I'm using [jq](http://stedolan.github.io/jq/manual/) to
manipulate the JSON ouput of the serf command. I'm not super proud of it,
but it works.

Lets see if we can use a script instead? Serf provides and 
[RPC protocol](http://www.serfdom.io/docs/agent/rpc.html) to interact with
it programmatically:

```ruby
#!/usr/bin/env ruby
require 'serf/client'
client = Serf::Client.connect address: '127.0.0.1', port: 7373
members = client.members.value.body['Members']
puts members.collect { |x| x['Name'] + ' ssh-rsa ' +  x['Tags']['sshrsakey'] }
```

Of course, no error handling or anything. This script achieves the same 
result using the [serf-client ruby gem](https://rubygems.org/gems/serf-client).

There are libraries to connect to the Serf RPC directly for many languages,
or you can do it yourself using the [msgpack RPC library](http://msgpack.org/rpc/rdoc/current/MessagePack/RPC.html)
to communicate directly on the tcp socket.

## Conclusion

This is just the beginning. Serf allows retrieving the status of members, but
also can spawn programs (handlers) whenever members 
[join or leave](http://www.serfdom.io/docs/agent/event-handlers.html).

Additionally you can invoke [custom events](http://www.serfdom.io/docs/commands/event.html)
for your own uses, like code deploys. 

If you can deal with an [AP](https://en.wikipedia.org/wiki/CAP_theorem) discovery
and orchistration system, then Serf could be a foundation for building great things!
