---
title: "Advancing the State of The Art of Container Storage With Titus, Part 1"
date: 2022-05-01T00:00:00-00:00
---

**Disclaimer**: This blog post is a deep dive in to the topic of Linux container storage, specifically looking at Netflix's Open Source [Titus](https://github.com/Netflix/titus-executor) container platform.
Netflix happens to be my employer, but nothing in this blog post is secret or talk about anything that isn't already open source.

## Intro (The Problem)

Container storage is a complex subject.
Getting a hook into the right place to be able to do storage syscalls in Linux for a container requires orchestration help between the storage driver and the container
orchestrator.
Starting in 2019, the industry standard way to do it is with the [_Container Storage Interface_](https://github.com/container-storage-interface/spec/blob/master/spec.md) (CSI).

As comprehensive as the CSI is, it has some limitations:

- What about Linux namepaces? Titus makes use of Linux user namespaces, and the CSI doesn't make provisions for how to use user (nor network, pid, or mount!) namespaces.

- What if you don't know what your storage is at container start time?
  It would be nice if we could decouple exactly what storage is required for a container away from the container orchestrator.

- Wouldn't it be cool if you could attach storage after the fact?
  What if we need to attach storage full of debugging tools?
  Or on-demand for doing a backup of a database?
  Or a dynamic media encoder that computes storage artifacts at runtime?

## Background: Linux Namespaces and Storage

When it comes to storage and containers there are four Linux namespaces we need to consider:

1. **Mount Namespace**
   ([`NEWNS`](https://man7.org/linux/man-pages/man7/mount_namespaces.7.html)):
   The mount namespace is the most obvious namespace to look at when it comes to storage.
   You can see the mounts of your local namespace with `cat /proc/mounts`.
   If we do anything with container storage, it would be nice if the mount only showed up in the container's namespace, and didn't fill up the host's.

1. **User Namespace**
   ([`NEWUSER`](https://man7.org/linux/man-pages/man7/user_namespaces.7.html)):
   Filesystems have file permissions.
   If a Linux container is using a special User namespace, then the filesystem mount will need to respect that.
   If the mount does not happen within the user namespace, the UIDs will be wrong, access checks will be different and wrong.
   This is especially important with shared network filesystems where there might be more than one container mounting it at a time.

1. **PID Namespace**
   ([`NEWPID`](https://man7.org/linux/man-pages/man7/pid_namespaces.7.html)):
   Some filesystems (mostly FUSE) come with userspace components with real PIDs and consume real CPU and ram.
   For each mount, these userspace components should get launched in the container's PID namespace so that they are correctly accounted for, and can be seen when the container runs `ps`.
   Otherwise they will clutter up the host pid namespace and may not get reaped when the container dies.

1. **Network Namespaces**
   ([`NEWNET`](https://man7.org/linux/man-pages/man7/network_namespaces.7.html)):
   The network namespace contains the ip addresses, routes, and bandwidth limits (stock k8s doesn't have bandwith limiting, but Titus does) for the container.
   For storage, this network namespace is important for any network-attached storage, like NFS, which may need to resolve hostnames or do network traffic to do its job.

## How Kubernetes (via the CSI) Mounts Storage

There are many [steps](https://medium.com/velotio-perspectives/kubernetes-csi-in-action-explained-with-features-and-use-cases-4f966b910774) involved to go from zero to a running Kubernetes Pod with a volume.

For this blog post I want to focus on one of the last steps,
[_PublishVolume_](https://github.com/container-storage-interface/spec/blob/master/spec.md#nodepublishvolume), where the CSI driver actually mounts storage. The normal location would be
something like:

```
/var/lib/kubelet/pods/<pod-uuid>/volumes/</pod-uuid>kubernetes.io~csi/<pvc-name>/mount`</pvc-name>
```

The CSI driver creates that directory, then actually mounts the requested storage there, "outside" of the container, on the host.
Next, kubelet will **bind-mount** that directory into those new containers as they are created for the pod.

Already with this design we are locked into the fact that the storage must be bind mounted at the time of the container creation.
We'll never be able to attach storage via the CSI _after_ a pod is launched with this design.

The next major drawback has to do with all those Linux user namespaces that we talked about.
The CSI spec says:

> A Plugin SHOULD NOT assume that it is in the same Linux namespaces as the Plugin Supervisor.

In some sense that could be good!
Ideally the CSI storage plugin would simply be in all the container's namespaces.
In practice, container namespaces are often not used with CSI/k8s:

- **Mount Namespace?**:
  CSI plugins end up running in the host mount namespace, and the kubelet bind-mounts that folder into the container's mount namespace.
  The mounts end up in both namespaces.

- **User Namespace?**:
  Kubernetes/Kubelet [currently](https://github.com/kubernetes/enhancements/pull/2101) does not support user namespaces.
  UID 0 in the container == UID 0 on the host.

- **PID Namespace?**:
  Fuse-based CSI drivers usually use a daemon-set (example: [Azure Blob CSI](https://github.com/kubernetes-sigs/blob-csi-driver)) to run processes.
  They don't live in the container's PID namespace.
  A container using this CSI cannot see the fuse driver with `ps`, and its CPU/RAM get allocated to the daemon-set, not the container actually using the storage.

- **Network Namespace?**:
  All the CSI plugins I've seen run on the host's network namespace.
  Any storage must be reachable by the **host's** firewall and **host's** ip address.
  Any dns resolution for the storage is done on the host as well.

## Next

Can we do better than the CSI implementations of storage?
Yes.

In [Part 2]({{< ref "2022-05-01-titus-storage-part2" >}}) I'll discuss how Titus (`titus-storage`) is able to separate the attaching of storage from the container lifecycle (how to attach storage after a container is running), all while respecting all four Linux namespaces, _and_ while keeping the container completely unprivileged.

[ Part 1 | [Part 2]({{< ref "2022-05-01-titus-storage-part2" >}}) | [Part 3]({{< ref "2022-05-01-titus-storage-part3" >}}) | [Part 4]({{< ref "2022-05-01-titus-storage-part4" >}}) ]
