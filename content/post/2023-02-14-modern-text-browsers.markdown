---
title: "Modern Text (Console) Browsers in 2023"
date: 2023-02-14T00:00:00-00:00
---

Back in 2016 I did a comparison of text-based browser [here](https://www.xkyle.com/A-Comparison-of-Text-Based-Web-Browsers/).

Back then this was the state of the art (`elinks`):

![https://mail.google.com rendered using elinks](/uploads/mail.google.com%20elinks.png "https://mail.google.com rendered using elinks")

This is speaking generously, with a particularly text-friendly example!

Now, in 2023, there are two new text-based browsers that are incredible.
Because they are backed by normal browser engines, we no longer have to be impressed by features like "color support"!

## Browsh

[Browsh](https://www.brow.sh/) is a modern text browser backed by the Firefox (gecko) rendering engine.
It works by spawning Firefox in a special headless mode, combined with a sort of post-processor browser extension, simplifying the HTML.
Then the CLI client can parse that simple HTML.

The architecture may not be ideal, but it does mean you get things like:

* Javascript
* Full mouse support
* Full motion video
* Firefox Browser extensions (adblock)

## Carbonyl

[Carbonyl](https://github.com/fathyb/carbonyl) is a modern text browser backed by Chromium (and therefore Blink + V8).

It offers incredible performance.
It is not running a headless copy of Chromium, it _is_ Chromium with a custom render output.

At the time of this writing, it is sill in early development (`v0.0.2`).

Unlike Browsh, it doesn't currently support browser extensions, and can be customized like Browsh can (because Browsh just uses real Firefox under the hood).

But on the plus side, the layer of indirection is gone, which means Carbonyl can be very responsive.
Also, it doesn't do the HTML simplification trick, which means it can (in theory) represent pages in their truer form.

## Comparison

## Site: [https://en.wikipedia.org/wiki/Rule_110](https://en.wikipedia.org/wiki/Rule_110)

![https://en.wikipedia.org/wiki/Rule_110 rendered using carbonyl](/uploads/2023-02-14-modern-text-browsers/en.wikipedia.org%20carbonyl.png "https://en.wikipedia.org/wiki/Rule_110 rendered using carbonyl")
![https://en.wikipedia.org/wiki/Rule_110 rendered using browsh](/uploads/2023-02-14-modern-text-browsers/en.wikipedia.org%20browsh.png "https://en.wikipedia.org/wiki/Rule_110 rendered using browsh")
![https://en.wikipedia.org/wiki/Rule_110 rendered using Original \(surf\)](/uploads/2023-02-14-modern-text-browsers/en.wikipedia.org%20original.png "https://en.wikipedia.org/wiki/Rule_110 rendered using Original \(surf\)")

## Site: [http://news.ycombinator.com](http://news.ycombinator.com)

![http://news.ycombinator.com rendered using carbonyl](/uploads/2023-02-14-modern-text-browsers/news.ycombinator.com%20carbonyl.png "http://news.ycombinator.com rendered using carbonyl")
![http://news.ycombinator.com rendered using browsh](/uploads/2023-02-14-modern-text-browsers/news.ycombinator.com%20browsh.png "http://news.ycombinator.com rendered using browsh")
![http://news.ycombinator.com rendered using Original \(surf\)](/uploads/2023-02-14-modern-text-browsers/news.ycombinator.com%20original.png "http://news.ycombinator.com rendered using Original \(surf\)")

## Site: [https://facebook.com](https://facebook.com)

![https://facebook.com rendered using carbonyl](/uploads/2023-02-14-modern-text-browsers/facebook.com%20carbonyl.png "https://facebook.com rendered using carbonyl")
![https://facebook.com rendered using browsh](/uploads/2023-02-14-modern-text-browsers/facebook.com%20browsh.png "https://facebook.com rendered using browsh")
![https://facebook.com rendered using Original \(surf\)](/uploads/2023-02-14-modern-text-browsers/facebook.com%20original.png "https://facebook.com rendered using Original \(surf\)")

## Site: [https://twitter.com](https://twitter.com)

![https://twitter.com rendered using carbonyl](/uploads/2023-02-14-modern-text-browsers/twitter.com%20carbonyl.png "https://twitter.com rendered using carbonyl")
![https://twitter.com rendered using browsh](/uploads/2023-02-14-modern-text-browsers/twitter.com%20browsh.png "https://twitter.com rendered using browsh")
![https://twitter.com rendered using Original \(surf\)](/uploads/2023-02-14-modern-text-browsers/twitter.com%20original.png "https://twitter.com rendered using Original \(surf\)")

## Site: [https://mail.google.com](https://mail.google.com)
![https://mail.google.com rendered using carbonyl](/uploads/2023-02-14-modern-text-browsers/mail.google.com%20carbonyl.png "https://mail.google.com rendered using carbonyl")
![https://mail.google.com rendered using browsh](/uploads/2023-02-14-modern-text-browsers/mail.google.com%20browsh.png "https://mail.google.com rendered using browsh")
![https://mail.google.com rendered using Original \(surf\)](/uploads/2023-02-14-modern-text-browsers/mail.google.com%20original.png "https://mail.google.com rendered using Original \(surf\)")

## Conclusion

Both Browsh and Carbonyl are amazing.
I never would have thought that the advancement of text-based browsers would continue to advance in 2023.

I like Carbonyl.
I think it has a better architecture than Browsh, and is way faster.
Browsh is "just firefox", which is cool, but in the browser world performance is a big deal, which makes me think Carbonyl will win in the end as it matures.
