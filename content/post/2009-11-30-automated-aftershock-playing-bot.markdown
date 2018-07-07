---
author: admin
categories:
- graphviz
- nclug
comments: true
date: 2009-11-30T02:18:16Z
slug: automated-aftershock-playing-bot
title: Automated Aftershock Playing Bot
wordpress_id: 422
---

This is a bot I wrote to play Aftershock games for me. Aftershock produces these 5 games that are all basically the same, but with different themes:

[Engines of War](http://www.enginesofwar.com) - 138071613
[Undead Live](http://www.undeadlive.com) - 175496321
[Mark of Mafia](http://www.markofmafia.com) - 833613775
[Gunshock Racing](http://gunshockracing.com) - 124286853
[Dragon Masters](http://www.dragonmastersworld.com) - 304299067

If you play any of these games, feel free to ally with me :) If aftershock bans me, no big deal :)

These are the types of games that make you log in often to check your status, and use your energy (otherwise it is wasted). The thing is, most of the decisions and things I do in these games are just to preocupy your time, I could write a program to do the simple things for me. So I did! Now only if I could run it periodically from a cronjob. You see, they require you to type in a CAPTCHA every time you log into the web interface, so for my program to work I have to manually log in first. But wait, the ipod app doesn't require a captcha... if only I could run the app from the ipod, steal it's auth cookie, then run my program it could be compeltely automated! Well the best way I could find to do this was to use the [T-Plan](http://www.vncrobot.com/) vnc robot to do the required key presses, then let ssh and bash do the rest.

I also looked into using the [Erica Utilities](http://ericasadun.com/ftp/EricaUtilities/) to start the game without the complexity of vnc, but I found they didn't work on my platform with the 3.0 firmware. So now I can just sit back and let my robot level me up forever!

Here are some more technical details on the script itself if you are interested. Anyone who plays these games would find these features very desireable:



	
  * Recovers from raids

	
  * Repairs your buildings

	
  * Accepts all incoming ally invitations

	
  * Automatically uses all your fighting power to get at least 2exp for every fight, and choosing opponents that you can win against. (It automatically heals you if you need it)

	
  * Redeems combo/key/spell codes from a large number of websites to gain a huge amount of free, non-upkeep items. (And it posts your code everywhere when you have a new one)

	
  * Sends ally invitations to a huge list of available codes from a large number of code sharing sites to build up your command.

	
  * Goes through internal game pages to scrape profiles for ally codes to send more invites to.

	
  * Quits automatically when you reach the 50 invite 24 hour limit or if your cookie expires.

	
  * Deposits money in the bank


Of course you can change the order or the functions, and they are all optional. All the code is [here](https://dev.xkyle.com/). The code is just bash, using grep, sed, awk, html2text, cat, etc. You will want to edit the variables to meet your needs before you use it of course. You can check out the code with svn:


> svn co https://dev.xkyle.com/aftershock


Explaination of commands:

aftershock.sh - Main script, takes the argument 1-5 for the particular game you are playing. Needs the -i argument if you need the cookie from the ipod instead of firefox
go-ipod.sh - Runs each game consecutivly by vnc'ing to the ipod, running the game, getting the cookie, then running the appropriate aftershock.sh instance
spawnall.sh - Runs an exterm for each aftershock game. Useful if you have logged into each game through firefox, and need the robot to just do everything

I will try to support people who genuily who want to run this program. It is GPL. Email kyle@xkyle.com if you need help.
