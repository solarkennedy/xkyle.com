---
title: "Advancing the State of The Art With Container Storage on Titus, Part 2"
date: 2022-05-01T00:00:00-00:00
---

**Disclaimer**: This blog post is a deep dive in to the topic of Linux container storage, specifically looking at Netflix's Open Source [Titus](https://github.com/Netflix/titus-executor) container platform.
Netflix happens to be my employer, but nothing in this blog post is secret or talk about anything that isn't already open source.

In [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}), I discussed the current state of the art of container storage with the CSI+kubernetes, and its limitations.

In this Part 2, I'll discuss why mounting storage is difficult in containers, especially in [user namespaces](https://docs.docker.com/engine/security/userns-remap/) are in use.

## Why can't one just `mount` in a container?

If you try to `mount` in a docker container, with default settings, you will get permission denied:

```bash-session
# docker run ubuntu mount -t tmpfs none /mnt
mount: /mnt: permission denied.
```

Why?
You are root, what other credentials do you need?

You have to be a little careful about interpretting the `permission denied` error.
This error (`EPERM`) is coming from the syscall itself, which you can verify using `strace`:

```bash-session
mount("none", "/mnt", "tmpfs", 0, NULL) = -1 EPERM (Operation not permitted)
```

This first `EPERM` is due to [seccomp](https://docs.docker.com/engine/security/seccomp/).
Seccomp is a Linux kernel feature that allows one to set a policy of which syscalls are allowed to be called.
The [seccomp mechanism](https://en.wikipedia.org/wiki/Seccomp) is fine-grained, and the default policy that docker applies [only allows `mount()` syscalls if `CAP_SYS_ADMIN` is enabled](https://github.com/moby/moby/blob/085c6a98d54720e70b28354ccec6da9b1b9e7fcf/profiles/seccomp/default.json#L564-L582).

So let's enable it `SYS_ADMIN`, which should allow us to mount given that default policy?:

```bash-session
# docker run --cap-add SYS_ADMIN ubuntu mount -t tmpfs none /mnt
mount: /mnt: cannot mount none read-only.
```

Still not working?
With strace we can reveal we get a different error, `EACCES`:

```bash-session
mount("none", "/mnt", "tmpfs", MS_RDONLY, NULL) = -1 EACCES (Permission denied)
```

This `EACCES` is coming from [AppArmor](https://docs.docker.com/engine/security/apparmor/).
AppArmor is yet another Linux security mechanism to do fine-grained syscall (as well as other things) access control.
The [default docker AppArmor profile](https://github.com/moby/moby/blob/085c6a98d54720e70b28354ccec6da9b1b9e7fcf/profiles/apparmor/template.go#L44) denies `mount`.

So let's disable AppArmor and keep `SYS_ADMIN`:

```bash-session
# docker run  --cap-add SYS_ADMIN --security-opt apparmor=unconfined ubuntu  mount  --verbose -t tmpfs none /mnt
mount: none mounted on /mnt.
#
```

No news is good news here.
The mount worked!

What about a block device?:

```bash-session
# docker run -ti --security-opt apparmor:unconfined --cap-add SYS_ADMIN ubuntu bash -c "dd if=/dev/zero of=/tmp/loop.img bs=1024k count=100 && mkfs.ext3 -F /tmp/loop.img && mount /tmp/loop.img /mnt/ -o loop"

100+0 records in
100+0 records out
104857600 bytes (105 MB, 100 MiB) copied, 0.132879 s, 789 MB/s
mke2fs 1.46.5 (30-Dec-2021)
Discarding device blocks: done                            
Creating filesystem with 25600 4k blocks and 25600 inodes

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (1024 blocks): done
Writing superblocks and filesystem accounting information: done

mount: /mnt/: mount failed: Operation not permitted.
```

What now though? I thought we had all the permissions setup to mount?

In this case, using strace again reveals that this time the permission has to do with `/dev/` files:

```bash-session
newfstatat(AT_FDCWD, "/dev/loop-control", 0x7ffe59ededb0, 0) = -1 ENOENT (No such file or direc
tory)
newfstatat(AT_FDCWD, "/dev/loop", 0x7ffe59edefd0, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop0", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop1", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop2", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop3", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop4", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop5", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop6", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
newfstatat(AT_FDCWD, "/dev/loop7", 0x7ffe59eddf40, 0) = -1 ENOENT (No such file or directory)
openat(AT_FDCWD, "/dev/", O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_DIRECTORY) = 3
```

Any mount requiring something in `/dev/` is going to need docker's `--privileged=true`.
And you can't just add `--privileged` to [`docker exec`](https://github.com/moby/moby/issues/21984), it must be applied to the container at start time.

`--privileged`? `CAP_SYSADMIN`? `--security-opt apparmor=unconfined`?
Seems like a lot of security we have to disable to make it work though.
But this is the opposite of what I want. I want *more* security, not less.
This is even more complex when we throw in Linux User Namespaces.

## User Namespaces

[Linux user namespaces](http://man7.org/linux/man-pages/man7/user_namespaces.7.html) are a way mapping a UID/GIDs in a container.
For securing containers, [Titus uses user namespaces](https://netflixtechblog.com/evolving-container-security-with-linux-user-namespaces-afbe3308c082) to ensure the `root` in the container is **not** root on the host.

At the time of this writing, user namespaces are *not* enabled by default on [Docker](https://docs.docker.com/engine/security/rootless/) (sometimes called "rootless docker") or [Podman](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux_atomic_host/7/html-single/managing_containers/index#set_up_for_rootless_containers).

But, if rootless mode is setup in docker, can we *still* run mount?:

```bash-session
<docker-rootless> $ docker run --cap-add SYS_ADMIN ubuntu mount --verbose -t tmpfs none /mnt
```

On modern kernels this works!
Interestingly, we don't even need to disable AppArmor or Seccomp, as they are not enabled by default in rootless mode... :(
I'm not exactly sure why this is the case.
Titus is able to have (granted, custom) Seccomp and Apparmor policies in place on containers *and* have user namespaces enabled.

But user namespaces only allow certain filesystems to be mounted.
Per the [man page](https://man7.org/linux/man-pages/man7/user_namespaces.7.html):

> Holding `CAP_SYS_ADMIN` within the user namespace that owns a
> process's mount namespace allows that process to create bind
> mounts and mount the following types of filesystems:
>
>  * /proc (since Linux 3.8)
>  * /sys (since Linux 3.8)
>  * devpts (since Linux 3.9)
>  * tmpfs(5) (since Linux 3.9)
>  * ramfs (since Linux 3.9)
>  * mqueue (since Linux 3.9)
>  * bpf (since Linux 4.4)
>  * overlayfs (since Linux 5.11)

This is not good enough for me.
I would like to be able to mount other filesystems than those.

But what if we are OK with running a command as `root` (*real* root) outside of the container to mount storage *inside* container.
Why can't we just "run `mount`" for a container, even if it is rootless or has no additional privileges?

## Injecting Mounts in Containers

You *can* run `mount` on behalf of a container!

What makes the difference between mounting something inside or outside a container?
How does Linux "know" that something is mounted in a container or not?
The answer: "The Linux mount namespace".

If you can enter the mount namespace first, *then* `mount`, the mount will "be" in the container's mount namespace:

<table>
<tr><td> Outside the container </td> <td> Inside the container </td></tr>
<tr><td>

```bash-session
...
...
# P=$(docker inspect -f '{{.State.Pid}}' bdfaa6ac3407)
# nsenter -t $P -m mount -t tmpfs tmpfs /mnt
...
...
...
```
</td><td>

```bash-session
# docker run -ti ubuntu
root@bdfaa6ac3407:/# grep mnt /proc/mounts 
...
...
root@bdfaa6ac3407:/# grep mnt /proc/mounts 
tmpfs /mnt tmpfs rw,relatime,inode64 0 0
root@bdfaa6ac3407:/# 
```

</td></tr>
</table>

While this looks like a good lead, it will *not* work for block devices in `/dev`.
Why?
Because as soon as you change into the container's mount namespace, you no longer can see `/dev`.

Even if we could see dev files, or fuse, or network filesystems, the `mount` wouldn't work if we had the **user namespaces** on too.
Why? Because just because you are (fake) root in a container and have capabilities, they are still not enough to allow a mount (with the exception of those filesystems listed above).

## The Problem/Security of User Namespaces: Namespaced Capabilities

Let's take docker out of the picture and just use raw Linux namespaces.
They are simpler to use (even if less familiar) and demonstrate things easier.

Let's just get root:

```bash-session
$ whoami
kyle
$ unshare --user --fork --map-root-user 
# whoami
root
# capsh --print
Current: =ep
...
```

Use user namespaces, it looks like I'm root in my micro-container, and have full capabilities!
(`=ep` means all capabilities)

Can I mount block devices **now**???

```bash-session
unshare --user --fork --map-root-user mount /dev/sda1 /mnt/
mount: /mnt: permission denied.
```

No.
"Of course" I cannot.
This is not a limitation of docker (not in use), has nothing to do with seccomp, apparmor, or even file permissions!

`unshare` isn't `sudo`.
In fact it is kinda the opposite: I'm in my own "container", but the only thing I've containerized is UIDs.
You can even `chmod 777 /dev/sda1` and it won't make a difference!

But could we pull the same `nsenter` trick on a running container?

<table>
<tr><td> Outside the container </td> <td> Inside the container </td></tr>
<tr><td>

```bash-session
...
...
...
# nsenter -t 320704 --mount --user mount --verbose /dev/sda1 /tmp
mount: /tmp: permission denied.
# nsenter -t 320704 --mount mount --verbose /dev/sda1 /tmp
mount: /dev/sda1 mounted on /tmp.
...
...
...
...
```
</td><td>

```bash-session
$ unshare --user --fork --map-root-user bash
# echo $$
320704
...
...
...
...
# grep /tmp /proc/mounts 
/dev/sda1 /tmp vfat rw,relatime,fmask=0077,dmask=0077,codepage=437,iocharset=iso8859-1,shortname=mixed,errors=remount-ro 0 0
# ls -la /tmp
ls: cannot open directory '/tmp': Permission denied
```

</td></tr>
</table>

It didn't work when we tried to `nsenter` *with* user namespaces.
It *did* work when we omitted user namespaces, but then the container couldn't `ls` it!
Why couldn't we "just" mount it on the left hand side with `--user`?
We have real root on the left hand side, why didn't it work?

### User namespaces, Capabilities, and filesystems

The real reason that mounting in user namespaced containers works sometimes, but not others, is that *only certain filesystems are `ns_capable`*.

For example, only starting in kernel version [5.11](https://kernelnewbies.org/Linux_5.11?highlight=%28overlayfs%29#Unprivileged_Overlayfs_mounts) was overlayfs audited and blessed to be mounted in an unprivileged (user namespaced) container.

Still, we are talking only a [handful](https://elixir.bootlin.com/linux/latest/A/ident/FS_USERNS_MOUNT) of filesystems that have this capability.

Is there *any* way to mount storage in an unprivileged container???
Yes, with some tricks.

## Next

In [Part 3]({{< ref "2022-05-01-titus-storage-part3" >}}) I'll discuss how Titus (`titus-storage`) is able to separate the attaching of storage from the container lifecycle (how to attach storage after a container is running), all while respecting all four linux namespaces, *and* while keeping the container completely unprivileged.

[ [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}) | Part 2 | [Part 3]({{< ref "2022-05-01-titus-storage-part3" >}}) | [Part 4]({{< ref "2022-05-01-titus-storage-part4" >}}) ]
