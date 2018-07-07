---
author: admin
categories:
- programming
- scripting
- security
comments: true
date: 2008-08-20T23:17:05Z
slug: custom-arp-alerts
title: Custom Arp-Alerts
wordpress_id: 101
---

So I was looking around, and I wanted some sort of tool to allow me to be more aware about what was happening in the lower "bowels" of the network that I'm on with my laptop. So what is it that I want...

What I really want is some sort of mac-address based buddy list. One that would show my a list of the mac addresses talking on my network, and allow me to alias them. That would be cool.

I couldn't find such program, but I found something kinda close, its called arpalert. If you are using ubuntu you can simply run "apt-get install arpalert" (I love ubuntu!)


> kyle@kyle-laptop:~$ apt-cache search arpalert
arpalert - Monitor ARP changes in ethernet networks


You should edit the config file to your liking, but the main thing is the log file in /var/log/arpalert.log. I have it logging every interesting arp thing, because I find them interesting! You need to read up on it if you want to fully understand arpalert: [http://www.arpalert.org/](http://www.arpalert.org/)

So that is the first part. The second part is the piece that notifies you of something suspicious. Who wants to tail a log file all the time? For this I use something called "notify-send". Try running it. If you don't have it and you are running Ubuntu it will tell you that its part of the "

So I was looking around, and I wanted some sort of tool to allow me to be more aware about what was happening in the lower "bowels" of the network that I'm on with my laptop. So what is it that I want...

What I really want is some sort of mac-address based buddy list. One that would show my a list of the mac addresses talking on my network, and allow me to alias them. That would be cool.

I couldn't find such program, but I found something kinda close, its called arpalert. If you are using ubuntu you can simply run "apt-get install arpalert" (I love ubuntu!)


> kyle@kyle-laptop:~$ apt-cache search arpalert
arpalert - Monitor ARP changes in ethernet networks


You should edit the config file to your liking, but the main thing is the log file in /var/log/arpalert.log. I have it logging every interesting arp thing, because I find them interesting! You need to read up on it if you want to fully understand arpalert: [http://www.arpalert.org/](http://www.arpalert.org/)


[![](/uploads/tailarps.png)](/uploads/tailarps.png)



So that is the first part. The second part is the piece that notifies you of something suspicious. Who wants to tail a log file all the time? For this I use something called "notify-send". Try running it. If you don't have it and you are running Ubuntu it will tell you that its part of the "libnotify-bin" package. So you will need to run:


> $ sudo apt-get install libnotify-bin


Try it! run "notify test". A popup should show up! Simple! Now, we need a small program to put the pieces together and glue it. I want my popup when odd things happen. Here is the glue I wrote, modify at will:


> tail -n 0  -F /var/log/arpalert.log | awk -W interactive '{print $8, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12}' | 
while read heading message
do  notify-send -t 3000 -- "Arp Alert" "${heading} ${message}"
done


I don't think I'm done with it yet. (I want to make it give different time outs for different types of messages, and I want it to change the heading to something dynamic instead of the Arp Alert, but yea) So put that in a .sh and run it! Nothing may pop up! Try putting something new on the network and seeing if something shows up in the log. Its pretty easy to troubleshoot and modify to your liking.


[![](/uploads/screenshot1.png)](/uploads/screenshot1.png)
