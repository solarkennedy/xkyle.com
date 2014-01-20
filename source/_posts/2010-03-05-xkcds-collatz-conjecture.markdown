---
author: admin
comments: true
date: 2010-03-05 05:44:25+00:00
layout: post
slug: xkcds-collatz-conjecture
title: XKCD's Collatz Conjecture
wordpress_id: 463
categories:
- graphviz
- nclug
- xkcd
---

In the [XKCD](http://xkcd.com) comic dated 3/4/2010, the [Collatz Conjecture](http://xkcd.com/710/) presents the following scenario:
![](http://imgs.xkcd.com/comics/collatz_conjecture.png)

Well I don't know if your friends will stop calling your or not, but I was curious about what the graph would actually look like. The graph in the comic looks like it was created with Graphviz, one of my favorite programs!

So I wrote a quick bash script to generate the approrpiate links for graphviz to interpret:

```bash
    #!/bin/bash
    echo "digraph \"xkcd\" {"
    for NUMBER in `seq 1 100`
    do
      if [ $[$NUMBER % 2] -eq 0 ]; then #We are even
        let OUTPUT=$NUMBER/2
      else  #Odd
        let OUTPUT=$NUMBER*3+1
      fi
      echo "$NUMBER -> $OUTPUT"
    done
    echo "}"
```

So what does it really look like? Here:

[![](/uploads/xkcd-collatz-672x1024.png)](/uploads/xkcd-collatz.png)

There are lots of straggling links. This is of course only because I went to 100. Why not 1000? It is a little big... click [Here](/uploads/xkcd-collatz2.jpg).

Turns out with even more numbers we end up with even more isolated links, no big super chain.

If you would like to run this code for yourself, first make sure you have the graphviz package installed in your linux system. Then copy that code above into a script, say called xkcd.sh. Then run like so:

```bash
./xkcd.sh | neato -Tpng | display
```

Adjust as necessary.
