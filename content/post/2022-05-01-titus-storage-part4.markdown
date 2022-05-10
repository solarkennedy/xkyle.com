---
title: "Advancing the State of The Art of Container Storage With Titus, Part 4"
date: 2022-05-01T00:00:00-00:00
---

**Disclaimer**: This blog post is a deep dive in to the topic of Linux container storage, specifically looking at Netflix's Open Source [Titus](https://github.com/Netflix/titus-executor) container platform.
Netflix happens to be my employer, but nothing in this blog post is secret or talk about anything that isn't already open source.

In [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}), I discussed the current state of the art of container storage with the CSI+kubernetes, and its limitations.

In [Part 2]({{< ref "2022-05-01-titus-storage-part2" >}}), I the problem of mounting storage inside running containers, especially using user namespaces.

In [Part 3]({{< ref "2022-05-01-titus-storage-part3" >}}), I talked about the mount binaries Titus uses to mount storage in containers at runtime using new Linux mount apis and `SCM_RIGHTS`.

In this Part 4, I'll talk about how we are able to do all that, and still ensure that all the storage is ready by the time a user's workload starts up.

## Getting Storage Right, Before a Workload Starts

One consequence of building storage primitives that depend on the containers (namespaces) existing, is that it means we have to mount the storage _after_ the PID1 of the container exists.

How can we ensure that the storage is ready _first_?
Easy: Control the PID1!
Analogous to [Fly.io's init](https://github.com/superfly/init-snapshot), Titus also injects its own PID1 into every container.

The Titus PID1 (`titus-init`) just starts up, and then waits for the signal to go.
The orchestration on process (`titus-executor`) can do things like storage, while the PID1 is waiting:

```mermaid
sequenceDiagram
    participant TE as titus-executor
    participant TS as titus-storage
    participant C as container
    participant T as titus-init
    participant U as user process
    activate TE
    TE->TE: Open Unix Domain Socket
    rect rgb(191, 223, 255)
    Note over T,C: titus-init (tini) is pid1<br> of the container
    activate C
    activate T
    T->>TE: Connect to socket, wait for instruction
    TE->>TS: Start storage
    activate TS
    TS->>C: Mount storage in the container
    TS->>TE: Storage complete
    deactivate TS
    TE->TE: Setup logging,<br>auxilary services,<br>inject sidecars
    TE->>T: Launch the workload! (over socket)
    TE->TE: Close Unix Domain Socket
    T->>U: exec the original command
    end
    deactivate T
    activate U
    U->U: Start
    deactivate U
    deactivate C
    deactivate TE
    %%end
```

## Enabling Storage and Other System Services

With the workload paused, Titus can launch much more than just storage.

See [this KubeCon talk](https://www.youtube.com/watch?v=YB5rlo2cq9s) on how Titus inject lightweight sidecars into containers, without adjusting the pod spec.

## Handling Stdout/Stderr

Handling Stdout/Stderr of a container process is one of the first quality-of-life improvements that a container platform can handle.

Life is just so much better when you don't have to fight for the stdout/stderr of a crashed container!

[k8s](https://stackoverflow.com/questions/34084689/view-log-files-of-crashed-pods-in-kubernetes) doesn't exactly make it super easy.

Having control of PID1 of the container means we can easily handle the stdout/stderr file descriptors and ensure the logs are handled "out of band", and are never lost.

This is easily accomplished by simply `dup2`'ing the stdout/stderr file descriptors into real files that can outlive the container.

## Enabling systemd

Supporting [systemd](https://www.freedesktop.org/wiki/Software/systemd/) is a killer feature for Titus.
systemd requires a lot of [additional configuration](https://developers.redhat.com/blog/2016/09/13/running-systemd-in-a-non-privileged-container) to work in a container.
Luckily our Titus users do not need to know about that.
But, systemd **must** also be PID1 when it runs.
For Titus this is easy, if we detect that systemd will be running, `titus-init` simply `execs` into systemd, allowing it to take over PID1 duties.
Otherwise, `titus-init` stays in place, providing a [true PID1-compliant](https://rip.hibariya.org/post/why-you-need-a-proper-init-process-on-docker/) process, so that Titus users don't need to provide their own.

## Enabling Custom Seccomp Policies

Having control over PID1 in the container also means we can install very special Seccomp policies that will apply to every future process for that container.
But, we already have Seccomp and Apparmor, why would we want even more?
In this case, we are not using Seccomp to restrict syscalls, we are using the new [seccomp-notify method](https://lwn.net/Articles/851813/) to [enable _new_ syscalls](https://people.kernel.org/brauner/the-seccomp-notifier-new-frontiers-in-unprivileged-container-development) that can be intercepted by the supervisor.
Here those syscalls can be handled safely, and in user-space.
This is for things like the `perf` or `bpf` syscalls, which would otherwise be too powerful to give to a container.
Eventually such configuration will be part of the [OCI spec](https://kinvolk.io/blog/2022/03/bringing-seccomp-notify-to-runc-and-kubernetes/).

## Conclusion

Having control over the PID1 of every container on a container platform is a huge point of technical leverage.
I would highly encourage anyone building a container platform to invest in this control.
It is useful for way more than just "pausing" the workload for storage purposes.
It also can enable fine-grained control over process order, the [Russian Doll](https://www.youtube.com/watch?v=iz9_omZ0ctk) technique.

## Series Conclusion

Titus is engineered to have cake and eat it too:

- Advanced storage, beyond what the CSI can support
- User namespaces, Seccomp, Apparmor, above and beyond container security for multi-tenant environments, beyond what kubelet can support
- Fine-grained container ordering, systemd containers, and PID1 injection

These are hard, but not impossible requirements to meet, and all [open source](https://github.com/Netflix/titus-executor).

I look forward to continuing to be on the cutting edge of container technology as we aim to meet new challenges.

[ [Part 1]({{< ref "2022-05-01-titus-storage-part1" >}}) | [Part 2]({{< ref "2022-05-01-titus-storage-part2" >}}) | [Part 3]({{< ref "2022-05-01-titus-storage-part3" >}}) | Part 4 ]
