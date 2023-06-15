---
title: "There Is No Such Thing As Stock Kubernetes"
date: 2023-06-15T00:00:00-00:00
---

Sometimes I hear the phrase "Stock Kubernetes" and wonder exactly what one means when they say that.
Often it is in contrast to a "Managed" kubernetes (k8s) offering, for example (just the big three):

* Amazon EKS
* Google GKE
* Azure AKS 

But these are all on cloud providers.
When someone says "Stock Kubernetes", they may mean they want to run k8s on a cloud provider, but not use the cloud provider's service.

But they might be running on-prem, but managed k8s services are _also_ available here:

* Amazon [EKS Anywhere](https://aws.amazon.com/eks/eks-anywhere/)
* Google [Anthos](https://cloud.google.com/anthos)
* Azure [ARC](https://azure.microsoft.com/en-us/products/azure-arc/)

This means one is also choosing not to use a managed service, even when on-prem.
"Stock Kubernetes" could be in cloud or on-prem.

## But What Does "Stock Kubernetes" Mean?

I'll say it, whether on-prem or cloud, "Stock Kubernetes" means bespoke k8s.
Artistically crafted and unique.
I'm not saying this is necessarily bad or good, it really depends the application.
But we should be honest about what it is.

### Kubernetes Is Not a Product By Itself

K8s by itself is not a product by itself, but combined with other software it is a _distribution_ upon which you can run things.

The [Linux Distribution](https://en.wikipedia.org/wiki/Linux_distribution) analogy is apt.
EKS, GKE, AKS, these are all Kubernetes _Distributions_.
They bundle a bunch of software together to make a usable product.

In this analogy, k8s is the kernel.
k8s, like the Linux kernel, is not useful in of itself.
It must be bundled with extra software so that you can actually run things.
Linux needs a shell, perhaps a desktop environment, an installer, maybe an app store.
What does k8s need?

### Kubernetes Distribution Components

Kubernetes clusters also need extra software, like:

* Network Drivers called [CNI Plugins](https://github.com/containernetworking/cni#3rd-party-plugins)
* Storage Drivers called [CSI Plugins](https://kubernetes-csi.github.io/docs/drivers.html)
* Software supervisors called [Operators](https://operatorhub.io/)

Technically you could chose not to have a CNI Plugin and use the "stock" k8s network offering that uses iptables and NAT.

Technically you could not use a CSI Plugin and only use "stock" [`emptydir`](https://kubernetes.io/docs/concepts/storage/volumes/#emptydir) (local ram or ephemeral disk).

And technically you could have no Operators or extra software installed, no special CRDs, and just good old pods and deployments.

But it won't be like that for very long.

### "Stock Kubernetes" == My Custom Kubernetes Distribution

Just like we add software to Linux to make it more useful, plugins and operators get added to k8s clusters to also make them more useful.
"Stock Kubernetes" quickly becomes a custom k8s distro.

Next time someone says they are running "Stock Kubernetes", ask them what storage is available, which networking plugin they are using, and ask about which operators are running.
These will all give you an impression of what composes their distro.
