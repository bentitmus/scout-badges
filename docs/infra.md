# Project Description

The aim of this is to learn about deploying web apps on kubernetes.

Simple web app with database backend.
The aim of this web app is to store information about requirements for different scout badges.
Users will be able to search for an activity to see which scout badges they will be eligible for.

Initially there will be no user authentication.

## Repo Structure
Mono-repo to keep things simple.  We don't intend to deploy any other infrastructure on the cluster apart from the web-app, so infrastructure code can be kept in the same repo.  If we were thinking of hosting a number of web apps on the same database cluster or kubernetes cluster, we would consider splitting this infrastructure off into a separate repo.

## Environments
Initially a dev environment pilot will be deployed.
This differs from a prod deployment because the database will be publicly accessible (to enable developers to integrate it with their tools).  In prod a bastion host can optionally be provisioned for accessing the database.  Ideally it should only be spun up during troubleshooting as it could be a security liability if it is always present.  It is not clear currently whether there will be much value in developers connecting to the EKS worker nodes in dev - as AWS provides a public endpoint for the control plane.  The EC2 ami for the bastion would need to be built/patched on a public subnet (with internet access for tool installation).  In dev there will be a permanent bastion host present with useful tools.  

## Database
Initially postgres RDS on AWS will be used.  Later on we may consider switching to postgres deployed on the kubernetes cluster.

## EKS Cluster
EKS has several features that are managed by aws - which will simplify deployment and help with learning.  A good description of different options for configuration of EKS is here: https://aws.amazon.com/blogs/containers/de-mystifying-cluster-networking-for-amazon-eks-worker-nodes/

https://docs.aws.amazon.com/eks/latest/best-practices/subnets.html
https://aws.amazon.com/blogs/containers/expose-amazon-eks-pods-through-cross-account-load-balancer/

This describes a setup of cicd which would enable only private EKS endpoint: https://medium.com/@karimfadl/ci-cd-deployment-of-app-to-eks-using-github-actions-and-bastion-runner-f8b967a61646. 
We chose not to do this because this is likely to require a longer-lived bastion (instead of just being spun up during troubleshooting) - which can present security risks.

Terraform template: https://github.com/hashicorp-education/learn-terraform-provision-eks-cluster
https://platformwale.blog/2023/07/15/create-amazon-eks-cluster-within-its-vpc-using-terraform/

As a starting point will try aws-managed EC2s, using both public and private EKS API endpoints.   

## CI/CD
Github actions with github-hosted runners.  This is considered for practicality.  It is interesting - because the github-hosting of runners requires either a public EKS endpoint or working through a bastion host which is publicly accessible to the internet - for interacting with the EKS control plane.  
For terraform there is a requirement for approval after terraform plan and before deployment - even into dev.  This should reduce the risk of destructive actions such as destroying the database.
For application code - the CI/CD will check if terraform plan is up to date in dev - if yes, then deploy automatically to dev.  Approval will be required for deployment to prod.

## Networking
For the initial dev deployment, the components will all be placed in 2 public subnets with access to an internet gateway.

For the prod deployment, there will be 2 public and 2 private subnets.  The application load balancers will be in the public subnets.  The EKS worker nodes and database will be in the private subnets as well as the bastion host (only spun up for troubleshooting purposes).  
