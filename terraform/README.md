# Terraform module for running Kubernetes with Flux on Hetzner Cloud

This module is separated into submodules for better reuse.

## nodes-setup
This module creates rke server, load balancer, etc. on hcloud. This module currently relies on 
source code from https://github.com/edgefarm/terraform-rke-hcloud

## cluster-setup
This module connects to the rke cluster, installs and configures flux to sync with configured fleet-repo. The code of the module is copied and modified from flux provider examples [here](https://github.com/fluxcd/terraform-provider-flux).

## dns-setup (not implemented yet)
This module sets up DNS entries to previously created cluster for domain. The domain nameserver must be configured to use Hetzner nameserver (see https://docs.hetzner.com/de/dns-console/dns/general/authoritative-name-servers/)

## Getting Started
1. Go to examples folder
2. fill out hcloud_secret, repository_name, github_owner
2. run `terraform init`
3. run `terraform plan`
4. run `terraform apply`