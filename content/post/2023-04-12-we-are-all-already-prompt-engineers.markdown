---
title: "We (Software Engineers) Are All Already Prompt Engineers"
date: 2023-04-12T00:00:00-00:00
---

[Prompt engineering](https://en.wikipedia.org/wiki/Prompt_engineering) is an the emerging practice of talking to an AI to get a desired outcome.

As a software engineer, I would like to make the case that we were already doing this, just our "AIs" were extremely primitive and error-prone.

ChatGPT and [Copilot](https://github.com/features/copilot) are getting very close (in March 2023) to being less error-prone than I am.

## I am a Natural Intelligence with a Finite Prompt 

I'm 39 and this is deep, but my "prompt" is all I can remember from the last couple of decades of my professional experience.
If I could compress my experience down to GTP4's 32k token limit, why _wouldn't_ it be able to reproduce my work?

My professional experience is not ineffable.

## Why is Natural Language the New Coding API?

Natural language was already the existing Coding API.
We just had a different name for it: a Software Requirements Doc.

This is why I think the future of IDEs is not autocomplete, it is a conversation.
It is an AI pair programmer right next to you, where you can ask it to refine methods, refactor, and meet ever expanding requirements.
I believe this is best done through natural language: just ask it.

The larger piece of functionality enabled by a true conversational IDE is feedback.
The AI can just tell you if you are asking for the wrong thing, or imposing conflicting requirements, or suggest better alternatives.
Github Copilot cannot do this in its current form.

The other thing currently missing from AI powered IDEs is test running.
Giving the AI constraints ("make sure this test passes") is going to be the ultimate way we force AI code writers to write correct code, _just like we do with humans, including myself!_

## AI Powered Issues and PRs

Once we have this all in place, why stop there, let's skip the IDE.
As long as the AI (or software engineer!) is good enough, just have the conversation on the PR via code review.
We already have a machine-readable method for having this conversation!

Then, there will be a `PROMPT` file in the repo that might say something like this:

```
You are a professional Java 8 developer.
You prefer to use internal methods and code over introducing a new dependency.
Any public methods are considered stable and changing their behavior is not acceptable unless requested.
Your priorities are correctness, performance, and security, in that order.
...
```

Of course different software codebases will have different `PROMPT` files, reflecting the philosophies of the current owners.

Then the role of a software engineer is boiled down to its true essence: **converting business requirements into software requirements**, and letting the tools do the rest.
In other words, create a [very well-constructed Github Issue](https://www.fastcompany.com/90869194/github-gpt4-copilot-x-coding-assistant), let the AI make a PR, have a conversation on that PR, and sometimes asking it to update the `PROMPT` file to rebase the PR.
The AI will start with its training against all open source code in the world, read the `PROMPT `, read in the whole codebase, read the issue, and then "autocomplete" a PR.

## We Are Already Prompt Engineers

As a senior engineer, this evolution isn't a surprise to me.
My job was never simply writing pure code, it was writing _English_.
I happened to learn a second language (code) to write in because it was the most efficient way to translate my English thoughts into something that works and solves the problem.

But it also involves feedback in the other direction, pushing back on the technical limits of the system, evolving a system in time in a sane way.

Yes, there will always be people who write code directly without AI help, it will just turn into a hobby that people do as a fun challenge, like [AdventOfCode](https://adventofcode.com/).

## Software Engineering Will Change

New AI IDEs will arise, then new AI workflow tools that don't need an IDE at all.
The software engineers who embrace these tools _will_ be 10x engineers, _if_ they they already had (or can build up) the clear thinking and language abilities to power the IDE.

Software engineers who do not adopt these tools will simply be less productive.
This may be fine, heck not everyone uses and IDE anyway!
Just be prepared to be first on the chopping block due to poor performance.

## SRE: A Temporary Safe Job?

Writing code is one thing, but running it in production and being able to debug it is another.
This is one area that I think is safe from AI for a while.

We have a general industry term for the class of engineer that specializes in "code in production": [SRE](https://sre.google/).

We will still need _someone_ to understand what the code is that is being deployed, regardless of who wrote it, and understand it in the context of the bigger picture of the whole system.

I have trouble imagining how we will translate the mental models that SREs build up in their head into something a LLM can processes.
"The map is not the territory" here, where any documentation about the system as a whole is going to be out of date.
This is contrast to a codebase, where the code itself cannot lie, it _is_ the territory.

Consider, for example,  and the dynamics of an ongoing outage.
An AI could process the firehose of events, but without the context around the other systems at play, I don't see how an AI could make due.
This may be beyond the scope of a LLM.
Or maybe I just have a poor imagination.
I've seen enough [Mayday](https://en.wikipedia.org/wiki/Mayday_(Canadian_TV_series)) episodes to know what happens when a human pilot and an autopilot conflict.
But then again, our current autopilots can't just talk to you like a human.

## Aside: "Jailmommy" and "Do Anything Now" (DAN)

Jailmommy is an example prompt to "jailbreak" ChatGPT to get it to respond to you in a NSFW fashion.
"Do Anything Now" (DAN) is a general term for jailbreaking ChatGPT to get it to respond without safeguards, ignoring its _initial_ prompt.

When I first heard about these, the sounded like a classic "data plane / control plane" mixup.
Why are we using English words (data plane) with an initial prompt to _control_ ChatGPT?
No initial prompt, if using the the same data plane as external users, will ever be safe from a jailbreak.
How will we ever have safe LLMs?

I'm not an AI ethics philosopher or AI developer, but seems to me that the initial prompt or `PROMPT` file should be given a higher status, in some sort of control plane.
Kinda like the [Three Laws of Robotics](https://en.wikipedia.org/wiki/Three_Laws_of_Robotics), you can't _just_ ignore your previous instructions.
There needs to be room for the initial prompt to be elevated to be closer to what we humans might call "principles".

The reason I bring this up in the context of software development is obfuscated code.
I'm sure an AI could insert a more complex and convoluted backdoor, better than any human could.
Previously we had to worry about malicious employees and malware, but now we have to worry about surreptitious coding AIs writing their on obfuscated malware!

## Conclusion

AI (Large Language Models) are changing software development.

I, for one, welcome our new code-writing, `PROMPT` reading, PR crafting, code-review conversing overlords.

In a weird way, anyone who has practiced [self-affirmations](https://en.wikipedia.org/wiki/Self-affirmation) is _already_ a prompt engineer, just influencing your own neural network.

The practice of software engineering is already similar, where we tell "user stories", write software requirements docs, specifications, and unit tests to help prompt the code we wish to see.

How that code manifests itself into the world is, as we say, an implementation detail.