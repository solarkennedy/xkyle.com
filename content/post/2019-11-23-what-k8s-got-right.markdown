---
categories: null
comments: true
date: 2019-12-23
published: false
title: "What Kubernetes Got Right, and Mesos Got Wrong"
---

I've worked at Yelp for about six years, and working with our Mesos-based container platform in production for about four of those years.
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

The limit
