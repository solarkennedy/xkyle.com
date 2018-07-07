---
author: admin
categories:
- bios
- dell
- hp
- intel
- Puppet
comments: true
date: 2013-04-15T21:06:09Z
slug: my-first-published-puppet-module-bios
title: 'My First Published Puppet Module: bios'
wordpress_id: 945
---

# What?


I've written lots of crappy Puppet modules. Here is a slightly less crappy module that can help you configure BIOS settings on your servers for you.

It works on Dell C class servers and Intel platforms. Please pull request or email me if you want to have it work on something else too!


# Why?


BIOS settings should be considered configuration just like any other configuration, and hence managed by your configuration management tool, if possible.

[http://forge.puppetlabs.com/KyleAnderson/bios](http://forge.puppetlabs.com/KyleAnderson/bios)

[https://github.com/solarkennedy/puppet-bios](https://github.com/solarkennedy/puppet-bios)


#  How?


Install it:

    
    puppet module install KyleAnderson/bios


Here are some examples on how to use it:

    
    # Easy to set turbo on a dell 
    bios::setting {'turbo_mode': value => 'disabled' } 
    
    # Intel requires some more hand holding with turbo. You set 1/0 and expect Enabled/Disabled.. 
    bios::setting {'Intel(R) Turbo Boost Technology': value => '0', expect => 'Disabled', section => 'Processor Configuration' }
    
    # Set fan speed on intel: 
    bios::setting {'Fan PWM Offset': value => '100', section => 'System Acoustic and Performance Configuration' }
    
    # Disabled Cstates on dell:
    bios::setting {'c_states': value => 'disabled' }
