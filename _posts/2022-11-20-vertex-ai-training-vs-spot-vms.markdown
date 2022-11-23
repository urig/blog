---
layout: post
title:  "Machine Learning: Vertex AI Training vs. Rolling Your Own on Spot VMs"
date:   2022-11-20 18:10:00 +0300
categories: cloud google google-cloud-platform vertex-ai machine-learning vertex-ai-training spot-vms
---

---

**TL;DR** - If your Vertex AI Training spending is in the lower thousands of dollars, you're fine. If it's growing towards $10K or more it might be time to re-engineer for training using Spot VMs.

---

A few months back I assisted one of my clients in scaling their machine learning training payloads to be faster and more extensive than before.

The approach I advised and implemented with the client team was to shift from running on local GPU-accelerated machines to using Google Cloud's [Vertex AI Training](https://cloud.google.com/vertex-ai/docs/training/custom-training) service.

Through the Vertex AI Training service the team are now able to package and upload their training code to the cloud and run it on multiple Linux containers while paying only for the CPU and GPU time consumed.

The transition enabled the team to rent out more powerful GPU types and this resulted in shorter training times. Additionally, the team is now able to run tens of training sessions in parallel, whereas before they were limited to a handful of training machines.

Alas, good things are not free. The more training power you have, the more training power you want to use and in recent months the team's charges for the service has grown to over a thousand dollars per month.

While seeking new approaches to reduce costs while maintaining and even increasing the scope of training, the head of the client research team suggested the idea of using Spot VMs (Virtual Machines).

Spot VMs are virtual machines instances that run in the cloud at great discount. The catch? The VMs only run when demand for cloud computing power is low and cloud provider hardware ends up idling. 

Spot VMs come with an API of sorts that lets them wake up when demand is low and go to sleep when demand goes up. The tradeoff as a consumer is that you pay less but can take much longer for training runs to complete.

To evaluate the option of using Spot VMs for cloud training we first reviewed the above board for [pricing for Vertex AI](https://cloud.google.com/vertex-ai/pricing) to the equivalent [pricing for Spot VMs](https://cloud.google.com/compute/vm-instance-pricing) across a variety of geographical reasons and machine types. 

Here's a table showing the price differences for one such data point that we've found to be representative:

| (Prices per Hour)       | Vertex AI  | Spot VM |
|-------------------------|------------|---------|
| CPU (`n1-standard-16`)  | $0.873995  | $0.16   |
| GPU (`NVIDIA_TESLA_T4`) | $0.4025    | $0.11   |
| Total (rounded)         | $1.276495  | $0.27   |

When you look at the bottom line of the above comparison (pun intended) it's plain to see that Spot VMs are more than 4.5 times cheaper to run than training in Vertex AI.

But before the team jumped on the task of repackaging their training code into VM images, we took a broader look at what we were comparing and sure enough it was a case of the oranges versus apples fallacy.

![Image showing apples and oranges](/assets/images/apples-vs-oranges.jpg)
*Image credit: [pvproductions](https://www.freepik.com/free-photo/green-apples-oranges-white-background-closeup_26932164.htm)*

Indeed, when comparing the features of the two services it became clear that while Vertex AI Training offers a rich [SaaS](https://en.wikipedia.org/wiki/Software_as_a_service) experience, Spot VMs are a lower level [IaaS](https://en.wikipedia.org/wiki/Infrastructure_as_a_service) offering.

To put this into concrete differences, we listed the following features that Vertex AI provides around training:

* **Automation** - Automated packaging, versioning and deployment of training code to the cloud.
* **Observability** - Logging of both Vertex AI framework processes and our training code process. Messages are searchable in GCP's Log Explorer service UI.
* **Transparency** - CPU, GPU and network utilization is recorded and made available for analysis in line charts. This is great for optimizing the choice of GPU to avoid under- and over- utilization.
* **History** - Management of artifact catalogs - Making older versions of training code available for scrutiny.
* **Advanced features** - We've already started making use of Vertex AI's Hyperparameter Tuning feature and are considering using Vertex AI Training Pipelines in the future.

All of the above capabilities have proven to be of highly valuable to the team in both time and money. None of them are readily available if we were to move our training to be based on Spot VMs.

To truly achieve feature parity with Vertex AI, the team would need to either outsource the work or shift their focus from machine learning to infrastructure development. The effort involves not only developing the functionality but also maintaining it over time.

The team's ultimate conclusion is that at the expected scale of training operations, the cost of transitioning to Spot VMs would significantly exceed the reductions in running costs.
