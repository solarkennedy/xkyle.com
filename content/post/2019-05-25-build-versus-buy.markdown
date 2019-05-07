---
categories: null
comments: true
date: 2019-05-25T19:35:56Z
published: true
title: "Build Versus Buy: You Are Always Building, Always Buying"
---

## TL;DR:

* "Build-vs-Buy" is a false dichotomy, you are always building, always buying
* "This is not your 'Core Competency'" is a faux trump-card, everything is a spectrum
* Past experience is overrated, what matters for hiring is your ability to learn

## Understanding The Trade-Off
Fully understanding the **build-versus-buy** trade-off requires a bunch of
different context to really get right. At first glance you might think that
you only need to really understand:

* The problem you are trying to solve
* How the thing you are looking to buy solves the problem

But in reality it is much more nuanced than that. Most of the reading out there
about the build-versus-buy trade-off is written with "enterprise" software in
mind, and evaluate things on a very first-order level. Concerns like:

* How well can this software integrate with other things?
* How much does this software cost?
* How much time will it take to integrate the software and make it meet your
  organizations' needs?

These are all important questions to ask, but there are higher-order concerns
that take some time to fully appreciate like:

* In the long run, can your developers build a solution that provides more
  long-term value to your organization? (even if in the short-term it costs
more and takes longer to build?)
* How will your (in-house or external) users "feel" when they notice that your
  solution is based on an off-the-shelf (bought) product?
* Can you account for the in-house skills and expertise that would be
  simultaneously developed (and required) if the solution was developed
in-house?
* Will there be any developer or user attrition if you built versus if you bought?

These are not as easy to answer, but the answers to them may be even more
significant than the $$$ figures your vendor may come up with.

I've never been really satisfied with the "build-versus-buy" trade-off in
general, mostly because throughout my entire career, it has never been a
dichotomy: I was always building, and always buying.

### Understanding the False Dichotomy

The false-dichotomy comes from the fact that everything "bought" requires
integration, and it is *building* of that integration that actually builds
the value to your organization.

At the same time, we are always buying. Even when it seems like we are
choosing the "Build" option, are are still buying, it just the we are buying
libraries, frameworks, and other components to build the solution. Things are
not built in a vacuum.

It is all building, and all buying. There is no such thing as a turn-key
solution, it is just a spectrum between simpler and more complex products.

It is in the building that you provide value to your organization and to your
users. It is in the buying that you "stand on the shoulders of giants" and
become a more powerful engineer by building on top of existing engineering.

### "Core Competency": The Ultimate Faux Trump-Card

Sometimes it is "simple" to describe some build-versus-buy decisions by framing
them in terms of what the organization's "core competency" is. Sometimes it is
so simple as "if it is within our core competency, then we build, otherwise we
buy".

What does "core competency" really mean? Before software was [eating the
world](https://www.wsj.com/articles/SB10001424053111903480904576512250915629460),
"core competency" could have meant something very different. But now software
is seen as a universal multiplier for every business, regardless of what they
do. What does software have to do with [Nike's](https://engineering.nike.com/)
core competency? Are computer servers Amazon's core competency? What would the
core competency be of any retail organization? How about a game design company?
What about a high-frequency trading firm?

The answer is blurry in this world, because software in so fundamental to the
world we live in. Software is a multiplier for all levels of any business, from
HR to Product to Manufacturing to Retail, it knows no bounds and powers all the
things. Discarding an opportunity to build something that enhances your
business is a mistake.

### Case Study: Game Design and Looking at Game Engines

Game design, like any other software engineering pursuit, also involves many
build-versus-buy decisions. From assets, to engines, to voice acting, to motion
capture, there are many many micro build-versus-buy decisions to make when
developing a game. In some sense, *every one* of these decisions fits into
their "core competency". In another sense, building your own game engine for
example, sounds like a decision that 90% of game studios should choose "buy"
over build. Is developing your own game engine in-house included in their "Core
Competency"? Who knows.

The real question is: will buying an existing Game Engine provide more value to
your game than what your team could bring to the table, or would it hold your
game back from what you are trying to achieve?

If the year is 1993 and you are building Doom, then no, buying an engine will not help you achieve your goals. Building an engine will help you build what would make your game unique.

If the year is 2017 and you are building Fortnite, then yes, buying an engine will help you build your game faster by focusing on what makes it unique.

This doesn't imply that we should not still be building new game engines in 2020. Just that fewer people should.

### On Personal Engineering Capital

As an engineer, how should one look at the build-vs-buy trade-off in terms of
building personal engineering capital? That is, how does career advancement
come into play when deciding when to build versus when to buy?

I see this as a trick question. With two years of *building* on a codebase
written in an
[obscure language](https://thedailywtf.com/articles/A_Case_of_the_MUMPS), 
there is still room to gain new skills, and level-up the state of the
environment you are in, leaving it better than when you got there.

On the other hand, does *buying* an existing
[software package](https://thedailywtf.com/articles/the-enterprise-axe)
mean you won't be creating any "personal engineering capital" for yourself?

What does this really mean? Is this just a fancy way of saying "I want to work
on something that will look good on my resume."? Or is it even simpler than
that: "I want to work on something that is different (or in a different
language) than what the company needs."?

Although this comes from a position of privilege, I don't think that it is my
current employer's job to set me up for my next job. Not only that, I see the
both the opportunity to buy and the opportunity to build *both* as ways to
better my skills and be a useful engineer.

*Buying* an off-the-shelf [container orchestration system](https://kubernetes.io/)
allows me to *build* amazing things on top of it. Things that would be impossible to build without help from such a product. Likewise, *building* a company-specific
[ETL](https://en.wikipedia.org/wiki/Extract,_transform,_load) platform allows me to understand a problem more deeply, but I would still need to "*buy*" other
[software](https://kafka.apache.org/intro) to make it work.

I'm personally not in it for the glamour, I'm in it for the problem-solving and the tech.

I can also say, coming from a person who interviews a lot of candidates for my
own job, past experience has much less of an impact as you might think. In a
world where Javascript frameworks come in and out of vogue over the course of
months, **your number one hireable quality is the ability to learn new
things**.

## Conclusion

I don't think the key to a fulfilling software engineering career involves
building everything out of Rust or whatever is the hottest language out there
right now. Likewise, if you feel like your job is "just" gluing pre-built
things together, well guess what, **[the value comes from that
glue](https://www.networkcomputing.com/data-centers/diy-devops-build-buy-or-yes)**,
and the thing you are *building* is an even bigger platform on top.
