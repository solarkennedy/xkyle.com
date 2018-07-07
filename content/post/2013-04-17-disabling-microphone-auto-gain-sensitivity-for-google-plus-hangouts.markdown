---
author: admin
categories:
- audio
- google
- google plus
comments: true
date: 2013-04-17T01:14:56Z
slug: disabling-microphone-auto-gain-sensitivity-for-google-plus-hangouts
title: Disabling Microphone Auto-Gain (Sensitivity) For Google Plus Hangouts
wordpress_id: 970
---

Google's Google Plus Hangout / Gtalk plugin automatically adjust your volume to account for varying noise conditions by default. Sometimes this is an undesired behavior, but there is no button to turn it off. Here is how you do it:


## Linux:


Run this in a terminal:

    
    echo "audio-flags=1" > ~/.config/google-googletalkplugin/options




## Windows:


Set the registry Key:

    
    HKEY_CURRENT_USER\<wbr></wbr>Software\Google\Google Talk Plugin\options\audio-flags = 1




## Mac OSX:


Edit the plist:

    
    ~/Library/Preferences/com.<wbr></wbr>google.GoogleTalkPluginD.plist


and set "Audio Flags" = 1


## All:


When you are done, all instances of Chrome must be restarted. Simply closing the windows isn't enough though, reboot to be sure.
