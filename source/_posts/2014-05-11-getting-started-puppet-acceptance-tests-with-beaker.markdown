---
layout: post
title: "Getting Started Puppet Acceptance Tests With Beaker"
date: 2014-05-11 10:18:56 -0700
comments: true
categories:
 - puppet
---

[Beaker](https://github.com/puppetlabs/beaker) is a test framework created by
Puppetlabs to run tests against puppet modules on real servers (vm, containers
whatever) and test that they do what they say they should do.

This is a quick tutorial on how to use this framework. At the time of this 
writing, Beaker is under heavy development, so this could all change.

## The Gem
The first thing you need to do is install beaker. Usually this is as simple as
adding it to your Gemfile and running `bundle install`.

    gem 'beaker'
    gem 'beaker-rspec'

I recommend using [grethr](http://www.morethanseven.net)'s
[puppet module skeleton Gemfile](https://github.com/garethr/puppet-module-skeleton/blob/master/skeleton/Gemfile)
, which includes Beaker already.

Now install it:

    bundle install

## Acceptance Boilerplate

### Rspec and the Puppetlabs Helper

This tutorial assumes you already have the puppetlabs\_spec\_helper installed,
rake, rspec, etc. 

### Folder For Tests

You need a place to put acceptance tests. They must go in

    module_root/spec/acceptance/

See [puppetlabs-mysql](https://github.com/puppetlabs/puppetlabs-mysql/tree/master/spec/acceptance) 
for an example of what it looks like.

### Nodesets

You must have at least a default.yml in the nodesets folder inside your
acceptance folder. Here is an example:

```
# consul/spec/acceptance/nodesets/default.yml
HOSTS:
  ubuntu-12-04:
    platform: ubuntu-12.04-x64
    image: solarkennedy/ubuntu-12.04-puppet
    hypervisor: docker
CONFIG:
  type: foss
```

You can have different yaml files for different platforms you wish to test 
against. The format is described in the 
[Beaker wiki](https://github.com/puppetlabs/beaker/wiki/Creating-A-Test-Environment)

**Note**: I use my own docker files for speed, as they come preinstalled with the 
the [Beaker Host Requirements](https://github.com/puppetlabs/beaker/wiki/Creating-A-Test-Environment#host-requirements)

**Warning**: If you use docker, you cannot test service things because there is 
no init running inside the container. For comprehensive testing against things
like services, firewalls, etc, you must use a true hypervisor with Vagrant.

### Acceptance Spec Helper

```ruby
# consul/spec/spec_helper_acceptance.rb
require 'beaker-rspec'

# Not needed for this example as our docker files have puppet installed already
#hosts.each do |host|
#  # Install Puppet #  install_puppet
#end

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(:source => proj_root, :module_name => 'consul')
    hosts.each do |host|
      # Needed for the consul module to download the binary per the modulefile
      on host, puppet('module', 'install', 'puppetlabs-stdlib'), { :acceptable_exit_codes => [0,1] }
      on host, puppet('module', 'install', 'nanliu/staging'), { :acceptable_exit_codes => [0,1] }
    end
  end
end

```

The spec helper does the tasks needed in order to prepare your SUT (system 
under test). This might include installing puppet, installing your puppet 
module dependencies, etc.

## Example Acceptance Test

```ruby
# module_root/spec/acceptance/standard_spec.rb
require 'spec_helper_acceptance'

describe 'consul class' do

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors based on the example' do
      pp = <<-EOS
        file { '/opt/consul/':
          ensure => 'directory',
          owner  => 'consul',
          group  => 'root',
        } ->
        class { 'consul':
          config_hash => {
              'datacenter' => 'east-aws',
              'data_dir'   => '/opt/consul',
              'log_level'  => 'INFO',
              'node_name'  => 'foobar',
              'server'     => true
          }
        }
      EOS

      # Run it twice and test for idempotency
      expect(apply_manifest(pp).exit_code).to_not eq(1)
      expect(apply_manifest(pp).exit_code).to eq(0)
    end

    describe service('consul') do
      it { should be_enabled }
    end

    describe command('consul version') do
      it { should return_stdout /Consul v0\.2\.0/ }
    end

  end
end
```

The filename is important, it must end in \_spec.rb in order for the test
harness to detect it. You can see that there are many 
[matchers](http://serverspec.org/resource_types.html) you can use to run 
pretty much any kind of test you can think of.

See the [puppetlabs-mysql](https://github.com/puppetlabs/puppetlabs-mysql/tree/master/spec/acceptance)
collection again for some great examples.

## Running Them

    bundle exec rake acceptance

This command will spin up your described servers in nodesets, install your 
puppet modules and dependencies, and test your assertions.

## Conclusion

Acceptance tests should be used sparingly, they are the top of the testing
[testing pyramid](http://martinfowler.com/bliki/TestPyramid.html). 

They are slow, touch the disks and network, and depend on external resources.
The example mysql acceptance tests literally install mysql, install and 
configure databases, and assert that they exist.

They will may be slow, but they can be very helpful, and potentially the 
only way to really test functionality of a puppet module in an end-to-end 
way.

Puppet is a system configuration management tool. Unit tests can only go 
so far to make sure the compiled catalog is "correct". Puppet acceptance
tests can help you go 100% and ensure that your module literally does 
what it says it does by running tests against actual systems, files, 
packages, and services.
