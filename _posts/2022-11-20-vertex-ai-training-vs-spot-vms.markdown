---
layout: post
title:  "Google Cloud Platform Vertex AI Training vs. Rolling Your Own on Spot VMs"
date:   2023-11-20 18:10:00 +0300
categories: cloud google google-cloud-platform vertex-ai machine-learning vertex-ai-training
---

---

**TL;DR** - If your Vertex AI Training spending is in the lower thousands of dollars, you're fine. If it's growing towards $10K or more it might be time to re-engineer for training using Spot VMs. Likewise for AWS SageMaker and Azure ML.

---


Google Cloud Platform's Vertex AI Training service is a great option to get started with machine learning model training in the cloud. Customers can upload their training code to cloud storage, run them in one or more disposable containers to quickly and cheaply produce trained model artifacts. The two main benefits of the service are **ease-of-use** and **charges based on usage**.

Ease-of-use is provided through a simplified MLOps-oriented workflow. The steps are: 
1. Training code is first packaged either as a Python software distribution or in a Linux container image. 
2. Packages are then uploaded to Google Cloud Storage or Google Artifact Registry respectively. 
3. Finally, a single Google Cloud CLI/SDK command kicks off the training process. 
4. The code then runs in containers on Kubernetes environments that are fully managed by Google.




