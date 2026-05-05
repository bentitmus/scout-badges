# Project Description

The aim of this is to learn about deploying web apps on kubernetes.

Simple web app with database backend.
The aim of this web app is to store information about requirements for different scout badges.
Users will be able to search for an activity to see which scout badges they will be eligible for.

Initially there will be no user authentication.

## Environments
Initially a dev environment pilot will be deployed.
This differs from a prod deployment because the database will be publicly accessible (to enable developers to integrate it with their tools).  In prod a bastion host can optionally be provisioned for accessing the database and eks worker nodes.  Ideally it should only be spun up during troubleshooting as it could be a security liability if it is always present.  The EC2 ami for the bastion would need to be built/patched on a public subnet (with internet access for tool installation).  In dev there will be a permanent bastion host present with useful tools.  

## Database
Initially postgres RDS on AWS will be used.  Later on we may consider switching to postgres deployed on the kubernetes cluster.

## Repo Structure
Mono-repo to keep things simple.  We don't intend to deploy any other infrastructure on the cluster apart from the web-app, so infrastructure code can be kept in the same repo.  If we were thinking of hosting a number of web apps on the same database cluster or kubernetes cluster, we would consider splitting this infrastructure off into a separate repo.

## CI/CD
Github actions.  This is considered for practicality.  
For terraform there is a requirement for approval after terraform plan and before deployment - even into dev.  This should reduce the risk of destructive actions such as destroying the database.
For application code - the CI/CD will check if terraform plan is up to date in dev - if yes, then deploy automatically to dev.  Approval will be required for deployment to prod.

## EKS Cluster
EKS has several features that are managed by AWS - which will simplify deployment and help with learning.  A good description of different options for configuration of EKS is here: https://aws.amazon.com/blogs/containers/de-mystifying-cluster-networking-for-amazon-eks-worker-nodes/

This describes a setup of cicd which would enable only private EKS endpoint: https://medium.com/@karimfadl/ci-cd-deployment-of-app-to-eks-using-github-actions-and-bastion-runner-f8b967a61646. 
We chose not to do this because this is likely to require a longer-lived bastion (instead of just being spun up during troubleshooting) - which can present security risks.




