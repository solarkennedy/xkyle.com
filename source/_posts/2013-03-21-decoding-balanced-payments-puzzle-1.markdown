---
author: admin
comments: true
date: 2013-03-21 02:04:43+00:00
layout: post
slug: decoding-balanced-payments-puzzle-1
title: Decoding Balanced Payments Puzzle 1
wordpress_id: 927
categories:
- bash
- programming
- python
- ruby
---

A strange string appeared at the bottom of a Balanced [Payments blog post](http://blog.balancedpayments.com/balanced-payments-operations-automated-testing-continuous-deployment-jenkins/):


> NmQ2ZjYzMmU3Mzc0NmU2NTZkNzk2MTcwNjQ2NTYzNm
U2MTZjNjE2MjQwNjU2MzZlNjU3MjY1NjY2NjY5NjQ2MTY1N
mI2MTZkNmY3NDc0NmU2MTc3Njk=


One of those puzzles to attract coders I guess. The guys at [Hacker News](https://news.ycombinator.com/item?id=5409062) spilled the beans, so lets spill them some more.

First though,** Mad Props** to the Balanced team for thinking "outside" the unit-test-box. Plus Jenkins rocks. The world needs more Jenkins. 


# Bash?


I'm not a developer, so my first instinct was to use the existing set of tools that people have _already written_ to solve this puzzle:

    
    curl -s http://blog.balancedpayments.com/balanced-payments-operations-automated-testing-continuous-deployment-jenkins/ \
    | html2text | grep -P '[^.*]=$' | head -n 1 | base64 -d \
    | sed 's/../0x& /g' | xxd -r -c 100 | rev


I love the command line.


# Python?


The Balanced guys look like they are Python people. That's cool. [BeautifulSoup](http://www.crummy.com/software/BeautifulSoup/) is the only Python html parser I've used:

    
    import urllib2
    import BeautifulSoup
    import re, base64
    content = urllib2.urlopen('http://blog.balancedpayments.com/balanced-payments-operations-automated-testing-continuous-deployment-jenkins/').read()
    soup = BeautifulSoup.BeautifulSoup(content)
    # Last pre has the base64 string
    string = soup.findAll('pre')[-1].getText()
    print base64.b64decode(string).decode('hex')[::-1]




# Ruby?


[Hpricot](https://github.com/hpricot/hpricot) is the only Ruby html parser I've used. Also, I love**_ .map_**:

    
    require 'hpricot'
    require 'open-uri'
    require 'base64'
    thehtml = open('http://blog.balancedpayments.com/balanced-payments-operations-automated-testing-continuous-deployment-jenkins/') { |f| Hpricot(f) }
    string = thehtml.search("//pre")[1].to_plain_text
    puts Base64.decode64(string).scan(/../).map {|a| a.to_i(16).chr}.join.reverse




# Conclusion


Solving puzzles is a fun way to learn new things! If you are hungry for more excuses to learn how to use languages, check out [Project Euler](https://projecteuler.net/).
