---
categories: null
comments: true
date: 2019-01-12T19:35:56Z
published: true
title: Being a Great Engineering Mentor
---

Here are some thoughts how I think about being a great engineering mentor.
To me the most important thing is remembering "who to be", and not as much as "how to act".
You won't remember how to act.
You can look up all the listicles you want on tips on what to do as a mentor, but if you can just "be" the right person, the choices you make and the things you say might just come naturally.

When it comes down to it though, people remember you in an amalgamation of things you say, facial expressions, body language, and the emotions you project.
Often I think a small set of key moments solidify your mental model into a mentors brain (and likewise, first impressions with everyone else).
Saying the right thing at the right moment, or being supportive of them for the right thing, or challenging them to do better at a receptive moment, can make all the difference to a mentee.

Unless otherwise specified this advice applies to mentees, regardless of whether they are interns, new graduates on their first jobs, or industry hires.

I'm going to describe things in the first person, and you are welcome to internalize it as "advice".

## Being Available

**Who to "be": A Level 1 Cache**

I always sit literally next to whoever I'm mentoring, no exceptions.
It is so clear to me: how can I be a great mentor to this person if I'm not within earshot?
Speaking of which, I don't wear headphones either.
It is one more barrier for them to ask me a question, and I want them to ask me questions.

I constantly remind them that it is my "job" to be "bothered" by them, and that they are not a bother.
They can ask me any question, any time.
This is especially important during the first few weeks of being onboarded.
Asking a simple question early on that takes 1 minute to answer can save them 1 hour of effort.
Doubly so if that effort leads them down the wrong path.

## Being Friendly

**Who to "be": A New Friend**

Of course, being a friendly person sounds like good general advice, but it is especially important to be extra friendly to a mentee.
It is likely they have been relocated to be at this new job, so they probably already have plenty of anxiety.
Being that local friend that is sitting literally right next to them every day can go a long way towards reducing that anxiety.

How do I do this?
Well, I start by asking them to lunch, all the time.
Lunch is so easy, and everyone has to eat anyway.
Even if they say no or they don't actually want to have lunch with you, it actually doesn't matter.
The important part is being inviting and reminding them that they are welcome to be with you.

At the very least, carving out a particular time, like a Wednesday team lunch, is an easy way to anchor the ritual and get everyone in sync plan-wise.

I go the extra mile and try to organize small other events, "unofficial offsites" that add a tiny bit to the team culture.
This could be things like going out for afternoon boba or ice cream for someones' birthday.
Even fancier might be a poker night at someones house, or going to a bar after work.
It doesn't have to be a big deal, but to the new hire who has moved to a new city, it could be a huge deal.
It can go a long way towards making your mentee feel like they are part of your team.

## Make Them Feel Safe

**Who to "be": An Assuring Parent**

Being a good engineer involves judging risks and rewards.
Even if your mentee has more experience than you do, they may not know how to evaluate risks within the context of your organization and team.
Maybe they don't know how many safeguards you have in place to prevent them from pushing bad code to production.
Maybe they don't know how brittle a particular subsystem is.

But you don't want your mentee to live in fear, you want them to feel safe.
When they are safe, they can explore novel solutions.
Maybe they can be more productive because they will push code more often.
In general, a larger portion of their brain can be dedicated to solving problems and to pure creation when they are not afraid to change things.

How do I make mentees feel safe?
First, I'm explicit about the technical safeguards.
I'll say things like:

> "If the tests pass on this thing, you are probably good to go."

or

> "Jenkins won't let you go to production if the integration tests don't pass,
> and this thing has plenty of coverage. It basically won't let you break
> production."

But then I'll also assure them from a non-technical perspective.
I'll say things like:

> "This codebase doesn't have much test coverage, but I've worked on it a bunch
> and I understand it. If it breaks, we'll look at it, and I'm sure we can
> figure it out together."

or

> "This change is iffy, but you've got the rollback instructions, and I'll
> literally be sitting right here next to you watching the deploy. The worst
> that can happen is that it doesn't work and we rollback quickly, no big deal."

The nature of the consequences of taking risks at your organization may vary.
Adjust as necessary.

## Encouraging / Challenging Them Technically

**Who to "be": A Dungeon Master**

Being a really good "[dungeon master](https://en.wikipedia.org/wiki/Dungeon_Master)" for the game that is "being a software engineer" requires understanding your mentee's strength and
weaknesses.
Your job is to help them "level up" by giving them appropriately challenging tasks.
There is some degree of "fun" as well.
A game that is too easy isn't very fun, and likewise a game that is brutally hard is also no fun.

Sometimes things are difficult because they are simply unfamiliar.
Sometimes "simple" things seem easy only because they are "[at hand](https://www.infoq.com/presentations/Simple-Made-Easy)".
I try to balance steering mentees towards tasks that are easy for them (even if they are not necessarily easy for me), to get their confidence up early, and then slowly add in more challenging and unfamiliar tasks.

Sometimes though, a mentee can surprise you at their abilities.
Sometimes things *you* think are hard are not actually hard.
Sometimes tasks become difficult, simply because we (mentors) prime the mentee's thoughts unnecessarily.
Instead of saying:

> "This is going to be a hard ticket, it has 5 story points and involves an old
> part of the codebase."

Say:

> "I'm not sure how hard this ticket is, someone probably just gave it 5 story
> points because they were unfamiliar with that part of the code. Why don't you
> take a look at it, spend maybe an hour thinking about how to solve it, and
> check in with me and we'll pair up and talk about it together."

Give them the opportunity to surprise you.

The other thing I do that really makes tasks much easier than they seem is "code hints".
Giving them jumpstart into the codebase can turn easily change their mind from an intimidated "gosh, I don't even know where to begin with this" to "oh, there is the code, looks straightforward".
An example might be in a ticket:

> "BUG - we ping authors of a changeset twice: Looks like we ping authors twice
> on slack for some reason. We should only ping them once. Code hint is
> somewhere around
> [here](https://github.com/Yelp/paasta/blob/e976953d6e04bcad8460ad84b3682462241465ce/paasta_tools/cli/cmds/mark_for_deployment.py#L305)"

By giving a code hint, you give the illusion of familiarity, and allow the mentee to focus on the problem itself.

Giving mentees "stretch goals" or "extra credit" is another way of giving them room to show off, gain confidence, and in general give them a chance to impress you.
You can encourage this in tickets as well:

> "BUG - Off by one error in the pagination code .... Code hint: ... Extra
> Credit: replace the custom pagination code with a library to solve this class
> of bug permanently."

Don't forget to praise them for going the extra mile.
I frequently do this at standup when a ticket is closed or referenced:

> "Great job by the way on fixing that bug. That was a hard one, and you are
> going to make a small but important class of users a lot less frustrated with
> our product"

or

> "Great job on finally closing that ticket. I know that was a tough one but
> you stuck with it to the end. I could tell you spent a lot of brainpower
> figuring that out, so thank you."

Don't let that kind of effort go unacknowledged.
Share in their successes, mourn with them in their defeats.

## Be a Context-Sharing-Machine

**Who to "be": A Manager?**

Although I am not a manager, I do have 1:1s with others, including anyone I'm mentoring.
This is a dedicated time for them to bring up things that they are concerned about, or proud of, or confused about.

But really, I use this time to reinforce all the things that I do during the non-1:1 time, but in a private and powerful setting.
Words you say in a 1:1 can mean a lot, no matter how many years of experience they have under their belt.

It is all the same stuff, just repeating yourself and reinforcing things.

**Reminding them that they are doing a good job, and that you notice their work.**

> "You are doing a great job on this sprint. Thanks for chiming in on that code
> review, you didn't have to do that but you had insightful commentary. You are
> really beginning to spread your "Ruby Wings" on this Rails codebase, it's
> cool."

**Challenging them to do better**

> "Your recent code has been fine, but your code coverage has been spotty. I
> want you to really focus on writing tests this next week. I know you are
> capable and I think it will stretch you as a software engineer."

**Sharing business context that would be hard to see**

> "Since you started working here, you really have accelerated our Ruby->Golang
> migration in a big way. I know it may seem like you are not making new
> features or anything, but you are actually helping us make progress on a long
> term business goal of significantly increasing the speed of the site. We
> think that making the site faster overall will give us an advantage over our
> competitors. So keep that in mind as you push this migration."

**Sharing engineering context**

> "Thanks for finishing off that last Docker migration ticket. Believe it or
> not, that represents a year long effort to get everything into Docker, and we
> are now in that glorious future thanks to you and thanks to the Docker
> expertise you brought with you."

## Conclusion

That is a lot of words. 

The key here is being the right person and letting the actions come naturally.

There is no "simple" solution.
There is no checklist or onboarding walkthrough that magically makes this happen.
It takes an investment of emotional energy to be a great mentor.
Hopefully that investment is rewarded in the long run, but that is only a nice to have.
