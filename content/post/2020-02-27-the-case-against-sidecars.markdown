---
categories: null
comments: true
date: 2020-02-27
published: true
title: "The Case Against Kubernetes Sidecars"
---

## Intro

The Kubernetes (k8s) ecosystem has gone crazy for sidecar containers.

[![clowncar.gif](/uploads/clowncar.gif)](/uploads/clowncar.gif)

Sidecar containers (sidecars) are auxiliary containers, not part of your application, that provide additional support to make it work.
Along with your application, sidecars can be used to [inject secrets](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar/), [ship logs](https://blog.powerupcloud.com/kubernetes-pod-management-using-fluentd-as-a-sidecar-container-and-prestop-lifecycle-hook-part-iv-428b5f4f7fc7?gi=5221437166e4), or power a [service mesh](https://aws.amazon.com/blogs/containers/using-sidecar-injection-on-amazon-eks-with-aws-app-mesh/).

Although there are some advantages to Sidecars over traditional daemons, I would like to make the case that they are actually and inferior solution for a company that has the resources to provide a platform to its developers.
The alternative is what I will call "the daemon pattern".

## Background

I'm a general believer that strong platform teams at a company are (can be) development multipliers. These platform teams build infrastructure, shared tooling, and heck probably the k8s cluster that these sidecars run on! If you live in a world where this is no separation between an infrastructure team and a application team, then maybe this blog post is not for you.

## Sidecars Con: Deploying N x M Things

The very first thought I had when I heard about the sidecar pattern (as compared to the traditional "daemon pattern" was: "wow, that sounds like a lot more resources required to run the same things!

Certain compared to the existing platform I worked on, which had daemons for doing all the normal supplemental things (logging, metrics, service discovery, secrets, etc), the sidecar pattern represented a potential **explosion** of processes to get (on the surface of it), the same job done.

Given a cluster of:

* 100 Nodes
* 1000 pods
* 5 auxiliary processes to run

Would you rather have 5000 things (sidecars) running, or 500 (daemons)? Don't forget to add sidecars to all your cron jobs, spark executors, and stateful sets too!

What about configuring, getting the logs of, and monitoring those things?

With the daemon pattern, the auxiliary processes scale with the number of nodes, and in general goes down as servers get larger over time. With the sidecar pattern, the number of processes scales **up** with the number of pods you want to run, and usually goes up as you add more things.

Compared to the daemon pattern, the sidecar pattern consumes more compute resources as well as management resources.

## Sidecar Con: Whose Job is it Anyway to Run These Things?

I really do feel bad for those organizations where the "platform team" provides only a raw k8s base, or maybe a team that "just uses {cloud provider's k8s as a service}". Whose job is it to actually add, upgrade, configure, monitor, and maintain all these sidecars?

With the daemon pattern it is pretty clear to me that it is *not* the application developer's job to maintain system daemons. Maybe a logging subteam is responsible for keeping the logging platform up (even if it isn't literally a daemon on the local host). Maybe it is just a big catchall for the "ops" team.

With the sidecar pattern, it isn't as clear. On the plus side, it is empowering for a dev team to copy paste some YAML to get a [Vault Sidecar](https://www.hashicorp.com/blog/injecting-vault-secrets-into-kubernetes-pods-via-a-sidecar/), but maybe every app shouldn't need to have them?

I think the daemon pattern provides better separation between "infrastructure versus application", which should unburden application developers and let them provide more business value.

## Sidecar Con: The Burden is on the Developer to Understand their Lifecycle

As noted [elsewhere](https://banzaicloud.com/blog/k8s-sidecars/), at the time of this writing, developers have to be aware of the interaction (lifecycle) of containers in a k8s pod, otherwise weird things happen. Developers cannot safely assume that the sidecars are ready before their application is. They also cannot assume a particular shutdown order. Also for jobs, the main job must kill the sidecars.

This [kep](https://github.com/kubernetes/enhancements/blob/master/keps/sig-apps/sidecarcontainers.md) will fix these things by making "sidecar lifecycles" a first-class object in the pod spec.

But you know, what if developers *never* had to worry about that, and instead could always safely assume that they could emit logs, or that secrets would be available, or that service discovery would be up?
With the daemon pattern, developers can take for granted that all the necessary daemons are already warm by the time their application starts, and that their application can also shut down gracefully without having to interact with anything else. With the daemon pattern, the only process the application developer needs to worry about is their own.

## Sidecar Con: Platform Teams Have Less Control Over the Infrastructure

If the company is in a situation where there is Security Team that oversees the Vault containers, sidecars, security best practices, etc, what is their experience like in the sidecar world compared to the daemon world? Likewise with a logging team or a service discovery team.

In the sidecar world, how do you perform an upgrade of say, the service mesh? Unless you are going to do manual changes, the normal way you would do this is with a [rolling restart](https://istio.io/docs/setup/upgrade/cni-helm-upgrade/#sidecar-upgrade). This sounds straightforward: it uses the existing safety built into k8s, the pods go up and down in a structured way.

But what if you *don't* want to roll every application to do an infrastructure upgrade. What if you *don't* want to restart that 48hour batch job, or your database team doesn't want you to restart their stateful sets (even with pod disruption budget).

With the daemon pattern, upgrading and managing those daemons is mostly a solved problem (I really like this [hitless systemd fd handoff thing](https://github.com/facebookincubator/pystemd/blob/master/_docs/daemon.md)). Upgrading daemons in general doesn't require impacting the application. Infrastructure teams usually don't have to ask permission from the application team to do things. They are much more decoupled, and I think that is a good thing.

## Sidecar Pro: Dragging Along Exactly What you Need

On the plus side, sidecars *do* allow you to deploy auxiliary processes in a much more focused way. This is especially important for service-mesh sidecars: the configuration is tailored to fit the application. The logging daemon only is responsible for your application logs, and can't be overwhelmed by a noisy neighbor, etc.

Sidecars do make it so that your application is 100% self-contained. You can use any k8s-as-a-service, and deploy your pod as-is (maybe). You can use a k8s node with minimal system services (all you need is the kubelet).

## Conclusion

I see the appeal of sidecars: they make it simple to add new functionality to your pod. I think they can also [get out of hand](https://youtu.be/XQjOhJtw1wg?t=1239).

I don't know what the future holds.
I could easily see the industry double down on more sidecars, or relax and move to more daemon sets with more sophisticated ways of doing calls between the pods and those daemons.

I know that for at least the things I build, I'll be advocating for as few sidecars as possible, for the sake of the developers and for the sake of the infrastructure engineers.

### Appendix: The Link-Local IP Trick

The "Link-Local" IP trick is using an IP from the [169.254.0.0/16](https://en.wikipedia.org/wiki/Link-local_address) space to get an IP that can be reached by other local pods.

Amazon AWS uses [169.254.169.254](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ec2-instance-metadata.html) for this, but you can pick your own at your own organization.

With a little network glue, you can run your local daemons on your nodes using a link-local IP, then all your pods will be able to reach it (you can't use a 127.x IP, because each pod will have its own network namespace and its own localhost). I'll leave it as an exercise to the reader to handle security and proper service attestation for requests to that IP.
