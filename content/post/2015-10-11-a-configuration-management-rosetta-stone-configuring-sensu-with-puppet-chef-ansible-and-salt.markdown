---
alias:
- a-configuration-management-rosetta-stone-configuring-sensu-with-puppet
categories:
- puppet
- chef
- ansible
- salt
- sensu
comments: true
date: 2015-10-11T18:21:14Z
slug: configuration-management-rosetta-stone-configuring-sensu-with-puppet-chef-ansible-and-salt
title: 'A Configuration Management Rosetta Stone: Configuring Sensu with Puppet, Chef,
  Ansible and Salt'
---

I recently finished my [Intermediate Sensu Training](https://www.udemy.com/sensu-intermediate/?couponCode=xkyle) on Udemy.
It was a ton of work but I'm glad I got it all together. Part of that training
includes how to deploy and configure [Sensu](https://sensuapp.org/) with four
of the most popular open-source configuration management tools:
[Puppet](https://puppetlabs.com/puppet/what-is-puppet),
[Chef](https://www.chef.io/chef/), [Ansible](http://www.ansible.com/), and
[Salt](http://saltstack.com/).

* TOC
{:toc}

## The Sensu Decree

In order to do the training I had to learn each of these tools enough so I could install
a baseline Sensu installation. Here is what I reproduced with each iteration:

* A Sensu client, Server, and API Setup and Running
* RabbitMQ Server, User, and Sensu Vhost ready for use. (no SSL)
* Redis installed and running for state
* A Sensu check (`check_disk` and/or `check_apache`)
* The Sensu Mail handler to send emails for alerts
* The Uchiwa Dashboard
* All on one host (localhost)

This was no small feat, and required using a non-trivial number of features of each configuration management system to get the job done.

Here were some other guidelines that I followed in this exercise:

* Always use 3rd party modules/cookbooks/etc. Use official ones if possible.
* Use the local-execution mode provided by the configuration management tool
  (no client/server setup)
* Follow official docs when available for general guidelines for things like
  installation.
* Differences in things like config file names or versions of Redis are
  inconsequential. As long as Sensu behaved the same I considered it complete.
* No considerations for security (out of scope for this exercise)

## Review of Each Tool

### Puppet

#### Puppet In General

Puppet is my "native language" when it comes to configuration management, so it
is a little hard for me to imagine what it is like to *not* know what it is
like to know exactly how it works.

Puppet has a custom DSL to describe configuration in terms of "types". These are
the primitives that you can build infrastructure upon, things like "files, "package",
and "service". Third party modules can extend that language with custom types,
allowing you to abstract over the "raw" types. For example, the RabbitMQ has a
type for providing `rabbitmq_user`s, which do not correspond to a particular
config file or anything, but instead can only be added by special invocations
of the `rabbitmqctl` command.

Puppet strongly emphasizes code-reuse. The [Puppet Forge](https://forge.puppetlabs.com/) is the registry where you can upload and
share modules. The Forge has a number of methods to help indicate code quality.
It also exposes "officially supported" and "officially approved" modules, for
extra approval stamps. While the forge may have a very "long tail" of modules
that do very common tasks, the set of officially-supported and
officially-approved modules leaves behind a good selection of high-quality
modules ready for re-use.

A common criticism of Puppet is that it does not apply resources in the order that
they are declared in the manifest. Instead, Puppet internally calculates a directed
graph of resources and their dependencies, and executes them in a dependent order, which
is not necessarily in the order in which they are parsed. This is similar to how Linux
package managers install packages. If you run `apt-get install apache libc libssl`,
the packages will not necessarily get installed in the order that they were
specified on the command line.

Puppet also comes with [Hiera](http://docs.puppetlabs.com/hiera/1/#why-hiera),
a convenient hierarchical key/value store. This store allows users to override
and set site-specific settings to Puppet modules without having to fork or modify
them. Hiera encourages custom hierarchies that meet your business needs, allowing
users to specify settings in a way that makes the most sense for their environments.
And example hierarchy might look something like:

```
hieradata/
├── common.yaml
├── environment
│   ├── dev.yaml
│   └── prod.yaml
├── datacenter
│   ├── dc1.yaml
│   └── dc2.yaml
└── hostname
    ├── web1.yaml
    └── web2.yaml
```

Then Hiera looks up parameters from most-specific (hostname) to least-specific
(common), and returns the first value that is available.


#### Review of the Sensu Puppet Module

The [sensu-puppet module](https://github.com/sensu/sensu-puppet) is a
first-class citizen in the Sensu world. It has native types for the Sensu JSON
files that it manages, as well as a `sensu-gem` type for easily installing
rubygems with the embedded Sensu ruby.

The Sensu Puppet module only manages Sensu, and has no integration with any
other RabbitMQ, Redis, or any other module. To me this is expected, in the
Puppet world it would be the job of a `profile` to combine the Sensu module
with RabbitMQ and other things. For the most part this integration is left as
an exercise to the reader.

The Sensu Puppet module also doesn't manage Uchiwa. That requires a
[different puppet module](https://github.com/Yelp/puppet-uchiwa). Again to me
this is a good thing, I hate it when tools try to do too much.

The actual codebase is actively maintained and reasonably active, with a few
releases per year. The Puppet Forge rates it almost perfectly for module quality.
The code has excellent unit test and acceptance test coverage. As far
as Puppet modules go, the Sensu Puppet module is a great example of a
well-maintained piece of code.

One downside the "completeness" of the module is that sometimes new features of
Sensu are released, and the puppet-module will lag. The configuration inputs to
the puppet module are well-typed, and not just free-form hashes. This gives a
lot of guardrails and helps ensure config files are correct before they hit
the disk, but it means that some features are not usable until the Puppet
module can account for them.

Although the code worked, there was a [significant bug](https://github.com/sensu/sensu-puppet/issues/336) that prevented the
module from ever converging. This was annoying but allowed me to test the code.
This bug looks to be fixed in master.

### Chef

#### Chef in General

Chef is not as old as Puppet, but is certainly a mature product. Chef is "just
ruby" when it comes to its configuration language. The upside to this is that
Ruby developers can theoretically dive in and hack on stuff. The downside to
this is that being "just ruby", "leaves a lot of rope to hang yourself".

One nice feature provided by the Chef company is their hosted chef solution, which
allows people to get started without hosting a Chef-server.

The Chef toolset also comes with the `knife` command, which is a great command
line tool for interacting with the Chef-server. It also is a parallel-ssh tool,
manipulates chef cookbooks, and can also launch ec2 (and other) instances. (did
they take the kitchen-sink metaphor too far?)

The [Chef Supermarket](https://supermarket.chef.io/) serves as the public
registry for Chef cookbooks. There are not too many quality indicators to see,
to help find which cookbooks are any good. The best metric I could see is just
sorting by "followers". This is made up by the fact that there are over
a hundred [officially supported cookbooks](https://supermarket.chef.io/users/chef).

Probably the most difficult aspect of Chef for me to understand was how
attributes interact. This confusion is probably most obvious when you look at
Chef's [15 levels of attribute precedence](https://docs.chef.io/attributes.html#attribute-precedence). It seems
to me that there should be a more obvious way for intent to flow, but I could
be just spoiled by Puppet's Hiera.

#### Review of the Chef-Sensu Cookbook

The [Sensu Chef Cookbook](https://github.com/sensu/sensu-chef) is also a
first-class citizen in the Sensu-world. Chef is the "native config language" of
[Sean Porter](https://github.com/portertech), the main author of Sensu. This
gives a lot of credibility to the Cookbook, and shows in the [contributor page](https://github.com/sensu/sensu-chef/graphs/contributors).

The Cookbook itself is feature complete, with recipes for installing and
configuring all aspects of Sensu.

The scope of the cookbook includes all Sensu related technologies, including
RabbitMQ, Redis, and Uchiwa. It is certainly "batteries included" and on by
default.  It even downloads and compiles [Redis from source](https://github.com/sensu/sensu-chef/issues/340) for you.

Another example of this "batteries included" design is the RabbitMQ module
[setting](https://github.com/jjasghar/rabbitmq/pull/301)
[Apt](https://github.com/jjasghar/rabbitmq/pull/302/files) attributes. Like the
above Redis example, this behavior surprised me, but technically it is not related to
the Sensu chef cookbook.

At the same time, [wrapper cookbooks](https://github.com/portertech/chef-monitor) are recommended as a
method to combine multiple cookbooks together in a coherent way. I think in
general I just expected the wrapper cookbooks to do more and the main Sensu
cookbook to do less.

The cookbook does have an integration test suite, but it is not run via Travis.
The code is under active development, and does multiple releases a year. It has
native support for Chef [data bags](https://docs.chef.io/data_bags.html) for
transporting the RabbitMQ SSL support, which is a nice touch (Not tested in
this review).

### Ansible

#### Ansible in General

Ansible is a relative newcomer to the configuration management space. Ansible
uses yaml files to define desired state. The yamls files are a nice way to
represent things, but it would be misleading to think that Ansible is just yaml
files. Ansible has its own DSL and uses Jinja2 templating, which is parsed
*over* the contents of the yaml.

The [Ansible Galaxy](https://galaxy.ansible.com/) is the community registry for
uploading shared roles. You can [sort by rating](https://galaxy.ansible.com/list#/roles?page=1&per_page=10&sort_order=owner__username,name&f=apache)
to try to get a better idea about which roles are potentially higher quality
than others.

There doesn't seem to be any official roles/playbooks. The closest there is to
official roles is the
[ansible-examples](https://github.com/ansible/ansible-examples/tree/master/lamp_simple)
repository. But click the link and look at the `lamp_simple` example. There is
no code-reuse at all! Every example re-invents how to install apache, install
ntp, configure iptables, etc. What's up with that?

While the yaml files may make it very easy for beginners to make playbooks that
get things done quickly, I don't think they will work out great as
infrastructure expands. The [abstractions just are not there](https://github.com/ansible/ansible-examples/blob/49708518fab943a37bdbf15ee61177155f0cc50f/lamp_simple/roles/web/tasks/install_httpd.yml#L15-L17)

Another sign, to me, that Ansible has the wrong abstractions is that
so many roles are distro specific.
Not many have the necessary code to work on both "CentOS" and "Debian".  There
is a generic [package](http://docs.ansible.com/ansible/package_module.html)
type, but very few roles use it? Check out [the original author's opinion on the subject](https://groups.google.com/forum/#!msg/ansible-project/x2_9PzAJXNE/ZwcBv02oAhkJ).
Look at the examples! They all only work on `yum` based distributions. 

I've read lots of posts of people migrating to Ansible and loving it.
Personally, I don't get it. The abstractions are too low-level. If you are lucky,
then the Ansible core has a Module to manipulate the resources on the host,
like [RabbitMQ stuff](http://docs.ansible.com/ansible/rabbitmq_user_module.html). If you are
unlucky, then the only primitives you have available are yaml files and
[running commands and parsing stdout](http://www.hashbangcode.com/blog/adding-iptables-rules-ansible).
Or you can write your [own module](http://docs.ansible.com/ansible/developing_modules.html).

#### Ansible Sensu Playbook Review

There is no official Sensu Ansible playbook. I was not able to find any playbooks
that support RedHat-based distributions.

Luckily, I was able to use [Mayeu's ansible playbook](https://github.com/Mayeu/ansible-playbook-sensu), in conjunction with
this [RabbitMQ playbook](https://github.com/Mayeu/ansible-playbook-rabbitmq) on
my Ubuntu server.

The `sensu_check` module is part of the "Extras", but it is only a very small
part of deploying Sensu, and it has no cohesion with the playbook that actually
deploys Sensu itself. There is no way to extend `sensu_check` without forking
[ansible-modules-extras](http://github.com/ansible/ansible-modules-extras). It
can't consume arbitrary check metadata.

In the end, to meet my needs I had to construct hashes myself and deploy them
to disk as JSON. The playbook-provided way to deploy sensu checks is to have
them all contained in the single
[sensu\_checks](https://github.com/Mayeu/ansible-playbook-sensu#general-variables)
variable.

### Salt

#### Salt in General

Salt is also a relative new-comer to the configuration management world. As a
user, Salt feels very similar to Ansible. They both use yaml files to represent
the desired state of the system. Both use Jinja templates. Both require the
"advanced" system interaction to happen with the core stuff, and the
Salt formulas can be just yaml with no real code.

Salt takes a different approach to sharing community code compared to the
other configuration management systems. Salt keeps all the official formulas in
one [GitHub project](https://github.com/saltstack-formulas). The docs recommend
[forking the formula](https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#adding-a-formula-as-a-gitfs-remote)
for your own use. On the plus side, having "canonical" formulas for common
tasks reduces duplication and encourages code re-use. The downside is that... it
encourages forking? These formulas in general are not that extensive. They
don't have releases or any kind of testing in place.

Salt's [Pillar](https://docs.saltstack.com/en/latest/topics/pillar/) is a powerful tool for separating configuration from code.
It is similar to Puppet's Hiera. Pro: separate config from code; keep
the site-specific variables in a separate folder than the formulas. Con:
formulas have to be "pillar-aware". There is no equivalent to Puppet's
[automatic parameter lookup](https://docs.puppetlabs.com/hiera/1/puppet.html#automatic-parameter-lookup).

#### Sensu Salt Formula Review

For my testing, I used the official
[Salt-formula](https://github.com/saltstack-formulas/sensu-formula). There is
a sensu-salt repo on the official Sensu project, but it is not really suitable
for production use in my opinion.

For the most part, the formula did what it said on the tin. Of course, like
Ansible, the only way I was able to deploy checks in a flexible way was to
construct my own Hashes and deploy them as JSON directly. There is no such thing
as a `sensu_check` type in Salt.

I was not able to get rid of the [hard-coded cron check](https://github.com/saltstack-formulas/sensu-formula/blob/5ca104f5aec94a20d206e98fb0d030674c8514b9/sensu/files/conf.d/check_cron.json).
I guess goes with the idea that they expect you to fork the repo and make your
own local changes to meet your needs. I thought I should maybe open an issue for
this, but the file has been there for a year and nobody else has complained. I
figured it was just me, and maybe I should get over myself and accept the fact
that I got a free cron check!

In my own testing, I used the native `gem` provider with a special path to
Sensu's gem binary to install Sensu gems. But then I discovered that the
formula did this too, but [in two](https://github.com/saltstack-formulas/sensu-formula/blob/5ca104f5aec94a20d206e98fb0d030674c8514b9/sensu/server.sls#L60-L63)
[different ways](https://github.com/saltstack-formulas/sensu-formula/blob/5ca104f5aec94a20d206e98fb0d030674c8514b9/sensu/client.sls#L89-L92),
using the `cmd.run` method instead of the native `gem` method.  I didn't really
like this, but at the same time, this is the first time I've ever used Salt.

As far as I can tell, to do more advanced Sensu config things, like filters or
mutators, you are expected to fork the formula and drop in the json file into
[the right directory](https://github.com/saltstack-formulas/sensu-formula/tree/5ca104f5aec94a20d206e98fb0d030674c8514b9/sensu/files/mutators).

## Comparison

A rough opinionated comparison between the tools, with regards the tool itself
and the tool in conjunction with Sensu. "High" doesn't necessarily mean "good" here:

|                                                     | Puppet | Chef                | Ansible         | Salt     |
|-----------------------------------------------------|--------|---------------------|-----------------|----------|
| **Review of The Config Management Tool in General** |        |                     |                 |          |
| Version used                                        | 3.4.3  | 12.4.1              | 1.5.4           | 2015.5.3 |
| Third Party Module Easy of Use                      | High   | High                | Medium          | Low      |
| Official Sensu Support for the Tool                 | High   | High                | Low             | Low      |
| Reproducibility                                     | High   | High                | High            | High     |
| Easy of use getting started                         | Medium | Medium              | High            | Medium   |
| Language extensibility                              | High   | High                | Low             | Low      |
| Separation between config data and code             | Hiera  | Databags/Attributes | just variables? | Pillar   |
| Module re-usability?                                | High   | High                | Low             | Low      |
| **Review of the Sensu Module/Cookbook/Etc**         |        |                     |                 |          |
| Version of the module Used                          | 1.5.5  | 2.10.0              | 0.1.0           | c6324b3  |
| Sensu Module Feature Completeness                   | High   | High                | Medium          | Medium   |
| Sensu Module Integration with Other Modules         | Low    | Extreme?            | None            | None     |
| Sensu Module Flexibility                            | High   | High                | Medium          | Low      |
| Sensu Module Re-usability                           | High   | High                | High            | Low      |
| How Opinionated Was It?                             | Low    | High                | Low             | Medium   |
| Usability with Sensu's Embedded Ruby                | Yes    | Yes                 | Not natively    | Sorta    |

## Conclusion

The way I see it, there are two camps. Chef and Puppet both provide a rich
language to build modules with. For example, the [PuppetLabs RabbitMQ module](https://forge.puppetlabs.com/puppetlabs/rabbitmq) contains all the code
to interact with RabbitMQ. The main Puppet codebase doesn't know anything about
RabbitMQ. The same goes for Chef. Both Chef and Puppet also have their own DSL.
Puppet uses yaml files for Hiera, but they are for config only, unlike
Ansible/Salt.

In the other camp is Ansible and Salt. They have a simplified config language,
and require the help from the core software to do the "heavy lifting" of the
raw types. For example, the Salt [RabbitMQ formula](https://github.com/saltstack-formulas/rabbitmq-formula/blob/master/rabbitmq/config.sls#L29)
requires the help of [core Salt RabbitMQ module](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.rabbitmq.html)
to provide the primitives.

### Final Thoughts

* Puppet
  * Directed graph dependency ordering, not parse-order driven
  * Type/Provider system and defined types provide the right abstraction layers to build upon.
  * Hiera provides a good separation of config/code, making it easier to reuse modules without modification.
  * Strong culture of testing
  * Lots of good supported modules
  * High deployment overhead and language learning curve
* Chef
  * LWRP system provides the right abstraction layers to build upon.
  * Knife tool does do a lot of cool stuff
  * Lots of good supported cookbooks
  * Strong culture of testing
  * "Just ruby"
  * 15 levels of attribute precedence is insane
* Ansible
  * Low deployment overhead and low learning curve
  * "Just yaml files"
  * Lack of type/providers means that playbooks use "apt" and "yum" directly, which kinda sucks
* Salt
  * Pillar provides a nice separation of config/code, which is good for formula-reuse, if the formula is pillar-aware
  * Centralized formulas emphasize consolidated development effort
  * No strong state testing emphasis or framework
  
## Going Further

If you want to know more about Sensu, of course you can take my training course:

* [Sensu-Introduction](https://www.udemy.com/sensu-introduction/) (Free)
* [Sensu-Intermediate](https://www.udemy.com/sensu-intermediate/?couponCode=xkyle) (50% off, $50)

Or you can tell me I'm wrong. You can raise and
[issue](https://github.com/solarkennedy/xkyle.com/issues/new) or make a
[pull-request](https://github.com/solarkennedy/xkyle.com/pulls) for the blog
post or investigate my actual training material and code on
[Github](https://github.com/solarkennedy/sensu-training/tree/master/intermediate/lectures).
