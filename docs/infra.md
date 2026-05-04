# Project Description

The aim of this is to learn about deploying web apps on kubernetes.

Simple web app with database backend.
The aim of this web app is to store information about requirements for different scout badges.
Users will be able to search for an activity to see which scout badges they will be eligible for.

Initially there will be no user authentication.

## Environments
Initially a dev environment pilot will be deployed.
This differs from a prod deployment because the database will be publicly accessible (to enable developers to integrate it with their tools).  A bastion host will provide access to the kubernetes cluster and database.  The EC2 ami would need to be built/patched on a public subnet (with internet access for tool installation).

## Database
Initially postgres RDS on AWS will be used.  Later on we may consider switching to postgres deployed on the kubernetes cluster.

## Repo Structure
Mono-repo to keep things simple.  We don't intend to deploy any other infrastructure on the cluster apart from the web-app, so infrastructure code can be kept in the same repo.  If we were thinking of hosting a number of web apps on the same database cluster or kubernetes cluster, we would consider splitting this infrastructure off into a separate repo.

## CI/CD
Github actions.  
For terraform there is a requirement for approval after terraform plan and before deployment - even into dev.  This should reduce the risk of destructive actions such as destroying the database.
For application code - the CI/CD will check if terraform plan is up to date in dev - if yes, then deploy automatically to dev.  Approval will be required for deployment to prod.




