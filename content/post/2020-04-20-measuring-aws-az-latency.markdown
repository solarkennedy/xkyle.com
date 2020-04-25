---
title: "Measuring AWS Region and AZ Latency"
date: 2020-04-20T12:54:42-07:00
---

Lots of people are aware of the different AWS regions that are available for use.

But let's say you wanted to know about the network topology between regions, specifically how "close" they are to each other, from a network-perspective.

Using data from [cloudping.io](https://www.cloudping.co/grid) and some [graphviz](https://github.com/solarkennedy/cloud-zone-analysis/tree/master/aws-regions) code, I created this latency map (click for the pdf):

[![aws latency map](https://raw.githubusercontent.com/solarkennedy/cloud-zone-analysis/master/aws-regions/region-latency.gv.png "AWS Region Latency Map")](https://github.com/solarkennedy/cloud-zone-analysis/raw/master/aws-regions/region-latency.gv.pdf)

## How About AWS Availability Zones?

Not Availability Zones (AZs) are the same.
Due to geography, there will be some AZs with lower latency to other AZs.
But how much? Are there some regions that are tighter than others?
Are there outliers?
I went ahead and made maps for ALL the AZs available to me.

Notes:

* Smallest inter-AZ Latency: aps1-az1 <> aps1-az1 ~ 0.250ms !
* Largest inter-AZ Latency: sae1-az3 <> sae1-az2 ~ 3.37ms !
* AZ names are shuffled with each AWS account (your us-west-2a is not necessarily *my* us-west-2a), so I use the [AZ ID](https://docs.aws.amazon.com/ram/latest/userguide/working-with-az-ids.html) as a consistent identifier.
* All results are taken from the best of 50 pings between AZs (See the [code](https://github.com/solarkennedy/cloud-zone-analysis/tree/master/aws-azs))
* Graphs use the latency measure squared as the desired length of the edges in the graph, which exaggerates the final shape.

| Region         | Notes | Map |
|----------------|-------|-----|
| `af-south-1` <br> Africa (Cape Town) | brand new region! | <a href="/uploads/cloud_analysis/af-south-1.gv.svg"><img src="/uploads/cloud_analysis/af-south-1.gv.svg" height="200" border=1></a> |
| `ap-east-1` - Asia Pacific (Hong Kong) | - | <a href="/uploads/cloud_analysis/ap-east-1.gv.svg"><img src="/uploads/cloud_analysis/ap-east-1.gv.svg" height="200" border=1></a> |
| `ap-northeast-1` <br> Asia Pacific (Tokyo) | N/A - I couldn't get instance launched in apne1-az3? (no capacity) | N/A |
| `ap-northeast-2` <br> Pacific (Seoul) | - | <a href="/uploads/cloud_analysis/ap-northeast-2.gv.svg"><img src="/uploads/cloud_analysis/ap-northeast-2.gv.svg" height="200" border=1></a> |
| `ap-south-1` <br> Pacific (Mumbai) | `1` and `2` are *super* close to each other | <a href="/uploads/cloud_analysis/ap-south-1.gv.svg"><img src="/uploads/cloud_analysis/ap-south-1.gv.svg" height="200" border=1></a> |
| `ap-southeast-1` <br> Pacific (Singapore) | apse1-az1 is way farther away than the other two | <a href="/uploads/cloud_analysis/ap-southeast-1.gv.svg"><img src="/uploads/cloud_analysis/ap-southeast-1.gv.svg" height="200" border=1></a> |
| `ap-southeast-2` <br> Pacific (Sydney) | - | <a href="/uploads/cloud_analysis/ap-southeast-2.gv.svg"><img src="/uploads/cloud_analysis/ap-southeast-2.gv.svg" height="200" border=1></a> |
| `ca-central-1` <br> (Central) | - | <a href="/uploads/cloud_analysis/ca-central-1.gv.svg"><img src="/uploads/cloud_analysis/ca-central-1.gv.svg" height="200" border=1></a> |
| `eu-central-1` <br> (Frankfurt) | - | <a href="/uploads/cloud_analysis/eu-central-1.gv.svg"><img src="/uploads/cloud_analysis/eu-central-1.gv.svg" height="200" border=1></a> |
| `eu-north-1` <br> (Stockholm) | - | <a href="/uploads/cloud_analysis/eu-north-1.gv.svg"><img src="/uploads/cloud_analysis/eu-north-1.gv.svg" height="200" border=1></a> |
| `eu-west-1` <br> (Ireland) | - | <a href="/uploads/cloud_analysis/eu-west-1.gv.svg"><img src="/uploads/cloud_analysis/eu-west-1.gv.svg" height="200" border=1></a> |
| `eu-west-2` <br> (London) | - | <a href="/uploads/cloud_analysis/eu-west-2.gv.svg"><img src="/uploads/cloud_analysis/eu-west-2.gv.svg" height="200" border=1></a> |
| `eu-west-3` <br> (Paris) | - | <a href="/uploads/cloud_analysis/eu-west-3.gv.svg"><img src="/uploads/cloud_analysis/eu-west-3.gv.svg" height="200" border=1></a> |
| `me-south-1` <br> East (Bahrain) | Winner of the tightest region award! | <a href="/uploads/cloud_analysis/me-south-1.gv.svg"><img src="/uploads/cloud_analysis/me-south-1.gv.svg" height="200" border=1></a> |
| `sa-east-1` <br> America (Sao Paulo) | Winner of the *farthest AZ* award! :( | <a href="/uploads/cloud_analysis/sa-east-1.gv.svg"><img src="/uploads/cloud_analysis/sa-east-1.gv.svg" height="200" border=1></a> |
| `us-east-1` <br> East (N. Virginia) | Most complext topology, 6 AZs! | <a href="/uploads/cloud_analysis/us-east-1.gv.svg"><img src="/uploads/cloud_analysis/us-east-1.gv.svg" height="200" border=1></a> |
| `us-east-2` <br> East (Ohio) | - | <a href="/uploads/cloud_analysis/us-east-2.gv.svg"><img src="/uploads/cloud_analysis/us-east-2.gv.svg" height="200" border=1></a> |
| `us-west-1` <br> West (N. California) | There is a third AZ, but it wasn't available to me? | <a href="/uploads/cloud_analysis/us-west-1.gv.svg"><img src="/uploads/cloud_analysis/us-west-1.gv.svg" height="200" border=1></a> |
| `us-west-2` <br> West (Oregon) | - | <a href="/uploads/cloud_analysis/us-west-2.gv.svg"><img src="/uploads/cloud_analysis/us-west-2.gv.svg" height="200" border=1></a> |

## Conclusion

Before deploying something to "the cloud" that does cross-AZ RPC, at least be aware of the [monetary cost](https://www.lastweekinaws.com/blog/aws-cross-az-data-transfer-costs-more-than-aws-says/) and at least with these maps, a feel for the latency between AZs.

Maybe next I'll do Google Cloud [Regions / Zones](https://cloud.google.com/compute/docs/regions-zones#available) and Microsoft Azure [Regions / Zones](https://azure.microsoft.com/en-us/global-infrastructure/regions/)?
