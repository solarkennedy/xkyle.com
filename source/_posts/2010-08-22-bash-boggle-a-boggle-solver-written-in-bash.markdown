---
author: admin
comments: true
date: 2010-08-22 07:24:10+00:00
layout: post
slug: bash-boggle-a-boggle-solver-written-in-bash
title: Bash Boggle - A Boggle Solver Written in Bash!
wordpress_id: 526
categories:
- bash
- nclug
- scripting
---

[![](/uploads/boggle-300x239.jpg)](/uploads/boggle.jpg)

Bash is my favorite computer language. I also love writing programs to help human problems.

Inspired by this [online Boggle solver](http://www.circlemud.org/~jelson/software/netboggle.pl), I decided to write my own solver while my friends were too busy playing the game and having fun :)

If you would like to test my work, here is the code:

[https://dev.xkyle.com/bashboggle/](https://dev.xkyle.com/bashboggle/)

You will need the linux "words" dictionary, which is installable on Ubuntu by running "sudo apt-get install wamerican"

Why Bash? Yea it is not as fast as C, not as terse as Perl, not as elegant as Python, bla bla bla. But Bash is Fun, and it is good to keep the skills sharp. I think I will port it to python next just for the practice.

Here is an example input and output:


> 

>     
>     kyle@kyle:~/Projects/bashboggle$ cat board.txt
>     E    I    D    A    N
>     I    G    S    S    H
>     R    R    Qu   D    L
>     A    Y    T    E    T
>     I    A    O    A    E
>     kyle@kyle:~/Projects/bashboggle$ ./boggle.sh board.txt
>     1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25
>     arty
>     dash
>     delta
>     digs
>     diss
>     eels
>     girt
>     girted
>     gray
>     hassle
>     hassled
>     rigid
>     rigs
>     sans
>     sash
>     shad
>     shads
>     sled
>     sleds
>     sleet
>     teaed
>     teat
>     teed
>     tels
>     toed
>     tray
>     trig
>     
> 
> 



The board format is pretty flexible. As long as there is some sort of whitespace in between the letters, it will work. It is also case insensitive. For test boggle problems I used this [online Boggle site](http://www.easysurf.cc/boggle.htm).
