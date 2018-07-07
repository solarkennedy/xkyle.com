---
categories:
- puppet
comments: true
date: 2014-03-31T05:33:58Z
published: true
title: What Happens When You Run Puppet Tests
---

## Breaking down bundle exec rake spec

What is happening when you run:

```bash
bundle exec rake spec
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

Spec is a “rake task” that runs Rspec. Rspec is a ruby testing framework. 
Rspec + puppet-rspec is a whole other thing described Next Section.

## How does Rspec Test Puppet Code?

If you are running bundle exec rake spec, rspec takes over in the environment
 provided by bundler. It gives you all the gems necissary to do the job, but 
how does Rspec know about Puppet Code?

If you are including the puppetlabs_spec_helper/rake_tasks, your 
[exact task](https://github.com/puppetlabs/puppetlabs_spec_helper/blob/master/lib/puppetlabs_spec_helper/rake_tasks.rb#L106)
includes the prep/test/clean stuff.

You need some boilerplate files in place for rspec-puppet tests to run. You can
either run

```bash
rspec-puppet-init
```

Or you can [manually setup](http://rspec-puppet.com/setup/) the files and folders.
Here I will describe the minimal set of files you need:

### .fixtures.yml

.fixtures.yml is a puppet_spec_helper construct that allows you to symlink in
other modules that might be required to test your code. For example you might
require functions from the stdlib. How does Rspec know where stdlib is?

```yaml
fixtures:
  repositories:
    stdlib: "git://github.com/puppetlabs/puppetlabs-stdlib.git"
  symlinks:
    your_module: "#{source_dir}"
```

When rspec runs the preparation parts, the spec_helper will create symlinks,
or [clone repos, or whatever.](https://github.com/puppetlabs/puppetlabs_spec_helper#fixtures-examples)

### spec/spec\_helper.rb

spec/spec_helper.rb is a file you need in place for your rspec tests to reference.
If you are using the puppetlabs_spec_helper gem, it is only one line:

```ruby
require 'puppetlabs_spec_helper/module_spec_helper'
```

This spec_helper.rb file can now be referenced, and by doing so will 
allow Ruby to import all of the puppet-specific Rspec matchers it needs to 
function.

For example, at the top of every Rspec ruby file you should see something like this:

```ruby
require 'spec_helper'

describe 'my_module' do

  it { should compile }

end
```

### Directory structure

Putting files in the right places allows Rspec to autodetect them. Giving them a
conventional name allows rspec to glob them.

As the scope of your testing increases, a well-organized directory structure is 
essential:

```
├── spec
│   ├── classes
│   │   └── example_spec.rb
│   ├── defines
│   ├── functions
│   ├── hosts
│   ├── spec_helper.rb
│   ├── spec_helper_system.rb
│   └── system
│       └── basic_spec.rb
```

### The Tests

How to write puppet tests is outside the scope of this particular blog post.

I recommend looking at solid examples from puppetlabs' github, or right from the
[offical documentation](http://rspec-puppet.com/tutorial/).

But essentially, Rspec runs puppet in a noop mode, only generating a catelog
of what it would do. Then the rspec tests use [matchers](http://rspec-puppet.com/matchers/)
to describe assertions against the catelog. 
