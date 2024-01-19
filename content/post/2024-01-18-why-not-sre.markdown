---
title: "Why I'm Not an SRE"
date: 2024-01-18T00:00:00-00:00
---

SRE (Site Reliability Engineer) as coined by Google in 2003, came into prominence in 2016 with the release of ["The SRE Book"](https://sre.google/books/).
It defines a particular job in an engineering org.
This job is mostly focused on of course, reliability, but also performance, observability/monitoring, code deployment, capacity planning, and many other adjacent activities.

Some people say SRE is Google's "version of DevOps" (aka a "DevOps implementation").
This is a little tricky to talk about, because [DevOps](https://en.wikipedia.org/wiki/DevOps), started as a rallying cry for shortening deployment times and adding more automation in the SDLC, has turned into a role itself.
There are lots of job openings for "Devops Engineer", and engineers really identify that term, some calling themselves "a devop".

While I don't like the "devop" term, for the purpose of this blog post, SRE as an implementation of the DevOps philosophy is close enough.

## The Stories We Tell Ourselves

Our jobs titles can strongly influence our personal identities.
Think of your job title as a [mini prompt](https://www.xkyle.com/We-Software-Engineers-Are-All-Already-Prompt-Engineers/) fed to your own personal neural network, like:

> I'm a good SRE.
> I build reliable systems.
> I'm good enough, I'm smart enough, and doggone it, people like me.

## Why I Don't Like SRE

To me, reliability has never been the top priority for most of the systems I've managed.
It just hasn't.
Certainly reliability is one important aspect of a good system, but only to a degree.

For any individual job, there may be a time that reliability is job 1, but other times it might be performance, or cost efficiency.
There are lots of tradeoffs to be made like:

* For security, we need all logins to funnel through this central server
* For efficiency, we need to run in 2 availability zones instead of 3.
* For performance, we need to run the database as a singleton instead of being distributed.

I just don't want to be boxed in, as simple as that.
For that reason, I don't identify as an SRE, and I just stick to "engineer" (luckily not a protected title in the US).
That way I don't let a reliability bias hold me back from making hard tradeoffs when the time comes.
