---
title: "AWS re:Invent 2023 Talk: Iterating Faster on Stateful Services in the Cloud"
date: 2023-12-10T00:00:00-00:00
---

{{< youtube "v4nLdCHk9ag" >}}

This is a joint talk with one of my Netflix Coworkers [JS Jeannotte](https://www.linkedin.com/in/jsjeannotte).

In this talk we survey the different options for running stateful workloads on EC2.

We also present a hybrid method of using containers to run workloads using Kubelet in standalone mode, combined with the EC2 [replace-root-volume](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/replace-root.html) API. This method enables us to iterate quickly through:

1. Loading new container images and restarting kubelet for workload software upgrades
2. Rebooting the server into a new OS and kernel quickly for upgrading everything else

All without losing the on-disk state.
