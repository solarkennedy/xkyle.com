---
author: admin
comments: true
date: 2011-07-10 22:28:22+00:00
layout: post
slug: solving-the-nfs-16-group-limit-problem
title: Solving the NFS 16-Group Limit Problem
wordpress_id: 612
categories:
- acls
- linux
- nfs
---

I apologize for the verbose post. This is a complicated problem and it merits full explanation. If you are experiencing this problem I advise you to avoid skimming and read it very carefully :)

Sometimes you come across a problem that is a little more complex than average. Sometimes it is problem that is rare enough that there isn't an obvious answer in the first google hint. Sometimes a problem may seem unavoidable, which leads to work-arounds, and before you know it you have a mess. The NFS 16-group limit problem is like this. The internet is full of outdated and incorrect pieces of information. This blog post is an attempt to bring this problem to the year 2011. Google: Please make this the number 1 hit for "NFS 16 group limit" in order to save other souls the hours of troubleshooting that I went through to solve this.

TL;DR version: Use Linux and "rpc.mountd --manage-gids" and you are done.


## Defining the Actual Problem


So what is the actual problem? This problem occurs when a user, who is a member of more than 16 groups, tries to access a file or directory on an nfs mount that depends on his group rights in order to be authorized to see it.  The default authorization mechanism for NFS (auth\_sys) will take only a subset of your groups and send it to the nfs server to check if you have rights to read a file. This leads to unpredicatable and intermittent permission problems when it looks like you *should* have permission. Allow me to demonstrate:

[![](/uploads/groups-failure-300x273.png)](/uploads/groups-failure.png)

Seems odd right? I *should* be able to ls those other directories. Still don't believe me? See a wireshark disessction of one of the nfs packet:

[![](/uploads/wireshark-groups-300x176.png)](/uploads/wireshark-groups.png)

You can see that the nfs client is telling the nfs server what groups you are in. And the protocol only has room for 16 :(

## Dispelling Myths and Superstition

	
  * This problem nothing to do with NFSv4, NFSv2, NFSv3, etc. This is a limitation of auth\_sys. Going to NFSv4 does not make this problem go away.

	
  * The problem has nothing to do with the underlying filesystem on the nfs server.

	
  * This 16 group limit with auth\_sys is not tuneable. It is defined in [RFC 5531](http://tools.ietf.org/html/rfc5531) and cannot be adjusted or patched.

	
  * Using group-based ACLs will not solve the problem.


Actually trying to wrap your brain around the problem and trying to solve it turns into a whiteboard that looks like this:

[![](/uploads/acl-whiteboard-300x131.jpg)](/uploads/acl-whiteboard.jpg)


## The Best Solution Ever!: A New Option for the NFS Server


I hope this is the first thing you read after encountering this problem for the first time. I hope that you don't have to read any of the other "solutions" on this page. I hope you haven't wasted your time doing other work-arounds. I hope you are in an environment where you are able to use this solution:

    
    rpc.mountd --manage-gids


rpc.mountd is the program that actually serves nfs. The --manage-gids option allows the server to just plain ignore the incoming bogus 16 groups from the client, and allow the nfs server to look it up for itself. Straight from the man page:

    
           -g  or  --manage-gids
                  Accept requests from the kernel to  map  user  id  numbers  into
                  lists  of  group  id  numbers for use in access control.  An NFS
                  request will normally (except when using Kerberos or other cryp-
                  tographic  authentication)  contains  a  user-id  and  a list of
                  group-ids.  Due to a limitation in the NFS protocol, at most  16
                  groups ids can be listed.  If you use the -g flag, then the list
                  of group ids received from the client will be replaced by a list
                  of  group ids determined by an appropriate lookup on the server.


You must have a modern (past 2007) version ( >1.0.12 ) of the linux nfs server for this option and a recent kernel (>2.6.21) to go with it. Most modern distros can do it, but if you are using Solaris or some sort of embedded NFS appliance, you are probably out of luck.

On a modern Ubuntu server it has this option on by default. Check with the documentation on your distro on how to turn it on properly. Then party. I can stop writing this blog post because everyone runs modern versions of Linux for their NFS servers right??? :)


## A Crapy Solution: ACLS


You might be thinking to yourself that you can get around this group limit by setting acls. You would be kinda right. The problem is, you **cannot** use group based ACLs consistently. You **can** use user-based ACLs and that will work. Why? Because your user id **does** get passed to the NFS server, and it can decide if you should see a file or not based on the ACLs on it.

So what, are you going to add every user that needs access to any file or folder in the acl? Who is going to maintain these acls? If it is going to be scripted, who is going to maintain the script? Does your filesystem even have enough meta data space to handle all of these user acls? (Hint: probably not. JFS and ZFS are the only ones that can handle lots and lots of acls.)

You might read somewhere that you can use NFS4 specific acls. While this is true, that they do exist, they do not solve the 16 group limit problem:

[![](/uploads/nfs4-acls-300x148.png)](/uploads/nfs4-acls.png)

You don't have to believe my screen shots. Just do it for yourself.

If you are going to go this route the only way is with ZFS or JFS with some sort of script that builds and modifies dozens and dozens of user ACLs recursively. Just say no.


## An Even More Complicated Solution: Kerberos


Yea, just in case you didn't think hundreds of ACLs couldn't get any more complicated...
Now, I don't have much to say on this subject. This might be a potential solution for you if you have conversations like this:


**Comrade**: Do you have a good recommendation for a text editor?

**You**: I recommend Eclipse or Microsoft Visual Studio.

**Comrade**: Hey dude, what is the key to your wifi?

**You**: You need an active directory account syncronized with the RADIUS server before you can authenticate. What is your MAC address?


Yes, you can replace auth\_sys\ with auth\_krb5. Get ready for authentication tickets, backup key servers, crypto exchanges, setting up trust relationships, etc. If you have this many groups you probably have LDAP or Active Directory as well as your NFS server and client machines. What's one more complicated system you don't fully understand thrown into the mix?


## Oustide the Box Solutions


  * Use Samba?

	
  * Enforce everyone to be in fewer than 16 groups?

	
  * Custom home-brew rsync stuff?

	
  * Give everyone dropbox accounts? :)

	
  * Google Docs?


## Appendix: Fully Understanding What Is Going On Behind The Scenes With --manage-gids

Ok. If you have come this far and you are using --manage-gids to elegantly solve this problem. Congratulations. Ready for the behind the scenes look?

Rpc.mountd is basically ignoring what the nfs client says about your auxiliary group memberships. This does "break" the RFC, but if you ask me the RFC was broken to begin with.

When testing this, you may find some odd behavior. Don't jump to conclusions without understanding!

When the NFS server intercepts the access request, the server must now look up your groups. It will use whatever you have nsswitch.conf setup to look this stuff up. Be sure that the NFS server is reading your groups and user id membership stuff correctly, otherwise you will have permission failures.

Also, the NFS server will cache group lookups so it doesn't have to continuously make queries. The cache is visible like this:


    root@archive:~# cat /proc/net/rpc/auth.unix.gid/content
    #uid cnt: gids...
    0 9: 0 4 20 24 46 100 112 121 127
    1001 30: 100 4 20 24 46 112 115 121 122 127 1001 1002 1004 1005 1006 1007 1008 1009 1010 1011 1012 1013 1014 1015 1016 1017 1018 1019 1020 1021

    
You can see the map, and it provides a legend at the top. If you are making changes to group memberships very often, you must flush this cache to get reasonable results. The NFS rpc.mountd program will cache group mappings for <strong>30 minutes</strong> (nfs-utils-1.2.2/utils/mountd/cache.c line 157).  Flush it like this:

    root@archive:~# date +%s >  /proc/net/rpc/auth.unix.gid/flush
    root@archive:~# cat /proc/net/rpc/auth.unix.gid/content
    #uid cnt: gids...
    0 9: 0 4 20 24 46 100 112 121 127
    
Also, you now have a new limit on group membership. It isn't exactly a specific set number as much as a total number of bytes needed to represent your group memberships. In my experimenting it was 1000 bytes (characters). So if you are using group IDs that are 5 digits, +1 for a space separator and you have (1000 / 6) = 166 as your new group limit. This of course may change with time, so I encourage you to test this in your own environment. (I could not verify this with source code. It looks like it should be 100 to me? Experimentation was the only way for me to be sure what the new limit <strong>actually</strong> was.)


When a user hits this limit, that user (and only that user) will have his process hang, and the nfs client kernel will complain that the nfs server isn't responding, which it isn't. The nfs server will not be able to look up the groups for that user, and fails to send back a nfs packet with a response.

In addition, your gid map cache will have a special entry that will be commented out like this:

    root@archive:~# cat /proc/net/rpc/auth.unix.gid/content
    #uid cnt: gids...
    0 9: 0 4 20 24 46 100 112 121 127
    #1001 0:

This is an indication that the nfs server could not look up the groups for user 1001. I've setup a nagios check on my nfs servers to detect for this, in order to let us know right away that the problem is occurring. In addition I have nagios checks to alert us if we are approaching the new group limit.

