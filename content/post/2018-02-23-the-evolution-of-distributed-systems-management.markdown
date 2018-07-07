---
categories: null
comments: true
date: 2018-02-23T07:48:18Z
published: true
title: The Evolution of Distributed Systems Management
---

Let's survey the past and present of how we manage distributed systems, and
then maybe try to predict the future.

For this survey I'll look at a few open-source technologies to give concrete
examples (in [Kardashev style](https://en.wikipedia.org/wiki/Kardashev_scale).

* [Type 0: Manually Deployed and Configured](#type-0-manually-deployed-and-configured)
* [Type 1: Host-Centric Configuration Management](#type-1-host-centric-configuration-management)
* [Type 2A: Infrastructure-scoped Orchestration Tooling](#type-2a-infrastructure-scoped-orchestration-tooling)
* [Type 2B: Application-specific Orchestration Tooling](#type-2b-application-specific-orchestration-tooling)
* [Type 3: Compute-Platform-Native Application-Specific Frameworks](#type-3-compute-platform-native-application-specific-frameworks)
* * [Type 3A: Mesos Frameworks](#type-3a-mesos-frameworks)
* * [Type 3B: Kubernetes (k8s) Operators](#type-3b-kubernetes-k8s-operators)
* [Type 4: Hybrid?](#type-4-hybrid)

## Type 0: Manually Deployed and Configured

{{< figure src="/uploads/distributed-systems-management/mysql-manual.png" >}}

MySQL is a great example of a distributed system (when setup in Master/Slave
configuration) that is designed to be installed and configured by humans. The
configuration files are human-friendly ini-style. The runtime orchestration is
established via commands (statements) in the MySQL shell.

This doesn't mean that the software *can't* be automated. I'll discuss what
MySQL looks like when it is automated at different levels further down in the
blog post. I might call the "scripting" of MySQL orchestration "Type 0.5"-style
orchestration. There are a
[few](https://github.com/thomasvs/mysql-replication-start/blob/master/mysql-replication-start.sh)
[examples](http://blog.ditullio.fr/2016/04/30/initialize-mysql-master-slave-replication-script/)
of what this looks like.

There isn't much to say about Type 0 automation. It is characterized by the
**lack** of built-in automation facilities and cumbersome/brittle
integrations with external automation systems.

Other systems that are designed to be manually deployed and configured by humans
(links to documentation representative of manual configuration):

* Classic network switches [(Cisco IOS)](https://www.cisco.com/c/en/us/td/docs/ios/12_2/ip/configuration/guide/fipr_c/1cfrip.html#wp1001030)
* [Classic Redis](https://www.digitalocean.com/community/tutorials/how-to-configure-redis-replication-on-ubuntu-16-04)
* [Zookeeper](https://zookeeper.apache.org/doc/r3.1.2/zookeeperStarted.html)

It starts getting interesting when engineers take these systems and build
orchestration tooling around them. I predict that we'll continue to see more
and more systems being build with automation in mind from the start, leading to
very different interface and configuration design decisions.

## Type 1: Host-Centric Configuration Management

{{< figure src="/uploads/distributed-systems-management/type1.png" >}}

I characterize "Type 1" distributed systems management as an
application-agnostic system that is "host-centric." These tools can "configure
anything" and runs "on a host". One might call these "classic configuration
management tools." Tools like:

* Puppet
* Chef
* Ansible
* Salt

These tools do have the flexibility to be extended to support different
applications, but lack the ability to orchestrate an action "across a cluster"
in a good way. Here are some examples of this:

* [Using Puppet to setup MySQL replication "mostly"](http://txt.fliglio.com/2015/12/mysql-replication-with-puppet/)
* [Ansible native Redis configuration using static master/slave ip addresses](http://docs.ansible.com/ansible/latest/redis_module.html)
* [Etcd Chef Cookbook that runs on hosts, but must use external state (etcd/dns/ec2 tags) to coordinate the bootstrap process](https://github.com/rapid7/chef-etcd#using-the-aws-discovery-method)
* [Kubernetes module that uses 'puppet tasks' to do adhoc orchistration](https://forge.puppet.com/autostructure/kubernetes/tasks#task_kubeadm_join)

These types of tools are very mature now, but they still operate at the "host"
level and don't really have the capability to do "cluster-wide" operations like
"promote a new mysql master" or "replace a cassandra node". They mostly assume
that the host in question already exists, and leave the provisioning and
de-provisioning of servers up to another tool (knife, etc).

I predict that Type 1 tools will continue to lose relevance in a world where
Type 3 tools exist, and as the industry as a whole learns to look beyond "the
single node".

## Type 2A: Infrastructure-scoped Orchestration Tooling

{{< figure src="/uploads/distributed-systems-management/type2a.png" >}}

Type 2A distributed system management tools can operate beyond a single node,
but are still general-purpose tools that have the capability to be extended to
support a variety of distributed systems. This usually involves some sort of
domain specific language (DSL).

Here are some examples:

* [Hashicorp Terraform](https://www.terraform.io/)
* [CloudFormation](https://aws.amazon.com/cloudformation/)
* [OpenStack Heat](https://docs.openstack.org/heat/latest/)
* [Bosh](https://bosh.io/)
* [Cloudify](https://docs.cloudify.co/4.2.0/intro/what-is-cloudify/)
* [SparkleFormation](http://www.sparkleformation.io/)

They key attribute to these tools is their tight integration with the
underlying infrastructure APIs. This makes them well suited for general purpose
infrastructure as well as deploying distributed systems.

Because they lack tight cohesion with the actual distributed systems they might
be deploying, really advanced distributed system orchestration is not really
possible. Here are some examples:

* [Deploying Etcd clusters on Terraform](http://maxenglander.com/2015/06/09/etcd-clusters-with-terraform.html) is straightforward, but scaling them is awkward
* [A Zookeeper cluster deployed via Cloudformation](https://github.com/mbabineau/cloudformation-zookeeper) still requires another tool (Exhibitor) to manage Zookeeper itself
* [There is no such thing as CloudFormation Modules](https://forums.aws.amazon.com/thread.jspa?threadID=223736) (not a very good example)

A reader might be wondering why I would even expect such tools to have such
functionality. After all, these Type 2A tools are "infrastructure oriented",
not "distributed-systems oriented." But if Type 2A tools are not quite
sufficient for fully managing distributed systems for us, then what is?

## Type 2B: Application-specific Orchestration Tooling

{{< figure src="/uploads/distributed-systems-management/type2b.png" >}}

Type 2B Tools are the counterparts of 2A. They are very "application-aware" and
are not general purpose infrastructure tools. They rarely have the ability to
launch raw infrastructure themselves, and often still require "Type 1" tools to
get them going.

Here are some examples:

* MySQL via Youtube's [Vitess](http://vitess.io/)
* MySQL via Github's [Orchestrator](https://github.com/github/orchestrator)
* CloudFoundary via Pivotal's [cf-deployment](https://github.com/cloudfoundry/cf-deployment)
* Spinaker via [Halyard](https://github.com/spinnaker/halyard#halyard)
* Cassandra via [Netflix's Priam](https://github.com/Netflix/Priam)
* Cassandra (DataStax Enterprise) via [DataStax OpsCenter](https://docs.datastax.com/en/latest-opsc/index.html)
* Redis via [Redis-Sentinel](https://redis.io/topics/sentinel)

The nice thing about this class of tools is how "smart" they are about the
application they are managing. Sometimes they are even written by the same
entity that creates the distributed system it manages.

Some of them run continuously, supervising the distributed system in a tight
reconciliation loop. Contrast this to Type 2A tools, which do not operate like
this and usually run in a "one-shot" fashion.

I predict this class of tooling will remain relevant to orchestrate the current
generation of distributed systems in a platform-agnostic way, but eventually
will give way to Type 3 tools.

## Type 3: Compute-Platform-Native Application-Specific Frameworks

{{< figure src="/uploads/distributed-systems-management/type3.png" >}}

Type 3 tools are Application-specific, like 2B. But they sorta look like type
2A tools because they are empowered to launch and destroy actual
"infrastructure" (docker containers). This is because they are built upon a
different class of infrastructure abstraction that is currently being met in
the industry by a small subset of tools, namely Mesos and Kubernetes (k8s).

Another distinguishing feature of Type 3 tools is that they must **run
continously**. They must run continuously supervise the distributed-system
itself. The tool must be able to respond to changes in health state. They often
have ways of orchestrating changes across the cluster (like upgrades).

Unlike many other classes of tools, Type 3 tools are tightly coupled to either
Mesos **or** k8s. I have yet to see a "platform-agnostic" tool that can be a Mesos
framework **and** k8s operator (contrast to Type 2A tools that often have
multiple "providers" for deploying to different "clouds").

I think this is likely the case for a few reasons:

* These types of tools are very new
* While there is no "native" language for either Mesos or k8s, the large
  production Mesos frameworks are Java/Scala and most k8s operators are in
  golang.
* The Mesos/k8s "apis" and primitives are very different, unlike the "compute
  instance" primitives that AWS and GCE provide, making it difficult to build a
  common tool.
* In order to write a Mesos Framework or k8s operator, you need to be an expert
  in Mesos/k8s **and** fully understand how to manage the distributed system
  the framework/operator is trying to run. This is unlike Type 1 (config
  management) tools, where you only need to know a little bit of puppet to
  write a puppet module. The barrier to entry is higher.

They are so different that I'm going to split them up and talk about them
(Mesos/k8s) separately. Time will tell if there is room in the industry to have
Mesos and k8s **and** any more than that. I predict that the difficulty in
building high-quality Type 3 (Application-specific orchestrators) is so high
that we **won't** splinter into many community-provided modules like we've seen in
Type 1 (classic configuration management) tools where everyone makes their own
"Apache" module.

### Type 3A: Mesos Frameworks

[Mesos Frameworks](http://mesos.apache.org/documentation/latest/frameworks/)
are application-specific distributed-systems orchestration tools. While they
are "easy to write in any language", they are hard to write **well**, and only a
few dozen open-source production-ready frameworks exist. Here is the
[list](https://gist.github.com/solarkennedy/b60cb708c9ffbffe000530f4428bfa4a)
of those that are available on the
[DC/OS Universe](https://universe.dcos.io/#/packages) (note: many of the packages
on the DC/OS Universe are standalone applications that run on Marathon and are
not Mesos Frameworks, and don't need to be).

DC/OS created by Mesosphere, is kinda like a "Mesos Distribution" which
includes Mesos, a fancy installer, a basic process runner (Marathon) and a
package manager, akin to a Linux distribution.

Mesos is sometimes described as "a distributed systems kernel". I like this
description, although it is sometimes hard for new users to wrap their head
around it. It does give Mesos framework authors some of the lowest-level primitives
needed to write a distributed system. Things a framework can/must do are:

* Accept offers from Mesos and launch a task
* Kill tasks
* Respond to status updates from Mesos regarding existing tasks

Additionally DC/OS gives frameworks additional facilities:

* Service discovery (via Mesos DNS)
* Config state storage (via Zookeeper)
* Secret management (via the DC/OS Secret API)
* Framework process supervision (via Marathon)

Only the Mesos users with large engineering organizations can devote effort
into developing custom Mesos frameworks. Here are some examples (none of which
are currently open source):

* Netflix's [Titus](https://medium.com/netflix-techblog/the-evolution-of-container-usage-at-netflix-3abfc096781b)
* Uber's [Peleton](https://www.youtube.com/watch?v=Ktc3GjshHcc)
* Apple's [JARVIS](https://www.infoq.com/news/2015/05/mesos-powers-apple-siri)
* Yelp's [Seagull](https://engineeringblog.yelp.com/2017/04/how-yelp-runs-millions-of-tests-every-day.html)

But most companies should not need to build their own bespoke Mesos
frameworks. Do most companies need Type 3 tools at all?

They do, because most companies **do** run *open-source* distributed systems,
but often lack the advanced automation to orchestrate them. The current status
quo is that only experts in those distributed systems handle the orchestration
of them. Without advanced orchestration, risky MySQL maneuvers are left up to a
DBA. Cassandra maintenance needs to be done "very carefully". You basically
don't change a Zookeeper topology once it is up.

The space of Type 3A tools for open-source distributed-systems just starting.
Here are a few examples:

* [Cassandra on Mesos](https://github.com/mesosphere/cassandra-mesos-deprecated) (Deprecated)
* [Apache Cotton (MySQL on Mesos](http://incubator.apache.org/projects/cotton.html) (Retied)
* [Kafka on Mesos](https://github.com/mesos/kafka)
* [Elasticsearch on Mesos](https://github.com/mesos/elasticsearch)

But active development is mostly on the
[dcos-commons versions of these frameworks](https://github.com/mesosphere/dcos-commons/tree/master/frameworks).
Why? I think it is because of the difficulty of writing high-quality
production-ready Mesos frameworks. Mesosphere (the company behind DC/OS)
notices this, and has a financial incentive to build these high-quality
frameworks. Therefore, they build up a toolkit (the dcos-commons library) and
do it themselves.

I do think we are in the right space (Type 3) for these problems to be solved.
I (personally) think the abstractions that Mesos provides are quite enough to
build "rich" distributed systems. I also think that the Mesos
[Offer Model](http://mesos.apache.org/documentation/latest/architecture/) is a bit
awkward to use (but that is maybe for another blog post).

My prediction is that Mesosphere will end up writing the majority of the
production-ready frameworks. I think this will lead to the authors of the
open-source distributed-systems to not "Own" the framework itself. I think
ideally the Kafka community (or Confluent) should build and maintain the
framework that manages Kafka. I think ideally the Cassandra community (or
Datastax) should build and maintain the Cassandra framework. I really do think
that these frameworks work best when they are built and designed by the same
authors of the distributed-system itself. I predict this situation will lead to
substandard user experience, which will push users to Type 3B...

### Type 3B: Kubernetes (k8s) Operators

Kubernetes Operators are similar to Mesos Frameworks. They also run
continuously and are application-specific. They know how to handle upgrades or
recover from failures. They run in a tight reconciliation loop, always trying
to keep a system healthy.

Here are some examples:

* [Etcd Operator](https://coreos.com/blog/introducing-the-etcd-operator.html)
* [Elasticsearch Operator](https://github.com/upmc-enterprises/elasticsearch-operator)
* [Postgres Operator](http://info.crunchydata.com/blog/postgres-operator-for-kubernetes)
* There are a [dozen or so notable ones](https://github.com/ramitsurana/awesome-kubernetes#operators)

There are far fewer k8s operators than Mesos frameworks today. I believe that is
the case today because Mesos has headstart of a few years, and k8s
[Custom Resource Definitions](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.9/#customresourcedefinition-v1beta1-apiextensions)
(one of the better core primitives in k8s to create operators) is still in beta.
I think Custom Resource Definitions (CRDs) are going to be the best way that
users will interact with custom k8s operators.

What is the difference between a k8s operator and a Mesos framework? Let's
start with what k8s offers as a platform to operator-writers:

* You get your own custom namespaced REST endpoint in the k8s api (by applying
  a yaml file, no rebuild of k8s required), hosted by the k8s api server itself
* Users of operators treat custom objects just like any other object in k8s;
  launching a new "database" has the same workflow as launching a "pod" (via
  kubectl create)
* Operators (using golang) get nice boilerplate
  [client code](https://github.com/kubernetes/client-go) to be able to sync and cache
  etcd state and batch up calls to the k8s api (similar to Mesos' task
  reconciliation behavior)

The surface area of what you have to write for a k8s operator is much smaller
than a Mesos framework. Additionally, users who use the k8s operator "feel"
like they are "just interacting with k8s", because in a sense they are! The k8s
operator is just responding to etcd events and posting back to the k8s api in a
particular way. I think the model is better for both k8s operator writers and
users. Combine this with helm charts and I think you have a very good starting
point for building a powerful platform for managing and orchestrating
distributed systems.

I predict a few things will happen in the next 5 years:

* k8s will become the dominant infrastructure toolkit/framework/thingy
* k8s operators, using CRDs, will be written, and eventually be "first party"
  platforms for complex distributed systems (the same community that develops
  the distributed system will also develop the k8s operator to go with it)
* The k8s configuration "language" (via CRDs) will be a kind of lingua franca of the
  infrastructure world

## Type 4: Hybrid?

As an industry I think we are still in Type 3 automation land. I think the next
incremental improvement on this type of automation will look like a hybrid of
Type 3 (Mesos frameworks / k8s operators) and Type 2A (Terraform,
Cloudformation, etc).

Currently, Type 3 tooling is only able to use the compute resources given to
it, or maybe an external autoscaler can watch the cluster as a whole and scale
up and down. At the risk of separation-of-concerns-blasphemy, I think the next
level of distributed-systems automation will be able to launch and terminate
its **own** raw compute resources. I would like my
[Tensorflow k8s operator](https://github.com/kubeflow/tf-operator)
to launch GPU instances if it needs to. I would like my
[HDFS operator](https://github.com/apache-spark-on-k8s/kubernetes-HDFS) to launch its
own data nodes directly. I would like k8s itself to turn off nodes that it doesn't need.

Past that, I don't have an imagination good enough to imagine what might be beyond.

[Email me](mailto:kyle@xkyle.com) or make a
[pull request](https://github.com/solarkennedy/xkyle.com) if you have comments or corrections.
