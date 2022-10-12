---
title: "Cgroups, JDK, System, DBUS, TBD"
date: 2022-10-06T15:52:17-07:00
draft: true
---

# Running Lots of Java Containers at Scale

At Netflix we run [Titus](https://netflixtechblog.com/titus-the-netflix-container-management-platform-is-now-open-source-f868c9fb5436), a large-scale container platform for running Netflix workloads.
It uses Kubernetes as control-plane, and we run our own ["virtual-kubelet"](https://github.com/Netflix/titus-executor) which actually executes containers on nodes.

Recently we encountered a very tricky phenomenon where batch workloads running JDK17 could overrun one of our nodes.
This blog post is a deep dive into can happen on a Linux server when running lots of JDK17 containers at the same time.

## The Problem: Creaking D-Bus Issues

[![Some D-BUS Problems Detected](/uploads/2022-10-06-cgroups-jdk-systemd/dbus-problems.png)](/uploads/2022-10-06-cgroups-jdk-systemd/dbus-problems.png)

Titus agents use a lot of Systemd (on the host) to provide services.
Systemd is used to provide system services to pods (think sidecars).
In fact, every pod that runs on Titus represents a handful of [templated](https://fedoramagazine.org/systemd-template-unit-files/) systemd units to help it run.

Additionally, agents use the standard [Kubernetes Node Problem Detector](https://github.com/kubernetes/node-problem-detector) component to report back to the k8s control-plane if the node is having an issue.
To make sure systemd is healthy, they have a custom node problem detector that runs:

    dbus-send --system --print-reply --reply-timeout=1000 \
      --type=method_call \
      --dest=org.freedesktop.systemd1 \
      /org/freedesktop/systemd1 org.freedesktop.DBus.Peer.Ping

This problem is temporary (mostly).
Whenever the issue subsides, D-Bus will eventually catch up and start working again, and the node problem is recovered.
After this, the k8s node taint is lifted, and the node will start running new pods again.

But _what_ was causing the problem in the first place?

Experience has shown us that, even though this problem is only affecting a handful of nodes in our test environment (hasn't even hit prod yet!), it is worth investigating this one.
If D-Bus is breaking, then soming really wrong is going on the node.

## Triaging Difficult to Find Issues at Scale

Going from a small trickle of "hey a few Titus agents have some problems" to the final solution to this problem is an exercise in debugging a large system.
A little observability goes a long way, and for Titus we get a lot of mileage out of the tried and true [ELK stack](https://www.elastic.co/what-is/elk-stack).
By logging structured data about what launches when, we can ask the question:

> Given these broken nodes with a D-Bus problem over this particular timeframe,
> what workloads started on them just before the D-Bus problem was triggered?

[![Titus workloads groups by image](/uploads/2022-10-06-cgroups-jdk-systemd/workloads-by-image.png)](/uploads/2022-10-06-cgroups-jdk-systemd/workloads-by-image.png)

It only looks this easy after many hours of dead ends and [red herrings](https://en.wikipedia.org/wiki/Red_herring).
We had already ruled out the possibility that an internal deploy of ours could have triggered this, therefore it was likely to be a customer workload inducing the problem.

This means now we know exactly what docker image (customer) workload is triggering the D-Bus Problem.
Now what?

## The Importance Being Friends With Your Big Customers

If you run a platform, even if that platform is just internal to your company, it is important to be friends with your big customers.

TBD

### What is D-Bus Actually Doing?

One interesting thing you can do to inspect D-Bus is to dump whatever it is doing into a pcap for inspection:

```bash
dbus-monitor --monitor --system --pcap > dbus-capture.pcap
```

The problem here is that, if you are going to debug a system from scratch, you need to spend your debug-tokens wisely, and I don't think this is the right place to spend it.

My reasoning here is that D-Bus is, well, a [Bus](https://en.wikipedia.org/wiki/Software_bus)!
There probably isn't really anything wrong with it.
The "D-Bus Problem" is really the lack of response from messages, specifically replies from systemd.
Even if you did stare at the pcaps from dbus under wireshark, it would be the _missing_ packets that would be important!

Why would be they missing? Well because systemd isn't responding on the bus in a timely manner.

But it isn't just systemd or D-Bus, is is the whole system coming to a crawl.
Heck just `ps` takes forever.
This implies we need to be looking deeper...

### What is Linux Actually Doing?

```bash
[  479.904961] sysrq: Show Locks Held
[  479.906001]
               Showing all locks held in the system:
[  479.906011] 4 locks held by systemd/1:
[  479.906021]  #0: ffff91851614b470 (sb_writers#10){....}-{0:0}, at: do_rmdir+0x7a/0x1f0
[  479.906082]  #1: ffff918591f19438 (&type->i_mutex_dir_key#8/1){....}-{3:3}, at: do_rmdir+0x15c/0x1f0
[  479.906181]  #2: ffff91ec51b13eb0 (&type->i_mutex_dir_key#10){....}-{3:3}, at: vfs_rmdir+0x52/0x1b0
[  479.906232]  #3: ffffffffba7889d0 (cgroup_mutex){....}-{3:3}, at: cgroup_kn_lock_live+0xa0/0x110
[  479.906962] 3 locks held by kworker/51:0/273:
[  479.906981]  #0: ffff91e44e461148 ((wq_completion)cgroup_destroy){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.907040]  #1: ffffadb81952be70 ((work_completion)(&css->destroy_work)#2){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.907090]  #2: ffffffffba7889d0 (cgroup_mutex){....}-{3:3}, at: css_release_work_fn+0x30/0x220
[  479.907231] 3 locks held by kworker/85:0/444:
[  479.907242]  #0: ffff91850004d348 ((wq_completion)events){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.907301]  #1: ffffadb819b0be70 ((work_completion)(&cgrp->bpf.release_work)){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.907542]  #2: ffffffffba7889d0 (cgroup_mutex){....}-{3:3}, at: cgroup_bpf_release+0x54/0x340
[  479.907722] 3 locks held by kworker/31:1/599:
[  479.907741]  #0: ffff91e44e461148 ((wq_completion)cgroup_destroy){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.907821]  #1: ffffadb81a6bfe70 ((work_completion)(&css->destroy_work)#2){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.907881]  #2: ffffffffba7889d0 (cgroup_mutex){....}-{3:3}, at: css_release_work_fn+0x30/0x220
[  479.908021] 3 locks held by kworker/85:1/651:
[  479.908042]  #0: ffff91850004d348 ((wq_completion)events){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.908111]  #1: ffffadb81d837e70 ((work_completion)(&cgrp->bpf.release_work)){....}-{0:0}, at: process_one_work+0x230/0x540
[  479.908201]  #2: ffffffffba7889d0 (cgroup_mutex){....}-{3:3}, at: cgroup_bpf_release+0x54/0x340
...
```

Even with very basic bpf skills, one can make a quick script:

```bash
#!/usr/bin/env bpftrace
kprobe:cgroup_kn_lock_live
{   printf("%s: %s\n", comm, probe) }
```

Hopefully quickly answering the question of "what process is holding open the cgroup lock?

```bash
(root) ~ # cat out | cut -d":" -f1 | sort | uniq -c | sort -nr | head
  14768 systemd
   7532 runc
   2608 (runc)
    680 (ckend.sh)
    672 titus-executor-
    424 (tsa)
    424 (proxy.sh)
    424 (-nsenter)
    375 (mkdir)
    336 (curl)
```

The problem is, does this report get us closer to the cause, or simply highlight a symptom?
Is systemd at fault, or it is a victim of something else going on in the system?

Only with hindsight can we say with confidence that neither D-Bus nor systemd are at fault here, they are victims of a new behavior from a new workload.

Neither systemd nor D-Bus had changed recently in the past month.
What has changed (again, only through lots of triaging and narrowing down exactly the triggering workload), is workload upgrading from JDK8 to JDK17.

TBD
https://github.com/tych0/linux/commit/6307916f26ec85ebe47aae997c07913c320dad60

### Background: JDK Container Support

https://developers.redhat.com/articles/2022/04/19/java-17-whats-new-openjdks-container-awareness

With `-XX:-UseContainerSupport`, no cgroup access at all!!!

```
-XX:-UseContainerSupport

Runtime.availableProcessors: 2
OperatingSystemMXBean.getAvailableProcessors: 2
OperatingSystemMXBean.getTotalPhysicalMemorySize: 799405780992
OperatingSystemMXBean.getFreePhysicalMemorySize: 741909929984
OperatingSystemMXBean.getTotalSwapSpaceSize: 0
OperatingSystemMXBean.getFreeSwapSpaceSize: 0
OperatingSystemMXBean.getSystemCpuLoad: 0.041905
```

```
-XX:+UseContainerSupport

Runtime.availableProcessors: 2
OperatingSystemMXBean.getAvailableProcessors: 2
OperatingSystemMXBean.getTotalPhysicalMemorySize: 15728640000
OperatingSystemMXBean.getFreePhysicalMemorySize: 15682699264
OperatingSystemMXBean.getTotalSwapSpaceSize: 15728640000
OperatingSystemMXBean.getFreeSwapSpaceSize: 15728635904
OperatingSystemMXBean.getSystemCpuLoad: 1.000000
Checking OperatingSystemMXBean
```

-XX:-UseDynamicNumberOfCompilerThreads

### What is the JDK Actually Doing?

At Netflix we have great [FlameGraph](https://netflixtechblog.com/java-in-flames-e763b3d32166) support.
What can a flame graph tell us about what the JDK is doing when the server is under stress?
The trick is, in this situation, the interesting part isn't the "normal" part of the workload, it is in the auxilary threads of the JDK.
Let's zoom into a suspiciously large flame that is outside the main business logic of the application:

[![FlameGraph](/uploads/2022-10-06-cgroups-jdk-systemd/flamegraph1.png)](/uploads/2022-10-06-cgroups-jdk-systemd/flamegraph1.png)


https://bugs.java.com/bugdatabase/view_bug.do?bug_id=8232207

You know what would be a good tool to help explain "what is going on" with a system, without having to write our own tool, and a tool that can coalesce lots of processes together to see patterns?
I
https://tanelpoder.com/posts/high-system-load-low-cpu-utilization-on-linux/

```bash {linenos=false,hl_lines=[11 12 13 16 20]}
(root) ~ # sudo psn -G syscall,wchan,filename -d 10

Linux Process Snapper v1.1.0 by Tanel Poder [https://0x.tools]
Sampling /proc/wchan, stat, syscall for 10 seconds... finished.


=== Active Threads =======================================================================================================================================================================

 samples | avg_threads | comm              | state                  | syscall   | wchan                 | filename
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     104 |       20.80 | (C* CompilerThre) | Disk (Uninterruptible) | openat    | kernfs_iop_permission |
      96 |       19.20 | (java.BASEAMI-*)  | Running (ON CPU)       | [running] | 0                     |
      60 |       12.00 | (C* CompilerThre) | Running (ON CPU)       | [running] | 0                     |
      42 |        8.40 | (systemd)         | Disk (Uninterruptible) | mkdir     | cgroup_kn_lock_live   |
      42 |        8.40 | (systemd-journal) | Disk (Uninterruptible) | read      | proc_cgroup_show      | /proc/1/cgroup
      39 |        7.80 | (C* CompilerThre) | Disk (Uninterruptible) | openat    | kernfs_dop_revalidate |
      21 |        4.20 | ((mkdir))         | Disk (Uninterruptible) | write     | cgroup_kn_lock_live   | /sys/fs/cgroup/cpu,cpuacct/system.slice/gandalf-agent.service/cgroup.procs
      21 |        4.20 | ((mkdir))         | Disk (Uninterruptible) | write     | cgroup_kn_lock_live   | /sys/fs/cgroup/systemd/system.slice/gandalf-agent.service/cgroup.procs
      20 |        4.00 | (systemd)         | Disk (Uninterruptible) | write     | cgroup_kn_lock_live   | /sys/fs/cgroup/systemd/system.slice/gandalf-agent.service/cgroup.procs
      12 |        2.40 | (C* CompilerThre) | Disk (Uninterruptible) | fstat     | kernfs_iop_getattr    |
```

## A Solution: Disabling Dynamic Compiler Threads

With that options we only get minor cgroup access:

```
[pid 2352244] openat(AT_FDCWD, "/sys/fs/cgroup/cpu,cpuacct/system.slice/ezconfig-app.service/cpu.cfs_quota_us", O_RDONLY) = 650
[pid 2352244] openat(AT_FDCWD, "/sys/fs/cgroup/cpu,cpuacct/system.slice/ezconfig-app.service/cpu.cfs_period_us", O_RDONLY) = 650
[pid 2352244] openat(AT_FDCWD, "/sys/fs/cgroup/cpu,cpuacct/system.slice/ezconfig-app.service/cpu.shares", O_RDONLY) = 650
```

https://github.com/openjdk/jdk/blob/0f28cb06ab9de649dedbe93f5d4e30fb779532d9/src/hotspot/share/compiler/compilationPolicy.cpp#L435
