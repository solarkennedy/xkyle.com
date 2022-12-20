---
slug: "A Fundamental Theory of Platforms: Part 1"
title: "A Fundamental Theory of Platforms: Part 1"
date: 2022-12-01T00:00:00-00:00
---

> Note: This is Part 1 on Platform Engineering theory.
> Skip to [Part 2]({{< ref "2022-12-02-platform-abstraction-practice" >}}) if you are more interested in the practical aspects.

Platform Engineering is the new hotness for 2022.
I've been working with [Aaron Blohowiak](https://www.linkedin.com/in/aaronblohowiak) (Netflix) and [Scott Triglia](https://twitter.com/scott_triglia) (Stripe) to think about platforms generally, trying to come up with a model to understand how their lifecycle, and what makes them _good_.
We've tried to use our past industry experience (good and bad), combined with external examples of platforms, to come up with some general rules about how they evolve over time.
In this blog post I'll present the theory, and see how it aligns with some industry examples.

Before we jump into theory, how did we get here?
I would argue a quick timeline looks like this:

- 2011: [Cloud Foundry](https://en.wikipedia.org/wiki/Cloud_Foundry) is publicly announced, likely the first large open source "platform"
- 2015: Google Borg paper [published](https://research.google/pubs/pub43438/), revealing some of the inner architecture of Google's internal platform
- 2015: [Kubernetes 1.0](https://cloudplatform.googleblog.com/2015/07/Kubernetes-V1-Released.html) is released, giving platform engineers everywhere a large toolkit
- 2016: I present ["A Theory of PaaSes"](https://www.youtube.com/watch?v=YFDwdRVTg4g&t=1991s) at Box Inc
- 2019: "Platform Team" examined and refined by the [_Team Topologies_](https://teamtopologies.com/) book
- 2021: [platformengineering.org](https://platformengineering.org/) is established, complete with [swag](https://platformengineering.org/store)
- 2022: Gartner [blogs](https://www.gartner.com/en/articles/what-is-platform-engineering) about the trend
- 2026 (Gartner prediction): "80% of software engineering organizations will establish platform teams as internal providers of reusable services, components and tools for application delivery"

Charity Majors [blogged](https://www.honeycomb.io/blog/future-ops-platform-engineering) about Platform Engineering and made a [handy chart](https://www.honeycomb.io/blog/future-ops-platform-engineering#platform_engineers_vs_devops_engineers) to compare the differences between "Platform Engineer" and "DevOps Engineer".
Of course there is more than the binary, and in this blog post I'll explore the nuance of what platforms are, through a few difference lenses.

But what are we talking about here, really, when we talk about "Platforms"?
What are "Platform Engineering" teams doing, actually?
What counts as a "Platform" anyway?

## What is a Platform?

[Platformengineering.org says](https://platformengineering.org/blog/what-is-platform-engineering):

> Platform engineering is the discipline of designing and building toolchains and workflows that enable self-service capabilities for software engineering organizations in the cloud-native era.
> Platform engineers provide an integrated product most often referred to as an “Internal Developer Platform” covering the operational necessities of the entire lifecycle of an application.

This definition works for me, but doesn't exactly say what the workflows should look like, or how self-service it should be, or how integrated the product is.
It also doesn't give any advice as to how much of the "operational necessities" should be covered.

### "Platform Engineering" Vs "DevOps"

Platform engineering is a cultural response to DevOps.
I imagine the conversation went like this:

- **Ops**: We are disbanding. Developers will now own what they build. Here are all the "DevOps" tools you need.
- **Devs**: We'll I guess some of us will call ourselves "DevOps" too for some reason
- **DevOps**: This sucks.
- **Ops**: Fine. We'll rebrand as "Platform Engineering" and build something easier for you to use.
- **Devs**: Ok. I hope the platform sucks less.

But there is a big difference.
Previously Ops/Devops built things _for themselves_.
In this new world, they are building things (the platform) _for internal developers_.

But what should they build?

## A Fundamental Theorem of Platforms

For internal platforms, you can be much less polished than an industry product offering.
This is both an advantage and sometimes leads to long term disdain of internal platforms.

But it also means, for an internal platform, your fundamental goal is to _provide business value_, and it doesn't necessarily need to be something that would sell on the open market.

Therefore, here is what I've got for a Fundamental Theory of (internal) Platforms:

> One should be build an _internal platform_ to solve **real business needs**, starting with the following properties:
>
> - As high-level of an abstraction as possible, evolving to later provide lower-levels as well
> - As opinionated as possible to start, evolving to more flexibility with _other_ offerings
> - As little self-service as possible, evolving to more self-service
> - As multi-tenant as possible, evolving to (more expensive) isolated environments as the business requires it

This theory is more like the [Fundamental Theorem of Poker](https://en.wikipedia.org/wiki/Fundamental_theorem_of_poker), where:

> The fundamental theorem of poker is simply expressed and appears axiomatic, yet its proper application to the countless varieties of circumstances that a poker player may face requires a great deal of knowledge, skill, and experience.

This theory gives guidance about how to start, and gives one a vision for how to evolve in the future.
A key postulate here is that you are a business, and that the platform _will_ evolve over years.

The theory also defines a few qualities about a platform we need to explore:

- Self-service (aka Agency)
- Abstraction
- Opinionatedness (aka Flexibility)
- Multi-tenancy/Isolation (aka Tenancy)

Let's look at examples of platforms in the industry in some of these dimensions and see if/how the theory applies.

## Abstraction vs Flexibility

**Flexibility** is how un-opinionated a platform is with regards to how it is used.
Flexibility isn't always a good thing.
Being too flexible can lead to an explosion of even more flexibility, and before you know it you have an untenable mess.
Read more about the spectrum of Opinionated vs Flexibility [here](https://components.guide/composable-systems/opinionated-vs-flexible).

Flexibility Extremes:

- Extremely _Flexible_: AWS [Lambda](https://aws.amazon.com/lambda/)
- Extremely _Opinionated_: Heroku's [Twelve-Factor App](https://12factor.net/)

**Abstraction** is a measure of how far removed the user of a platform is from the details underlying its implementation.
Another way to see it is how close the platform is to the domain of the problem it is attempting to address.
It is hard to find a word in english that represents the opposite of abstraction, in the way it is used in this context.
I appreciate this [visual analogy](https://stackoverflow.com/questions/19291776/whats-the-difference-between-abstraction-and-generalization/19464520#19464520).
For the purposes of this blog post, we'll stick to a spectrum of _low_ to _high_.

Abstraction Extremes:

- Extremely _low_ level of abstraction: Fly.io's [Machines](https://fly.io/docs/reference/machines/), AWS's EC2 [Instances](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_RunInstances.html)
- Extremely _high_ level of abstraction: Edgio [Sites](https://edg.io/app/sites/), Cloudflare [Workers](https://workers.cloudflare.com/)

Read more in [Part 2]({{< ref "2022-12-02-platform-abstraction-practice" >}}) with some practical advice on how flexible or abstract you should be in practice.

### Analysis

Here is an analysis with some subjective opinions on where a few public platforms fall on these axes:

[![Analysis Chart](/uploads/A-Fundamental-Theory-of-Platforms-Part-1/A-Theory-of-Platforms-Abstraction-Flexibility.svg)](/uploads/A-Fundamental-Theory-of-Platforms-Part-1/A-Theory-of-Platforms-Abstraction-Flexibility.svg)

Some observations:

- Things that start Opinionated, eventually become more flexible (Heroku, Lambda)
- Things never get less flexible
- Higher level abstractions, if they meet customer needs, usually can provide more business value
- Individual products don't (shouldn't) move up and down the abstraction axis, instead they make new products

#### Abstraction & Flexibility in the Fundamental Theorem

The Fundamental Theorem says to start as high as possible on the ladder of abstraction, and be as opinionated (inflexible!) as possible. But why?

For abstraction, it may be hard to know just how high or low to go, but the right answer always is a function of your business needs.

What you should _never_ do is swing all the way and go 100% flexibility.
Examples of this in the industry might be providing k8s clusters to your developers.
I'll go ahead and say it, this is _never_ a good idea.
But why?
Why is providing a super flexible platform not a good idea?

- Building a very flexible platform makes it harder for you to evolve the platform.
  At an extreme, providing k8s clusters to your developers risks them depending on the exact version of k8s installed!
  (See [Hyrum's Law](https://www.hyrumslaw.com/))
- Building a very flexible platform is wasteful to the business.
  Almost by design, that flexible nature puts some burden on the user to figure out how to "flex" it to do what they actually need to do!
- Being super flexible cannot be undone.
  Once you provide a particularly flexible capability, its use will proliferate, and you will not be able to take it back.

So what should you do when you build something that is opinionated, but then realize it isn't flexible enough?
Read more about your options in [Part 2]({{< ref "2022-12-02-platform-abstraction-practice" >}}).

#### What about Pierceable Abstractions?

In this [blog post](https://lethain.com/pierceable-abstractions/), Will Larson presents "Pierceable Abstractions", suggesting that one builds platforms in layers.

My main two objections to this blog post are:

1. The right move for the business is to start high on the abstraction ladder first, and then expand to provide lower layers _maybe_.
   It is only an accident that most "devops" teams start low and go up.
   Ideally for the business, you should start with the layer that gets the best ROI, and that usually is the highest layer.
2. "Pierceable" is not really the right word.
   In the blog post, it really implies that having the option to pick a lower layer is the key to providing for the other 10% of your customers.
   Per the fundamental theory, one should address this 10% as late in the game as possible

Don't build literally pierceable abstractions.
Build separate offerings for different levels of abstraction.

## Agency vs Tenancy

**Agency** is a measure of how much prior engagement is required to use a platform.
For public providers, a low-agency service is one that requires upfront work (Quote, initial setup, sales consultation) before using the platform.
For internal providers, a low-agency service might involves slack threads, tickets, or meetings before using the platform.
A high-agency service is one where the platform owner isn't involved at all (self-service).

Agency Extremes:

- Extreme _agency_: Any provider with a free tier and no credit card required!
- Extremely _low agency_: Many SaaS products, anything that says "Contact Us" for a buy link.

**Tenancy** is a measure of how shared or segmented the platform is for each customer.
Multi-tenant environments include things like classic "shared webhosting".
Single-tenant environments include things like classic "dedicated servers".
In 2022, this dimension is independent of the agency dimension.

Tenancy Extremes:

- Extreme _multi-tenancy_: Dreamhost shared webhosting
- Extreme _single-tenancy_: Any dedicated server provider (Hetzner)

### Analysis

[![Analysis Chart](/uploads/A-Fundamental-Theory-of-Platforms-Part-1/A-Theory-of-Platforms-Agency-Tenancy.svg)](/uploads/A-Fundamental-Theory-of-Platforms-Part-1/A-Theory-of-Platforms-Agency-Tenancy.svg)

Some observations:
- Enterprise Sales stuff is often low-agency, for lots of reasons.
- Shared vs not has fluctuated in the industry over time.
  Servers started off shared (mainframes), moved to dedicated (good old servers, PCs), and then back to shared (vps, VMs)
- Self-service is used in high-volume environments, low-agency in low-volume environments  

#### Agency in the Fundamental Theorem

Platform engineers want to build self-service stuff, but should only do that with higher level abstractions.
Don't try to build low-level abstraction self-service things.
Why?

- Because if you try to build a high-level abstraction platform that is self-serve, you will end up doing more work than you need to at first.
  Building a self-service platform is hard work!
  By delaying this work, you are in closer contact with your first customers, and will learn more about what they actually need, faster!
- Building a low-level abstraction platform that is self-service is also a waste of company time.
  In order to build such a thing, it will require you to be a "thin" layer on top of some other low-level platform.
  Your customers will see you as being "in the way".

Maybe being a "contact us" style platform at first is better?
Internally, if you are not-self-serve, does that make things better?
What if you built a [doorbell in the jungle](https://medium.com/@komorama/the-doorbell-in-the-jungle-cca22fbd78d0) first?

In theory, a platform should stay white-glove, simply until the act of manually onboarding a customer hurts the platform more than it helps.

#### Tenancy in the Fundamental Theorem

Tenancy for platforms probably the least prescriptive dimension for the fundamental theorem.

What really matters is the cardinality of the "fundamental unit" of the platform, impact of problems when you use shared stuff.

In general, the theory advises to **start multi-tenant, and move to single-tenancy as the business requires it.**
Why?
Because often, regardless of the problem domain of the platform, it is easier to move from multi-tenant to single-tenant, and not the other way around.

Designing this way ensures that you _can_ do multi-tenancy, and you reap the economic benefits from doing so from the start.
You will be lucky to have the problem of customers that require dedicated units!

### Conclusion

By now, nobody doubts the power of having good internal platforms.
Platform Engineering will continue to grow in popularity as companies figure out how much of a super power that it is.

Armed with the Fundamental Theory of Platforms, we can build what is best for the business from the beginning based on core principals.

But what does this look like _in practice_?
Take a look at [Part 2]({{< ref "2022-12-02-platform-abstraction-practice" >}}) concrete examples of this theory in the real world, with advice on how to course-correct if you think you are building the wrong thing.
