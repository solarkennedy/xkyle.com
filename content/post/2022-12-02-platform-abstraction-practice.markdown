---
slug: "A Fundamental Theory of Platforms: Part 2"
title: "A Fundamental Theory of Platforms: Part 2"
date: 2022-12-02T00:00:00-00:00
published: false
---

> Note: This is Part 2 on Platform Engineering theory.
> Read [Part 1]({{< ref "2022-12-01-platform-abstraction-theory" >}}) if you are more interested in the theory behind these recommendations.

# Applying Theory

As a recap from Part 1, the Fundamental Theory of (internal) Platforms is:

> One should be build an _internal platform_ to solve **real business needs**, starting with the following properties:
>
> - As high-level of an abstraction as possible, evolving to later provide lower-levels as well
> - As opinionated as possible to start, evolving to more flexibility with _other_ offerings
> - As little self-service as possible, evolving to more self-service
> - As multi-tenant as possible, evolving to (more expensive) isolated environments as the business requires it

So sure, we have some general guidelines on how to build them, and some of the "why" from [part 1]({{< ref "2022-12-01-platform-abstraction-theory" >}}).

But let's look at some real life platform scenarios and come up with some practical advice using this theory.

## Abstraction Level

The theory says to start high and go low as-needed.
But, how high is high?
How low is low?

Let's explore this with some concrete examples.

### How High is Too High?

Remember, the fundamental theory says we are supposed to solve **real business needs**.
But it isn't immediately obvious what the business needs sometimes.

_You know you have built a platform with too high of an abstraction when it actively prevents your platform users from solving their business needs_. It just doesn't solve the problem at hand.

The tricky thing is, technical requirements for your platform sometimes look like business needs in disguise.

There is a big difference between "We need to be able to serve ssl-protected dynamic web properties" and "we need to be able to define a [k8s pod spec](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.19/#podspec-v1-core).

### What about a Happy Medium?

You might be tempted to build a platform with a "happy medium" level of abstraction.
On that is not super high, but also doesn't require your users to learn an API they don't need to know.

I think this particular line of thinking is one of the most dangerous.
It sounds, on the surface, very very reasonable.
However, this type of design, combined with being very flexible, leads to weird outcomes:

* Your high-level users are under-served.
  They are forced to copy/paste lots of configuration they don't understand in order to use the platform.
  Maybe they don't know or care what a `Dockerfile` is or want to have to write any YAML, but lots is copy/pasted anyway.
* Sprawl occurs unless actively fought by a central team.
  The level of abstraction isn't high enough to express what the users actually need, which makes it difficult to improve the platform at the lower layers.
* Your low-level users are under-served.
  They twist the medium-level abstraction as best they can to meet their lower-level needs.
  They take advantage of corners of the system, but end up not actually able to do what they want in a straightforward way.
  Often they end up stretching the cardinality of one of the dimensions of the platform in a way you didn't design for.

Examples:

* You find that you need to spend lots of support time with your high-level users getting past problems that are inappropriate for their skill level.
* Your low-level users have to constantly query your control-plane api in order to get it to do exactly what they want.
* You can't remove the `instance_type` field (in favor of ram/cpu/disk) because customers have pinned to certain instance types and depend on that specific behavior.

### How Low is Too Low?

All platforms are built on top of other platforms.
If you build too low, then all you can effectively due is create a "thin" platform on top of someone elses.

Only in rare circumstances is a thin platform worth anything ot the business, otherwise you are just getting in the way of your developers.
Real life examples of this might be:

- A very small team (one person) providing some blessed Terraform modules as a thin platform on top of a cloud provider
- A security team that needs to proxy a cloud provider API to enforce constraints
- A database team that tightly controls the usage and configuration of cloud databases at a company

The platform du-jour is of course built on Kubernetes (k8s).
An extremely common mistake I see in the industry is believing that the k8s api (kubectl, k8s yaml) is an appropriate level of abstraction to expose to platform users.

You know you have built too low of an abstraction when:

* The platform is very difficult to get started with (your users need to learn k8s).
* You find that changes you make to the platform have much more unintended side-effect than anticipated (you can't upgrade k8s without breaking users).
* A different team decides to build their own platform (the platform team should have built that!!!) on top of yours just to make it easier to use.

An internal platform should provide a higher level abstractions than whatever platform it builds upon.
Read more about this in the API space with this blog post [APIs as Ladders](https://blog.sbensu.com/posts/2022-01-24-apis-as-ladders/).
Balancing the level of abstraction with ease of use and flexibility is _not_ easy.

## Flexibility

Flexibility is tied to the abstraction layer in many ways.
Sure, low-level abstractions are "flexible" (you can write _anything_ in assembly language!), but high-level abstractions can also be flexible ([IFTTT](https://ifttt.com/)).

So what should you do when you build something that is opinionated, but then realize it isn't flexible enough?
You have two choices:

1. Extend what you have
2. Offer a second lower-level thing

Extending what you have could be a slippery slope.
If you find that you are being asked to extend your platform, meet with those customers and ask about their long-term goals to see if they wouldn't better be served by a second offering.
Heck ask those power users to help you design the second offering!

It is not possible to give advice here on which option is the best without specifics on the situation.
For AWS Lambda, it was almost 6 years after its original release that it offered [custom image/runtime](https://aws.amazon.com/blogs/aws/new-for-aws-lambda-container-image-support/) support.
That 6 years of experience hopefully informed that decision!

## Agency

Remember, we used to have a term for the 100% managed platform: **Operations**.
The whole reason devops came of age and now platform engineering is that we want the business to faster and more agile.
Being self-service is a large part of how we achieve that (fewer blockers).

Practically, it takes a _ton_ of engineering work to make a full self-service platform.
If your are transitioning from an Ops-style engineering org, it will be a serious culture shock moving to full-self service.

The right move is to transition from managed ops -> self-service platform slowly (over years), and evolve the company culture with it, as self-service capabilities arise.

You may never get to 100% self-service, and that is just fine.
Heck, some companies are just fine with Operations and don't need self-service to go any faster!
This is totally fine, just rebrand your Operations team -> SRE and call it a day!

## Tenancy

Regarding agency, remember that from a practical perspective, it is way easier to move from a multi-tenant environment to a single-tenant option.

Shared offers economic benefits and low minimum cost per tenant.
This is especially important in the early days of the platform, where maintaining and upgrading one (multi-tenant) environment is easier than upgrading N environments.

There are a few things to balance here:

* The cardinality of your customer's deploys (just how many unique deploys are we talking about?)
* The impact of problems you will experience by going multi-tenant (how bad are noisy neighbors?)
* What is the financial impact of going multi vs single? (how much do you save by binpacking?)

Going in the other direction, going from single->multi, cost becomes the dominant decider.
How many people's salaries does it save when you go multi tenant?

# Conclusion

Building an internal platform isn't easy.
Having principles and theory does help, but in the end it is a practical endeavor.

Most companies are not Google (i.e. they don't have a huge population of engineers to dedicate to the platform).
Most companies are not Amazon (i.e. providing a platform with a huge space of solutions to offer).
Make the most of your platform engineering efforts by picking abstractions that provide the most value for the business, and allow room for you to evolve and provide new offerings as time goes on.

[ [Part 1]({{< ref "2022-12-01-platform-abstraction-theory" >}}) | [Part 2]({{< ref "2022-12-02-platform-abstraction-practice" >}})]
