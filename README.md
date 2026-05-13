# Scout Badges

This is a test project to learn about deploying a web app on kubernetes.  
The aim of this web app is to store information about requirements for different scout badges. Users will be able to search for an activity (e.g. Canoeing, Cooking) to see which scout badges they will be eligible for.  Initially there will be no user authentication.

##Repo Structure

Mono-repo to keep things simple. We don't intend to deploy any other infrastructure on the cluster apart from the web-app, so infrastructure code can be kept in the same repo. If we were thinking of hosting a number of web apps on the same database cluster or kubernetes cluster, we would consider splitting this infrastructure off into a separate repo.  

## Environments

Initially a dev environment pilot will be deployed. In dev we will deploy everything into 2 public subnets (across different availability zones).  This is so that developers can connect directly to the database (which makes the development cycle smoother and allows the integration of tools like squitch).  It is not clear whether developers will need to connect directly to EKS worker nodes - as AWS already provides a public endpoint for the control plane - but for simplicity, in dev we will put the worker nodes in the public subnets.  We will use both the public and private EKS endpoints (https://docs.aws.amazon.com/eks/latest/best-practices/subnets.html).  A public EKS endpoint is necessary - because we want to use publicly hosted github runners for deployment (if you only have private EKS endpoints, you would need to find a different way to deploy - eg self-hosted runners or via the bastion running kubectl commands).  In dev we can leave the bastion present permanently, but in prod we only want one to be spun up during troubleshooting.  

### Dev 
![Dev](./docs/scout-badges-dev.drawio.svg)



### Prod
![Prod](./docs/scout-badges-prod.drawio.svg)

## Database
Initially postgres RDS on AWS will be used. Later on we may consider switching to postgres deployed on the kubernetes cluster.

