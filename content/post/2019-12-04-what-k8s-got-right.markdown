---
categories: null
comments: true
date: 2019-12-04
published: true
title: "What Kubernetes Got Right, and Mesos Got Wrong"
---

{{< figure src="/uploads/distributed-systems-management/type3.png" >}}

I've worked at Yelp for about six years, working with our container platform in production for about four of those years.
The plaform is called "PaaSTA" and there are a number of public talks about it. It is also [open source](https://github.com/Yelp/paasta).
When we started PaaSTA, it ran on Mesos, and now we are most of the way through our migration to use Kubernetes (k8s).
I'm in a relatively unique position to have production experience with both technologies.
This blog post will have some personal opinions on both platforms, which derive from experience, and also just thinking about the two a lot.

This post is not some sort of feature comparison.
If you are actually evaluating these schedulers, I recommend reading more about the actual technical differences between the two systems, like [this comparison](https://www.stratoscale.com/blog/kubernetes/kubernetes-vs-mesos-architects-perspective/) and [this one](https://platform9.com/blog/kubernetes-vs-mesos-marathon/).
My blog post, however, is not supposed to "inform" you about the differences between Mesos and k8s, it is "persuade" you to use and adopt the same principles that k8s uses, instead of the Mesos "approach" (where approach here is a combination of community, timing, and lots of tiny decisions along the way).

## Mesos vs k8s: I'm not actually not that interested in the Community Support

"Community" is often cited as an important reason for picking a particular technology.
You want to pick the winning horse! 12,000 Kubecon attendees can't be wrong!

In this case, I'm not suggesting that this is something that Mesos got wrong and k8s got right.
I think they both got it right.
My point here is that I don't want you to judge the technical book here by its community cover. You know what has a huge community of users: Microsoft Windows, Openstack, and JQuery.  

It is true that with a large community of users, new feature are developed, bugs get squashed, etc.
But equally, a project can make a turn into a direction that is not useful for your organization, or its leadership can get diluted with committees, etc.

Sorry for the mini rant before we actually get started.

## Mesos vs k8s: The failure of the two-layer scheduler model

I remember being at Mesoscon 2015 and being excited at the handful of new frameworks coming to Mesos, and being enamoured with its [two-level](https://stackoverflow.com/questions/47779352/what-are-the-advantages-and-disadvantages-of-two-level-scheduler-like-in-apache) scheduling model.

"What a great design", "such great separation of concerns", were thoughts I had at the time.
I even felt a tinge of smugness. It kinda felt like when I first understood the "reversed" server/client model of [X](https://en.wikipedia.org/wiki/X_Window_System#Client%E2%80%93server_separation).

But why do I consider this model a failure?

The limitations of this model become apparent when you need to do something like:

> [A "\*" Constraint for unique should exist](https://github.com/mesosphere/marathon/issues/846)

This is the Mesos equivilant to a [k8s DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

But this is not possible on Mesos:

> We can't ensure that a task is running on all slaves in the cluster for following reasons:
>
>  * we can't guarantee that there are enough resources on every machine
>  * in a multi framework cluster, we don't know if we will ever receive offers for all the machines
>  * we could never tell if it has been deployed successfully, because we don't know about all the machines in the cluster
>
> I think this would need direct support from Mesos.

It just isn't possible is Mesos, and will never be. Why? Because the two-layer scheduler model means that schedulers on Mesos *are not supposed to know* about the nodes that are out there. Separation of concerns of course.

In k8s, all the schedulers / operators / controllers can see the entire state of the world. They have unrestricted access and are expected to play nice together. This blurring of concerns allows k8s to have much more rich capabilties, like DaemonSets, StatefulSets, etc.
This is only possible because of this blurring of layers, and is one thing that k8s got right that Mesos got wrong.

## Mesos vs k8s: Client Libraries

What is the official Mesos Client Library
? [libmesos](http://mesos.apache.org/documentation/latest/api-client-libraries/), as c++ .so file. There is also an officially supported Java wrapper around libmesos. Everything else is community-contributed. That means >3 golang libraries, >2 python libraries, and at least one Scala one.

For k8s? [Official](https://kubernetes.io/docs/reference/using-api/client-libraries/) libraries for Go, Python, Java, dotnet, JavaScript and Haskell. Sure, they are leveraging the fact that they have OpenAPI specs. There are even more user-contributed ones, but honestly I'm not really sure why they exist.

Mesos never really got this right. Writing ***good*** Mesos frameworks was always hard, and continued to be hard because the API and associated client libraries were never great. K8s gets this right by having a solid api ***and*** having solid, official, and up-to-date client library languages for the most popular languages in the industry.

Client libraries should not be left to the community. It create fragmentation and raises the barrier to entry when it comes to integration with your thing. k8s realises the power of good apis and good client libraries, it got this right when Mesos only ever supported libmesos, and the Mesos framework explosion never happened.

## Mesos vs k8s: Providing the Kernel Versus Providing the Distro

Mesos was always touted as "the kernel of the datacenter". It is true, in the same sense that the Linux kernel does process scheduling, so does Mesos. Linux was successful in the industry, why not Mesos?

But wait. In a different sense, "Linux" isn't successful per-se, but Android is. RedHat is. Ubuntu is. These are Linux distros. Linux (a kernel) by itself is almost useless!

K8s did this right by providing a Distro, which was useful to real end users. This "distro" provided:

* A kernel (the k8s scheduler, not the Mesos scheduler)
* A solution for daemons
* A solution for stateful processes
* A way to run cron jobs as well as long-running services
* Service discovery and routing
* Secret handling
* And much much more

[DC/OS](https://dcos.io/) is the only Mesos distro I'm aware of. Why didn't it take off? My best guess is that it was too targeted towards Enterprise customers first. There was never "DC/OS: The Hard Way". Mesosphere's Marathon did get some advanced features, but there was never a great way to provide these kind of useful primitives (load balancing, scheduled jobs, secrets) to be useful to other frameworks too.

What k8s got right was providing a lot of services you need to get going, even if they are simple implementations of them, and made all those services available to every other k8s'y thing via a common API. Everything on k8s could assume there was an etcd cluster available, that there was load balancing and services, and secret handling. On Mesos, no such assumptions were safe.

## Mesos vs k8s: Mesos Framework Libraries versus Operator SDKs

This is sorta like the client libraries issue, but at the next level. How does one write automation integration with Mesos? You go through the difficult task of writing a framework. Sure it may take seconds to get something running, but it will take a long time before the operator is production ready. Writing a good Mesos Framework isn't easy.

The [DC/OS Commons](https://mesosphere.github.io/dcos-commons/) as the closest thing to a good Mesos Framework SDK. It also never really took off.

## Conclusion

When this blog post is titled "what k8s does 'right'", you should ask, "right for who?". The answer to me is, right for most infrastructure engineers want a platform to run all their different workloads on. *Not* a distributed systems SDK (Mesos).

The next thing you should ask is: "Isn't this an unfair comparison? K8s is more like DC/OS, Mesos is more like the k8s-scheduler component." To which I say: Kinda. I think it is more like Mesos is k8s just without the replica-set/deployment controllers and good API (those were left to frameworks like Marathon to implement). But sure, it isn't fair.

In a sense, Mesos is a tool that does "one thing well. In the right circumstance, it can be the right tool for the job.

Kubernetes do one thing well, it does a lot of stuff "ok", but leaves room for infrastructure engineers to replace parts and integrate. It also met developers where they are at, by giving them good client libraries in their native language, primitives to build operators on, and lots of the "things you just need to get going" (secrets, service discovery, etc) to make things work.
