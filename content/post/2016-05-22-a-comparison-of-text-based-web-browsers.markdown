---
categories: null
comments: true
date: 2016-05-22T12:04:09Z
published: true
title: A Comparison of Text-Based Web Browsers
---

## Intro

Who browses on the terminal now-a-days? However you are, you are crazy,
but you might appreciate this comparison of text-based web browsers,
with screenshots of a few different popular sites.

I wanted to test these browsers with more than just simple pages, so where
possible I actually logged into places and took screenshots of
the actual webpage in a realistic state.

## Methodology

All browsers were set to use xterm with `TERM=xterm-256color`.
The following browsers were used with these settings:

* retawq (0.2.6c)
    * Enable SSL support
* elinks (0.12~pre6-11build2)
    * underline
    * linux frames
    * 256 color
    * utf8
* links2 (2.12-1)
    * Linux frames
    * Color
* w3m (0.5.3-26build1)
    * Render frames
* lynx (2.8.9dev8-4ubuntu1)
    * underline links
    * Always allow cookies

Check out the [code](https://github.com/solarkennedy/text-based-web-browser-comparison)
for the exact commands used to generate everything.

## Comparison

### [Wikipedia Rule\_110](https://en.wikipedia.org/wiki/Rule_110)
Wikipedia has great text-based browsing support in general. I did not try editing anything.
All browsers had no trouble rendering the data in a readable way.

![https://en.wikipedia.org/wiki/Rule\_110 rendered using retawq](/uploads/en.wikipedia.org retawq.png 'https://en.wikipedia.org/wiki/Rule\_110 rendered using retawq')
![https://en.wikipedia.org/wiki/Rule\_110 rendered using elinks](/uploads/en.wikipedia.org elinks.png 'https://en.wikipedia.org/wiki/Rule\_110 rendered using elinks')
![https://en.wikipedia.org/wiki/Rule\_110 rendered using links2](/uploads/en.wikipedia.org links2.png 'https://en.wikipedia.org/wiki/Rule\_110 rendered using links2')
![https://en.wikipedia.org/wiki/Rule\_110 rendered using w3m](/uploads/en.wikipedia.org w3m.png 'https://en.wikipedia.org/wiki/Rule\_110 rendered using w3m')
![https://en.wikipedia.org/wiki/Rule\_110 rendered using lynx](/uploads/en.wikipedia.org lynx.png 'https://en.wikipedia.org/wiki/Rule\_110 rendered using lynx')
![https://en.wikipedia.org/wiki/Rule\_110 rendered using Original \(surf\)](/uploads/en.wikipedia.org original.png 'https://en.wikipedia.org/wiki/Rule\_110 rendered using Original \(surf\)')

### [Hacker News](http://news.ycombinator.com)
Hacker News is mostly text-based, so these browsers had no trouble with it in general.
I appreciate elinks's support for colors that are true to the original.

![http://news.ycombinator.com rendered using retawq](/uploads/news.ycombinator.com retawq.png 'http://news.ycombinator.com rendered using retawq')
![http://news.ycombinator.com rendered using elinks](/uploads/news.ycombinator.com elinks.png 'http://news.ycombinator.com rendered using elinks')
![http://news.ycombinator.com rendered using links2](/uploads/news.ycombinator.com links2.png 'http://news.ycombinator.com rendered using links2')
![http://news.ycombinator.com rendered using w3m](/uploads/news.ycombinator.com w3m.png 'http://news.ycombinator.com rendered using w3m')
![http://news.ycombinator.com rendered using lynx](/uploads/news.ycombinator.com lynx.png 'http://news.ycombinator.com rendered using lynx')
![http://news.ycombinator.com rendered using Original \(surf\)](/uploads/news.ycombinator.com original.png 'http://news.ycombinator.com rendered using Original \(surf\)')

### [Facebook](https://facebook.com)
I could not actually log into facebook with any text-based browser.

![https://facebook.com rendered using retawq](/uploads/facebook.com retawq.png 'https://facebook.com rendered using retawq')
![https://facebook.com rendered using elinks](/uploads/facebook.com elinks.png 'https://facebook.com rendered using elinks')
![https://facebook.com rendered using links2](/uploads/facebook.com links2.png 'https://facebook.com rendered using links2')
![https://facebook.com rendered using w3m](/uploads/facebook.com w3m.png 'https://facebook.com rendered using w3m')
![https://facebook.com rendered using lynx](/uploads/facebook.com lynx.png 'https://facebook.com rendered using lynx')
![https://facebook.com rendered using Original \(surf\)](/uploads/facebook.com original.png 'https://facebook.com rendered using Original \(surf\)')

### [Twitter](https://twitter.com)
Twitter looks "ok" on text-based browsers, although for that particular
application you might want to consider a [dedicated application](http://www.rainbowstream.org/)
built for the terminal.

retawq was unable to log in for some reason.

![https://twitter.com rendered using retawq](/uploads/twitter.com retawq.png 'https://twitter.com rendered using retawq')
![https://twitter.com rendered using elinks](/uploads/twitter.com elinks.png 'https://twitter.com rendered using elinks')
![https://twitter.com rendered using links2](/uploads/twitter.com links2.png 'https://twitter.com rendered using links2')
![https://twitter.com rendered using w3m](/uploads/twitter.com w3m.png 'https://twitter.com rendered using w3m')
![https://twitter.com rendered using lynx](/uploads/twitter.com lynx.png 'https://twitter.com rendered using lynx')
![https://twitter.com rendered using Original \(surf\)](/uploads/twitter.com original.png 'https://twitter.com rendered using Original \(surf\)')

### [Gmail](https://mail.google.com)

Gmail is a tall order for a text based browser. Only elinks, w3m, and lynx could pull it off.

elinks shines again with great CSS support, with w3m with second place. These were all rendered
using the basic HTML version. Luckily I didn't get a CAPTCHA?

![https://mail.google.com rendered using retawq](/uploads/mail.google.com retawq.png 'https://mail.google.com rendered using retawq')
![https://mail.google.com rendered using elinks](/uploads/mail.google.com elinks.png 'https://mail.google.com rendered using elinks')
![https://mail.google.com rendered using links2](/uploads/mail.google.com links2.png 'https://mail.google.com rendered using links2')
![https://mail.google.com rendered using w3m](/uploads/mail.google.com w3m.png 'https://mail.google.com rendered using w3m')
![https://mail.google.com rendered using lynx](/uploads/mail.google.com lynx.png 'https://mail.google.com rendered using lynx')
![https://mail.google.com rendered using Original \(surf\)](/uploads/mail.google.com original.png 'https://mail.google.com rendered using Original \(surf\)')

## Summary

elinks is my favorite of the bunch because of color support.

This blog post is about 10 years too late, and mostly serves to remind myself which version of "links" I like and why.
