---
categories: null
comments: true
date: 2019-06-02
published: true
title: "Kubernetes as a Universal Infrastructure API"
---

Recently the Kubernetes (k8s) [Cluster Lifecycle Special Interest
Group](https://github.com/kubernetes/community/tree/master/sig-cluster-lifecycle)
(SIG) release their [first
Alpha](https://blogs.vmware.com/cloudnative/2019/05/14/cluster-api-kubernetes-lifecycle-management/)
of their Cluster API.

What does this thing do? It is kinda like a k8s
[operator](https://enterprisersproject.com/article/2019/2/kubernetes-operators-plain-english) (it's a controller) that
has custom resource definitions for things to launch **another** k8s
cluster, with a bunch of
cloud [providers](https://github.com/kubernetes-sigs/cluster-api#provider-implementations).
It is kinda like if Terraform was re-imagined as a k8s operator, but
only for launching other k8s clusters, and not general purpose.

It supports a couple of
[resources](https://kubernetes-sigs.github.io/cluster-api/common_code/architecture.html#cluster-api-resources):

- Cluster
- Machine
- MachineSet
- MachineDeployment
- MachineClass

If you are already familiar with k8s, these may look familiar! It isn\'t
a coincidence of course. This is what it looks like when k8s users try
to make an API for launching machines.

But in general, it provides an k8s API endpoint to launch more k8s
clusters in a declarative way, just like anything else in k8s.

## How Does the k8s Cluster Lifecycle API Solve This Problem?

The k8s lifecycle thing is very new, and a very specific goal: implement
enough \"cloud\" api calls to be able to get a k8s cluster running.

They provide a couple of AMIs, but encourage you to bring your
[own](https://github.com/kubernetes-sigs/cluster-api-provider-aws#kubernetes-versions-with-published-amis).
They are working on a `clusterctl` command, analogous to kubectl.

Like Terraform (and any other k8s\'y things), the API is declarative; you
tell k8s what kind of clusters you want to exist, then the controller
takes over and reconciles that with what is out there.

Also like Terraform, you still have to provide all the details about
what you want to launch, like AMIs, security groups, vpcs, etc.

Unlike Terraform, the Cluster Lifecycle API will never be a general
purpose infrastructure thing, it will only ever launch what they need to
get a k8s cluster up (ec2 nodes).

## Is This a Good Thing?

Good for who?

While I do like the pattern of empowering k8s to launch it\'s own
infrastructure (a la [Spotinst Ocean](https://spotinst.com/products/ocean/)),
I don\'t think this Cluster API is right approach for intermediate-level
infrastructure team.

I think the nuances of what to launch and how to launch are massive.
I don\'t think the Cluster API will ever be nuanced enough to do
all the things that are required to run all the things.

That is OK. If all you need to do is launch other k8s clusters, then this API
is for you! If you need to launch any other "cloud" resource, then you will
have to end up reaching for another tool. Are you willing to have two different
ways to launch things? I don't know, maybe I just really like Terraform.

On the other hand, Terraform is flexible, but not dynamic. It doesn\'t respond
to events.  It has the benefit of git-commiting the state and being easier to
reason about, but it can\'t really make new k8s clusters \"on the fly\". It has
no "API".

I think that is OK. Do we need to launch new k8s clusters on
the fly? I think we need to be able to launch things *on* k8s
dynamically, but I don\'t think we need whole clusters to exist without
human interaction.

But I do think that the thing that launches k8s nodes should be the same
thing that is doing the cluster autoscaling control loop, and should be
empowered to launch instances that it needs.

## K8s as a Universal Infrastructure Control Plane?

The pattern of using the k8s API machinery and custom resource
definitions to control things that are not \"native\" k8s objects, kinda
reminds me of New Relic\'s
[Inventory Service](https://www.youtube.com/watch?v=eja7b3tahMg).

It keeps track of their hosts, and works like a
[CMDB](https://en.wikipedia.org/wiki/Configuration_management_database),
using just the k8s api server and custom resource definitions. **They
don\'t even run any kublets!**

This idea is articulated a bit more in this blog post about k8s being a
general purpose
\"[Ops](https://medium.com/@allingeek/kubernetes-as-a-common-ops-data-plane-f8f2cf40cd59)\"
control plane.

The k8s pattern provides a bunch of things at once that are opening up
new ways of thinking about general infrastructure problems. I think
these things are:

- A highly available hosted REST api with validation, schemas, CRUD,
  etc, with custom endpoints, [hosted by k8s](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/)
- A pattern of declarative YAML-based resource definitions
- A tight control loop running for these things, reconciling state
  with the world, with watchers, queues, and all the
  [things](https://github.com/operator-framework/getting-started) you
  would need to write this loop efficiently and correctly
- A centralized place for that control loop to run, in a singleton way
- A decent key/value store to host stuff
- A free CLI to interact with those resources (`kubectl get tronjob`)
- Authentication (authn) and Authorization (authz) + Role-based Access
  Control (RBAC)
- Secret storage

This is a great pattern to build general purpose infrastructure stuff.
It is starting with k8s objects now, but as you can see it is expanding
to store and launch k8s clusters,
[arbitrary AWS resources](https://aws.amazon.com/blogs/opensource/aws-service-operator-kubernetes-available/),
[Sensu Clusters](https://github.com/sensu/sensu-operator), New Relic\'s
inventory data, [SSL Certificates](https://github.com/sensu/sensu-operator), etc.

I predict that we\'ll see this as a Universal Infrastructure Control
Plane, because it is just so convenient, and the declarative pattern is
so often what you want in infrastructure!\
I think many infray things could be re-imagined in the CRD + Operator
world, and would be way easier to implement.

It will take time though. k8s will have to become ubiquitous first, then
the operator pattern will have to become well established, **then** we\'ll start to
see infrastructure teams want to piggyback on all the goodness and
extensibility that k8s provides.
