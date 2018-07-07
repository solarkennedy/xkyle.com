---
author: admin
categories:
- bios
- git
- icc
- intel
- ipmi
- ipmitool
- linux
- Puppet
- syscfg
comments: true
date: 2013-06-26T02:34:43Z
slug: goodbye-intel-my-favorite-commands
title: Goodbye Intel - My Favorite Commands
wordpress_id: 940
---

Working at Intel has been a great experience. I wish I could have stayed longer, but in the end we decided to part ways.

During my stay I learned lots of stuff. I would like to boil my experience down to my top Linux commands.


## The List
	
  * [git](http://try.github.com): Lots of git.
  * [syscfg](https://wiki.xkyle.com/Syscfg): Managing bios settings from within Linux. Nice. (Intel platforms)
  * [setupbios](https://wiki.xkyle.com/Dell_setupbios): More bios settings from within Linux. (Dell platforms)
  * [puppet](https://puppetlabs.com/): I actually enjoy manually running puppet. --noop make me feel warm and fuzzy.
  * [micctrl](http://software.intel.com/en-us/articles/intel-manycore-platform-software-stack-mpss): Borking a lot of kernel installs on [mic ](https://en.wikipedia.org/wiki/Intel_MIC)cards, you end up using this command. Lots.
  * [flashupdt](http://download.intel.com/support/motherboards/server/ism/sb/intel_ofu_user_guide.pdf)/[flashrom](http://flashrom.org/Flashrom): Soooo many bios' flashed. Intel is bios-crazy.
  * [amplxe-gui](http://software.intel.com/en-us/intel-vtune-amplifier-xe): VTune Amplifier is a super awesome profiling tool. I could spend hours playing around in that gui exploring all programs trying to track down bottlenecks.
  * [ipmitool](/7-underused-ipmitool-commands/): Everyone needs more ipmitool in their life, totally [underrated](/7-underused-ipmitool-commands/). Sadly, I would bet most sysadmins don't even know IPMI exists. :(
  * [numactl](http://linuxmanpages.com/man8/numactl.8.php): I'm waiting for [numad](http://fedoraproject.org/wiki/Features/numad), personally. My server should be smart enough to understand its own architecture.

## Honorable Mentions
	
  * [icc](http://software.intel.com/en-us/intel-compilers/): I didn't run icc many times at Intel, but I was impressed with it.
  * [objdump](https://en.wikipedia.org/wiki/Objdump): The few times I needed to run this, I felt like a wizard.
  * [bsub](http://www-03.ibm.com/systems/technicalcomputing/platformcomputing/products/lsf/index.html): On occasion I was required to submit jobs to LSF.
  * [lscpu](http://manpages.courier-mta.org/htmlman1/lscpu.1.html): I felt like I ran this more than at other companies. Could be just selection bias.
