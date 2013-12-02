---
author: admin
comments: true
date: 2012-01-26 01:46:30+00:00
layout: post
slug: puppet-versus-cfengine-editing-files
title: 'Puppet versus CFEngine 2: Editing Files'
wordpress_id: 664
categories:
- All
tags:
- cfengine
- Puppet
---

## Update: I wrote this article when I was young and stupid. It is obsolete. Puppet wins, just use [Augeas](http://projects.puppetlabs.com/projects/1/wiki/puppet_augeas).





* * *



Both [Puppet](http://puppetlabs.com/) and [CFEngine](http://cfengine.com/) are formidable configuration management systems. Let's compare the two to see how the match up on the common task of editing files. Feel free to jump straight to the conclusion if you are impatient.


## Why would you need this?


What is the use-case here? These are some common tasks I do that involve editing files:



	
  * Managing lines in /etc/fstab

	
  * Adding and revoking ssh keys in authorized_keys

	
  * Editing hosts in /etc/hosts

	
  * Setting root passwords in /etc/shadow

	
  * Adding users in /etc/passwd

	
  * Adding lines to /etc/sudoers




## CFEngine 2 Capabilities


Starting with CFEngine 2, here are the built in functions for editing files:












	
  * Append

	
  * AppendIfNoLineMatching

	
  * AppendIfNoSuchLine

	
  * AppendIfNoSuchLinesFromFile

	
  * AppendToLineIfNotContains

	
  * CommentLinesMatching

	
  * CommentLinesStarting

	
  * CommentNLines

	
  * CommentToLineMatching

	
  * DeleteLinesAfterThisMatching

	
  * DeleteLinesContaining

	
  * DeleteLinesMatching

	
  * DeleteLinesStarting

	
  * DeleteLinesNotContaining

	
  * DeleteLinesNotMatchingFileItems

	
  * DeleteLinesNotStartingFileItems

	
  * DeleteNLines

	
  * DeleteToLineMatching

	
  * EmptyEntireFilePlease

	
  * FixEndOfLine

	
  * ForEachLineIn

	
  * GotoLastLine

	
  * HashCommentLinesContaining

	
  * HashCommentLinesMatching

	
  * HashCommentLinesStarting

	
  * InsertFile

	
  * InsertLine

	
  * LocateLineMatching









	
  * PercentCommentLinesContaining

	
  * PercentCommentLinesMatching

	
  * PercentCommentLinesStarting

	
  * Prepend

	
  * PrependIfNoLineMatching

	
  * PrependIfNoSuchLine

	
  * ReplaceLineWith

	
  * ReplaceAll With

	
  * ReplaceFirst

	
  * ReplaceLinesMatchingField

	
  * RunScriptIfLineMatching

	
  * RunScriptIfNoLineMatching

	
  * SlashCommentLinesContaining

	
  * SlashCommentLinesMatching

	
  * SlashCommentLinesStarting

	
  * UnCommentLinesContaining

	
  * UnCommentLinesMatching

	
  * UnCommentsNLines

	
  * UnCommentToLineMatching

	
  * WarnIfFileMissing

	
  * WarnIfLineContaining

	
  * WarnIfLineMatching

	
  * WarnIfLineStarting

	
  * WarnIfNoLineContaining

	
  * WarnIfNoLineMatching

	
  * WarnIfNoLineStarting

	
  * WarnIfNoSuchLine







So, lots of options for manipulating text files. Basically you can Append, Delete, Replace, Comment, or Uncomment (with various types of comment characters) any regex or normal string.


### Example:  /etc/hosts



    
    editfiles:
     { /etc/hosts
       AppendIfNoSuchLine  "192.168.0.1   router"
       DeleteLinesMatching "192.168.0.254 laptop"
     }


CFEngine 3 has a more [refined edit_files bundle](https://cfengine.com/manuals/cf3-reference.html#files-in-agent-promises), but I have yet to dig into it and learn it. (I'm still stuck on CFEngine 2)


## Puppet Capabilities


How about Puppet? Well, it doesn't have (at the time of this writing) built-in file editing capabilities. (See [http://projects.puppetlabs.com/projects/puppet/wiki/Pattern_Requests](http://projects.puppetlabs.com/projects/puppet/wiki/Pattern_Requests))

You can write your own definition if you feel so inclined, or copy and paste from the contributed [Simple Text Patterns](http://projects.puppetlabs.com/projects/1/wiki/Simple_Text_Patterns).

For particular jobs there are existing modules for [ssh key management](http://projects.puppetlabs.com/projects/1/wiki/Module_Ssh_Auth_Patterns), [fstab mounts](http://docs.puppetlabs.com/references/stable/type.html#mount), [/etc/hosts entries](http://docs.puppetlabs.com/references/stable/type.html#host), etc. However there isn't a built in generic file editing procedure. Why not? Reading about the controversy might make you think differently about this seemingly "lack" of functionality in Puppet.


### EXAMPLE:  /ETC/HOSTS






    
    host { 'router':
     ensure => 'present',
     target => '/etc/hosts',
     ip => '192.168.0.1',
     host_aliases => 'router' 
    }
    host { 'laptop':
     ensure => 'absent',
     target => '/etc/hosts',
     ip => '192.168.0.254',
     host_aliases => 'laptop' 
    }







## The Controversy


Even in the CFEngine world there is disagreement about the editfiles functions. Some people believe that simply manipulating the text file is not the correct way to approach the problem, in fact some believe that it [makes more problems](http://web.archive.org/web/20100710052745/http://www.cfwiki.org/cfwiki/index.php/Editfiles_Considered_Harmful) than it solves.

In the Puppet world, it seems that their model of system management is designed to be more atomic, with settings being either **absent** or **present**. The edit files functions have a more script-like mentality, leading to configurations that end up being un-maintainable. ([See this discussion](https://groups.google.com/group/puppet-users/browse_thread/thread/c64ba5017516b46f))

One might say that the solution to this problem is to use Puppet [templates](http://docs.puppetlabs.com/guides/templating.html), or CFEngine's copy functions. I agree that in some situations, like apache configs, sshd_config, or sudoers you want to have a predictable end result. Templates seem like a better solution than editing files for this end.

On the other hand, there are some files that don't really fit into templates, like fstab, /etc/hosts, or /etc/passwd. This may be especially true if the client computers are not fully controlled by the Puppet/CFEngine admin. (Say in a compliance situation, were you may not even know what is in /etc/passwd, all you know is that youneed your line appended to it.)


## Conclusion


If your environment involves keeping workstation and servers in compliance, where you do not have full control over the servers and need to keep the breakage to a minimum, CFEngine is probably the tool. Puppet certainly could be used, but CFEngine provides a richer set of pre-made tools. (You don't have to write your own sed and greps)

If your environment is fully under your control, you are probably better off following the more atomic and template based model of Puppet. In the end that style of configuration management should lead to more predictable outcomes and less cleanup.

Honestly I'm still a CFEngine / Puppet noob. Feel free to disagree or correct me in the comments.
