---
title: "Advancing the State of The Art of Container Storage With Titus, Part 3"
date: 2022-05-01T00:00:00-00:00
---

**Disclaimer**: This blog post is a deep dive in to the topic of Linux container storage, specifically looking at Netflix's Open Source [Titus](https://github.com/Netflix/titus-executor) container platform.
Netflix happens to be my employer, but nothing in this blog post is secret or talk about anything that isn't already open source.

In [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}), I discussed the current state of the art of container storage with the CSI+kubernetes, and its limitations.

In [Part 2]({{< ref "2022-05-01-titus-storage-part2" >}}), I discuss the problem of mounting storage inside running containers, especially using user namespaces.

In this Part 3, I'll discuss how Titus (`titus-storage`) is able to separate the attaching of storage from the container lifecycle (how to attach storage after a container is running), all while respecting Linux namespaces, _and_ while keeping the container completely unprivileged _and_ in its user namespace.

## What We Are Up Against

We have a running container.
We want to mount something _in_ it.
That "something" could be a network filesystem, a block device, a bind mount, overlayfs, tmpfs, who knows.
Each situation requires a unique solution.
We know that as soon as we try to switch into the user namespace of the container, we no longer can use the `mount` syscall reliably.
Is there any other way to "inject" a mount?

## How Titus (`titus-storage`) Does It

Remember from [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}) I decided to give up on the CSI and its limitations.
Instead we are just going to build some binaries, like `mount.nfs`
It will just be a binary that can run at any time and mount storage in a container, even after it has been created!

We will run this mount binary outside of the container, where we have privileges.
When we are done, we want a mount setup _inside_ the container, with all the namespaces correctly set, _all without giving container additional privileges_.

If you would rather read C than my sequence diagrams, just go straight for [the code](https://github.com/Netflix/titus-executor/tree/b2af5aa27437b5c3ec734af51e1d0c3a7e145173/mount).

### Using New Mount APIs Instead of `mount`

Thanks to the [_new Linux mount APIs_](https://lwn.net/Articles/759499/) that provide fine-grained control over the mount process, we can split up the mounting process.
Half of the mount process can happen _inside_ (some of the namespaces) of the container.
The other half can happen outside the user namespace, where our `CAP_SYS_ADMIN` still works.

The key trick is to create a
"[_superblock_](https://www.kernel.org/doc/html/latest/filesystems/vfs.html#the-superblock-object)"
(noted as fsfd) inside the namespaces (mount, net, user) of the container, and then `fsmount` that superblock on behalf of the container.
Here is a quick comparison between the classic and new Syscall APIs:

| Syscall Name       | Privileges required (usually) | Namespace interaction                                | Effect                                              |
| ------------------ | ----------------------------- | ---------------------------------------------------- | --------------------------------------------------- |
| `mount` (classic)  | `CAP_SYS_ADMIN`               | None (assumes you are already in all namespaces)     | Mounts in whatever namespaces you are in.           |
| `fscreate` (new)   | None                          | Takes on the user namespace when called              | Returns a file descriptor ready to be configured.   |
| `fsconfig` (new)   | None                          | None                                                 | Configures an input file descriptor.                |
| `fsmount` (new)    | `CAP_SYS_ADMIN`               | Takes on the current mount+net namespace when called | Mounts an input file descriptor, returns a mount fd |
| `move_mount` (new) | `CAP_SYS_ADMIN`               | Uses the mount namespace                             | Actually puts a mount fd onto the filesystem        |

Combined with `SCM_RIGHTS`, we can get the right syscalls in the right namespaces to achieve what we want.

### Using `SCM_RIGHTS` to Pass File Descriptors

Let's say that we did `nsenter --user` into a container and used `fscreate` to get a file descriptor (`fd`).
How would we get it "back out" of the container for something outside the container to use it?
Answer: `SCM_RIGHTS`.

[`SCM_RIGHTS`](https://blog.cloudflare.com/know-your-scm_rights/) is a method for processes to share file descriptors (the superblock in this case) over a Unix socket.
We are _not_ just transferring the file descriptor number here, we are passing the _actual_ file vnode/descriptor!

If we can pass the `fd` back and forth between processes, we will be able to mount storage inside containers, even block devices, even though the inside container can't "see" them.

This does require that the Linux Namespaces, heck the whole container needs to exist before we can do this procedure (contrast to the CSI, where the container needs to be created **after** the mount happens, so that it can be bind-mounted in).

This is a feature, not a bug!
It means we can mount storage in Titus containers whenever we want, just like you can attach storage on demand with any other normal server!
(See [part 4]({{< ref "2022-05-01-titus-storage-part4" >}}) for how Titus is able to pause workloads at first launch, to give `titus-storage` time to mount things first)

## Putting It All Together: NFS (EFS)

Here is an animation that demonstrates the use of these new syscalls, in combination with `SCM_RIGHTS`, mount an NFS (EFS) volume in a container.
This demonstrates the [`titus-mount-nfs`](https://github.com/Netflix/titus-executor/blob/b2af5aa27437b5c3ec734af51e1d0c3a7e145173/mount/titus-mount-nfs.c#L1) binary.
Sorry the video has `/ebs`, I meant for it to say `/efs`:

<video width=100% controls="controls" preload="none"><source src="/uploads/2022-05-02-titus-storage-part2/1.mp4" type="video/mp4"></video>

Here is the procedure in [sequence diagram](https://w3cschoool.com/tutorial/uml-sequence-diagram) form:

```mermaid
sequenceDiagram
    participant T as titus-mount-nfs
    participant F as titus-mount-nfs (forked)
    participant NET as Container Net NS
    participant USER as Container User NS
    participant MNT as Container Mount NS
    activate T
    T->T: Open Unix Domain Socket
    T->+F: Fork
    rect rgb(191, 223, 255)
    Note over F,USER: Switch to Net+User NS
    activate NET
    activate USER
    F->F: fscreate new fd
    deactivate NET
    deactivate USER
    end
    F->>T: Pass fd back over via SCM_RIGHTS
    deactivate F

    %% switch into mount + net ns
    rect rgb(191, 223, 255)
    activate MNT
    activate NET
    Note over T,MNT: Switch to Net+Mnt NS
    T->>NET: Resolve FS hostname
    T->T: fsconfig on the filesystem fd
    T->>MNT: fsmount into the mount namespace
    T->>MNT: move_mount into the mount namespace
    end
    deactivate MNT
    deactivate NET
    deactivate T
```

This works because the non-forked version of `titus-mount-nfs`, which actually ends up calling `fsmount`, never actually enters the user namespace!
But we still get the benefits of the user namespace (UIDs are correct), because we called `fscreate` while we were in there.

All of this complexity is contained within the standalone binary.
The binary just takes standard arguments like nfs mount path, hostname, but additionally a container PID to know which container to enter.

## Putting It All Together: Host Bind

A Host bind mount can be setup in a similar way, but using way fewer syscalls and tricks.
It takes a path on the host, and makes it appear inside the container.
This is a traditional bind mount, but it can be done _after_ a container is created.
All that is required is that a mount is `open_tree`'d on the host, and then `move_mount`'d into the container's filesystem.

This demonstrates the [`titus-mount-bind`](https://github.com/Netflix/titus-executor/blob/d1ce08c6094eea329c3cb94c8bd317e1ad71646a/mount/titus-mount-bind.c) binary:

```mermaid
sequenceDiagram
    participant T as titus-mount-bind
    participant MNT as Container Mount NS
    activate T
    T->T: open_tree on source path
    rect rgb(191, 223, 255)
    Note over T,MNT: Switch to Mount NS
    activate MNT
    T->>MNT: move_mount to destination
    end
    deactivate MNT
    deactivate T
```

## Putting It All Together: Block Device

This is an example of mounting a traditional block device from the host into a container.
This is useful in AWS for [EBS](https://aws.amazon.com/ebs/), which shows up as a NVMe device, like `/dev/nvme0n1`.
Normally this device file is not visible by the container.
But with the right tricks, we can configure the mount while we are on the "outside" of the container, where we can still see it.

This demonstrates the [`titus-mount-block-device`](https://github.com/Netflix/titus-executor/blob/d1ce08c6094eea329c3cb94c8bd317e1ad71646a/mount/titus-mount-block-device.c) binary:

```mermaid
sequenceDiagram
    participant T as titus-mount-block-device
    participant F as titus-mount-block-device (forked)
    participant USER as Container User NS
    participant MNT as Container Mount NS
    activate T
    T->T: Open Unix Domain Socket
    T->+F: Fork
    rect rgb(191, 223, 255)
    Note over F,USER: Switch to User NS
    activate USER
    F->F: fscreate new fsfd
    deactivate USER
    end
    F->>T: Pass fd back over via SCM_RIGHTS
    deactivate F

    Note right of T: Note: fsconfig must happen for a block device before we<br> switch namespaces, otherwise we can't see the acual /dev/ file!
    T->T: fsconfig on the filesystem fd
    %% switch into mount + net ns
    rect rgb(191, 223, 255)
    activate MNT
    Note over T,MNT: Switch to Mnt NS
    T->>MNT: fsmount in the mount namespace
    T->>MNT: move_mount in the mount namespace
    end
    deactivate MNT
    deactivate T
```

## Putting It All Together: Container To Container

I haven't seen an example of what `titus-mount-container-to-container` does in the industry.
It takes a source container + dir and a destination + dir and bind mounts them.

This is useful with [kubernetes multi-container pods](https://kubernetes.io/docs/concepts/workloads/pods/#how-pods-manage-multiple-containers), except we are able to share directly share folders from one container to another.
No intermediate `emptydir` or other shared storage is required.

For example, a sidecar container may need to see a main container's `/data`.
Or maybe a service mesh sidecar needs the main container's certificate files.

This demonstrates the [`titus-mount-container-to-container`](https://github.com/Netflix/titus-executor/blob/d1ce08c6094eea329c3cb94c8bd317e1ad71646a/mount/titus-mount-container-to-container.c) binary:

```mermaid
sequenceDiagram
    participant T as titus-mount-container-to-container
    participant F as titus-mount-container-to-container (forked)
    participant USER as Container User NS
    participant MNT as Container Mount NS
    activate T
    T->T: Open Unix Domain Socket
    T->+F: Fork
    rect rgb(191, 223, 255)
    Note over F,MNT: Switch to User+Mnt NS
    activate MNT
    activate USER
    F->F: sys_open_tree on source creating new fd
    deactivate MNT
    deactivate USER
    end
    F->>T: Pass fd back over via SCM_RIGHTS
    deactivate F

    %% switch into mount + net ns
    rect rgb(191, 223, 255)
    activate MNT
    Note over T,MNT: Switch to Mnt NS
    T->>MNT: move_mount into the mount namespace
    end
    deactivate MNT
    deactivate T
```

## Conclusion

These mount binaries are doing some creative things with syscalls to allow us to mount storage at will with containers, all while keeping them unprivileged.

But 99% of the time, users will want their storage ready _at start_, not after the container has started.
See [part 4]({{< ref "2022-05-01-titus-storage-part4" >}}) were I demonstrate how we are able to control the startup timing of containers, to ensure that storage is mounted before they start.

[ [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}) | [Part 2]({{< ref "2022-05-01-titus-storage-part2" >}}) | Part 3 | [Part 4]({{< ref "2022-05-01-titus-storage-part4" >}}) ]
