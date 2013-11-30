---
author: admin
comments: true
date: 2013-11-30 00:19:24+00:00
layout: post
slug: sensu-reports-in-your-motd-with-puppet
title: Sensu Reports in your Motd with Puppet!
wordpress_id: 1043
categories:
- All
tags:
- Puppet
- sensu
---

## Intro


[Sensu](http://sensuapp.org/) is a pretty cool monitoring framework. The authors designed it to be configured by a configuration management system from the beginning. Check out how easily I can make it put a report in my motd with a little bit of python and puppet.


## The Report Script


Sensu's API is super easy to work with. For this I will be using the [Events](http://sensuapp.org/docs/0.12/api-events) endpoint. Here is a quick script to get the events for a host ([gist](https://gist.github.com/solarkennedy/7713642)):

``` python
#!/usr/bin/env python2
import json,sys,urllib2,socket

GREEN = '\033[92m'
RED = '\033[91m'
CLEAR = '\033[0m'

from optparse import OptionParser
parser = OptionParser()
parser.add_option("-s", "--server", dest="server",
                  help="sensu api server hostname", default='sensu')
parser.add_option("-p", "--port", dest="port",
                  help="sensu server api port", default='4567')
(options, args) = parser.parse_args()

response = urllib2.urlopen('http://' + options.server + ':' + options.port + '/events/' + socket.getfqdn())
data = json.load(response)
print
if len(data) > 0:
  print "Failed Sensu checks on this host:"
  for entry in data:
      sys.stdout.write("   " + RED + entry['check'] + ': ' + entry['output'] + CLEAR )
else: 
  print "All Sensu checks " + GREEN + "green " + CLEAR + "for this host."
print
```



##  Puppet Glue

{% codeblock lang:puppet %}
file { '/usr/bin/sensu_report':
  mode   => '0555',
  source => 'puppet:///files/sensu/sensu_report',
} ->
cron { 'sensu_report':
  command => "/usr/bin/sensu_report -s $sensu_api_server > /etc/motd",
  minute  => fqdn_rand(60),
} ->
sensu::check { "sensu_report":
  handlers    => 'default',
  command     => '/usr/lib/nagios/plugins/check_file_age -w 7200 -c 21600 -f /etc/motd',
  subscribers => 'sensu-test'
}
{% endcodeblock %}

You can see that there are three things going on here (gist [here](https://gist.github.com/solarkennedy/7713642)):

  1. Puppet drops in the python report script **file**.
  2. Only if the script is in place, it will setup the **cronjob** to populate the motd
  3. And only if the cron job is in place, a **sensu check** is installed to verify that it is indeed working (test driven system administration?).

[![sensu_motd](https://xkyle.com/wp-content/uploads/sensu_motd.png)](https://xkyle.com/wp-content/uploads/sensu_motd.png)


## Coolness
	
  *  Puppet and Sensu make it easy to construct things like this. Wiring something like this manually with nagios would be a pain.
  * Adding failed checks right in the MTOD increases visibility for them, while decreasing the brain overload of looking a huge sensu dashboard with tons of red that a random user may not care about.
  * Putting checks in the MOTD makes it easy to disseminate information about what might be down on a host, to minimize support requests and increase transparency.
