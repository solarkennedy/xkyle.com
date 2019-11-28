---
categories: null
comments: true
date: 2019-11-26
published: false
title: "Can Infrastructure Teams Do Better Than AWS? Yes, Sometimes."
---

AWS likes to use the pharse
"[undifferentiated heavy lifting](https://www.cio.co.nz/article/466635/amazon_cto_stop_spending_money_undifferentiated_heavy_lifting_/)"
to describe what AWS does best: all the things that everyone hast to do anyway with computers. Commonly these are things like running servers for you, hosting files, and managing a network.
Let AWS handle the boring things so that you can focus on what matters most for your business.
Sounds great! I certainly do not want a job that could otherwise be commonditized and turned into an API.

In the world of "Cloud" providers, who's mission is to provide
"undifferentiated heavy lifting" for other companies, is there even room for
infrastructure teams to provide value to their organizations? Or are they just barriers to the onramp that is the Cloud-computing-dream?

Some firmly believe the answer is unequivocally "No." They believe that
developers should be given an AWS account and then let loose, given
all the freedom, flexibility, and power to do their thing.
Some believe that any "wrapper" or "abstraction" or "glue" on top of AWS is a type of gatekeeping, a relic of old types of beliefs that no longer apply in the new DevOps world.

Others believe that companies need a "platform team" to build abstractions on top of cloud providers. Examples of company platforms include Target's [TAP](https://www.linkedin.com/pulse/counting-down-zero-time-takes-launch-app-target-tom-kadlec-1/) and Atlassian's [Micros](https://blog.developer.atlassian.com/why-atlassian-uses-an-internal-paas-to-regulate-aws-access/).

Where do infra teams fit in? Should they be the gatekeepers to all things AWS
or metal? Should they re-invent all of AWS's wheels? Should they be handing out
root access to developers? Should developers even need root access?
Where should the line be drawn when it comes to giving developers the "power of the cloud" and giving them an abstraction layer? A more famous engineer says that building internal PaaS's is an [Anti-pattern](https://www.lastweekinaws.com/blog/an-internal-paas-to-manage-aws-dont-do-it/), but maybe there is a more nuanced answer.

## Start By Drawing A Line

This line represents the abstraction layer over your servers, whether that be physical servers or cloud-provided ones. It also includes the abstraction layer over services, like on-prem load balancers or cloud-provided ones.

### When The Line is "null"

At first, with no infra team, the line is all the way towards the raw
resources. Developers are given an AWS account, a [budget](https://aws.amazon.com/aws-cost-management/aws-budgets/) and the docs.
In AWS developers might use [Code Deploy](https://aws.amazon.com/codedeploy/) or [Beanstalk](https://aws.amazon.com/elasticbeanstalk/) to get their
code out.
Great! Sometimes this is called "NoOps", because there is no "operations" or infrastructure teams at all, it is just developers living blissfully in the cloud with no restraints :).

If there is only one development team, and one application, this is a great way
to start. No need to setup Kubernetes (k8s), microservices, or install a
service mesh. Even if there is only one person on the team who setup these AWS
resources, that can be fine, because there isn't much else to do? Until there
is.

### When One Team Grows Into Two

With two developer teams, you will have your first opportunity to leverage gains through sharing. Maybe it will be a library you both share for interacting with infrastructure. Maybe it will be shared terraform modules to help reduce boilerplate. Maybe it will be a shared Ansible repo with playbooks.

Certainly at this stage, it doesn't "feel" like one team is trying to isolate, hide, or gatekeep them from the underlying infrastructure, right?

### When Two Dev Teams Grow Into Ten

With Ten development teams doing their thing, it will become pretty clear that there is shared code or infrastructure components that are now powering your business. Things are spreading and diverging. Maybe one team wants to try out k8s and these new "containers" that everyone keeps talking about. Maybe one team has found "Spinnaker" for doing pipelines and thinks the other nine teams should try it.

As a organization, you are ready to make a call: Should we let the ten teams just do their thing and let things evolve organically, or should there be a dedicated team that is just in charge of building and maintaining the shared stuff?

I don't think I need to make the case that, at a certain scale, some sort of shared-infrastructure-core-compute-platform-devops team is worth it. Infrastructure at scale is complex, and expertise in infra can be a tide that raises all boats. But how do you prevent that tide from drowning your other teams, or even worse, holding them back from the "sunken treasures" that are the native cloud technologies? Where do you draw that infrastructure line boundary?

## Push That Line Where It Makes The Biggest Impact
