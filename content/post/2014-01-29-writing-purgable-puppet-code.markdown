---
categories:
- puppet
comments: true
date: 2014-01-29T05:33:58Z
title: Writing Purgable Puppet Code
---

Whenever possible, I try to write Puppet code that is purgable and 
"Comment Safe". That is not a very good description. What I mean is, Puppet
code that removes resources from a system when the corresponding Puppet 
code is "Commented" out of a manifest. Lets look at a few examples.

### Example: Managed Sudo

Lets say you used this [popular sudo module](https://forge.puppetlabs.com/saz/sudo)
with the following params:

```ruby
class { 'sudo':
  purge => true,
}
```

Great start. All future `sudo::conf` blocks you write will _automatically_ disappear
from the host:

```ruby
sudo::conf { 'web':
   source => 'puppet:///files/etc/sudoers.d/web',
 }
 
# Commenting out for now. Automatically is purged from the server
# sudo::conf { 'admins':
#   priority => 10,
#   content  => "%admins ALL=(ALL) NOPASSWD: ALL",
# }
```

Good stuff. Do this.

### Example: Managed Firewall

How about another example with the
[Puppetlabs Firewall module](https://forge.puppetlabs.com/puppetlabs/firewall)?

```ruby
# Automatically remove rules that are not declared
resources { "firewall":
  purge => true
} 

# Production needs 111 open
firewall { '111 open port 111':
  dport => 111
}
# Tried this but didn't work. Commenting out for now
# Automatically removed from the server when I commented it out
# firewall { '112 open port 112':
#   dport => 112
# }
```

### The Point?

The point here is that we should encourage a culture of purging. Having 
resources get automatically purged when you comment them out from puppet
is great. 

Of course, this is obsoleted in the short-lived world of docker or possibly
Amazon EC2. But for those engineers who work on long lived servers, this
prevents cruft.

### Going Further: Purging Packages

I want to purge packages. If someone installs a package not controlled by
Puppet, I want puppet to purge it. Crazy I know. 

```ruby
package { 'apache': ensure => installed }

# No longer using php
# But puppet leaves this behind!
# package { 'php5': ensure => installed }
```

Of course puppet will leave the package behind. I should be doing `ensure => purged` 
right?

But what if the package is deep within nested classes or simply manually installed? 

Some day I would like to get to the point where I at least get notified when
puppet detects packages that don't need to be there. I'm open to suggestions on
how to do this.

### Going Further: Purging /etc/

Most of the time stale configuration leftover in /etc/ causes no harm.

But what about cron jobs in `/etc/cron.d`? I would love to purge them, but there
are non-puppet controlled things installed by system packages. If *everything* was
a puppet module this could eventually be achieved, but it would be too hard 
to keep in sync with upstream package changes.

Purgin on a per-app basis with things like [sensu](https://github.com/sensu/sensu-puppet), 
[apache](https://forge.puppetlabs.com/puppetlabs/apache), and [sudo](https://forge.puppetlabs.com/saz/sudo)
are a great start. 

### Crossing the Line: Purging /var/lib/mysql

Seems like if you asked puppet to install mysql databases, and then 
commented them out, you would _not_ want puppet to purge them.

The subtle difference here might be the difference between **configuration** and 
**data**. 

### Conclusion

Whenever possible I try to `purge => true` on whatever I can. I would like to see
this as the **default** in new puppet modules. 

Someday I would like us to purge more than just files and iptables rules.
