---
author: admin
comments: true
date: 2013-03-07 05:35:49+00:00
layout: post
slug: validating-graphite-metrics-with-bash
title: Validating Graphite Metrics With Bash!
wordpress_id: 895
categories:
- All
tags:
- bash
- graphite
- power
---

At my dayjob I get to work with [Graphite](http://graphite.wikidot.com/) and power meters. It is cool:

[![power-breakdown](/uploads/power-breakdown.png)](/uploads/power-breakdown.png)

To make it easy for my clients to get power information, I've written a command line tool called "power" that they can run to get the power usage for a server when running their program. Here is an example:

    
    power METER-NAME sleep 10s


Pretty handy. The "METER-NAME" is pretty important, as it lets the script know which system's power you are interested in. (It is optional, by default I let it return the power of the server that you are currently on, but this isn't always true for all workloads)


## Problem


The thing is, my power meters and lab environment change often. I'm tired of updating the script to reflect the state of my lab. Can't the script figure itself out on it's own? Yes. Yes it can.


## S.P.O.T.


I believe in a [Single Point Of Truth](https://github.com/teddziuba/teddziuba.github.com/blob/master/_posts/2011-06-30-most-important-concept-systems-design.html). Where is my SPOT regarding power data in my system? I can tell you where it isn't: it** isn't** in my script. It is in the Graphite database ya dingus.

When my users run power -l, I want it to list valid power meters, but not some hand-curated list. I want a real list, straight from the source. Lets do that, and I will never have to update the script again.


## List Those Metrics


So how can we get a list of all metrics with similar names? Easy:

    
    wget -q -O - "http://$GRAPHITEHOST/render/?target=power.*.watts&format=json&from=-5second"


As far as I can tell, there isn't really a way to get just a list of metrics without data too, but that is ok. We need the data for the next validation step...


## Validate Those Metrics


I crank my power metrics to the second, and the above api query will even return stale metrics, metrics that have old data, typo'ed metrics, etc. They will just have null data in the json.

Heck man, we can just grep that out:

    
    | egrep -v 'null.*null.*null.*null.*null'


This will filter out any metric that doesn't have up-to-the second data. Great! Side note: some of my meters might run a little behind, so they might have some null's. I only grep out meters that are missing the last 5 seconds of data, that indicates that they really are stale.

Full line:

    
    wget -q -O - "http://$GRAPHITEHOST/render/?target=power.*.watts&target=power.*.ipmi_power&format=json&from=-5second" | sed 's/target/\n/'g | egrep -v 'null.*null.*null.*null.*null' \
    | tr '"' "\n" | grep "^power" | cut -f 2 -d "." | sort -u


Obviously this is specific to my environment. You young whipper-snappers will probably have fancy json parsers and junk to validate your own metrics.


## Bonus Points: Bash Tab Completion


So that is cool. Now the script will only let your run against metrics that have fresh data.

Now, I'm super lazy. Not only do I **not** want to keep my script up to date with valid metrics, I also cannot be bothered to remember which ones are active, and I certainly don't want to **fully type them out**.

Bash completion to the rescue. My script responds to "power -l" to report the list. Here is some code to go in bash\_completion.d to help users discover the meters and enable them to be lazy:

    
    _power() {
      local cur
      cur=${COMP_WORDS[COMP_CWORD]}
      if [ $COMP_CWORD -eq 1 ]; then
        # First argument is the power meter
        powermeters=`power -l`
        COMPREPLY=( $(compgen -W "$powermeters" -- $cur) )
        return 0
      else
        # Everthing else will be a normal command
        COMPREPLY=( $(compgen -c -- $cur) )
        return 0
      fi
    complete -F _power power


All of the [bash completion code](https://wiki.xkyle.com/Bash_Completion) I've written in my life is [cargo-cultish](https://en.wikipedia.org/wiki/Cargo_cult_programming). It sure is nice to have good tools though.
