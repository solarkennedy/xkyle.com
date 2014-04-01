---
layout: post
title: "What Happens When You Run Puppet Tests"
date: 2014-03-31 05:33:58 -0800
comments: true
published: false
categories: 
- puppet
---

## Breaking down bundle exec rake spec

What is happening when you run:
```
bundle exec rake spec?
```

#### Bundle 

The first command you are running is [bundle](http://bundler.io/). Bundle is 
kinda like virtualenv for Ruby. It makes sure that you use the same ruby 
libraries that you, everyone, and puppetmasters use. 

Bundle uses a Gemfile, and searches downwards. As long as you have the Gemfile
in the puppet repo, it will work.

#### Exec

The second part is exec. Exec is an argument to bundle, it simply means run a 
command. Because you are running it in a “bundled” environment, it runs the 
next command that is part of your bundle, with the ruby libraries in your 
Gemfile.

#### Rake

The third part is rake.  Rake is like Make for Ruby. It requires a Rakefile. 
Each puppet module needs a Rakefile. 

You don’t need to re-invent the Rakefile, simply have this in it:
```ruby
require 'puppetlabs_spec_helper/rake_tasks'
```
This ensures that we are all running tests in the same way.

#### Spec

4th is spec.  Spec is a “rake task” that runs Rspec. Rspec is the ruby testing framework. 
Rspec + puppet-rspec is a whole other thing described Next Section.

## How does Rspec Test Puppet Code?

If you are running bundle exec rake spec, rspec takes over in the environment
 provided by bundler. It gives you all the gems necissary to do the job, but 
how does Rspec know about Puppet Code?

If you are including the 
puppetlabs_spec_helper/rake_tasks, your 
[exact task](https://github.com/puppetlabs/puppetlabs_spec_helper/blob/master/lib/puppetlabs_spec_helper/rake_tasks.rb#L106)
includes the prep/test/clean stuff.


