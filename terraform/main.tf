terraform {
  required_version = ">= 0.13.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.10.0"
    }
  }
}

provider "kubernetes" {
    host = module.nodes_setup.kubernetes_api_server_url
    client_certificate = module.node_setup.kubernetes_client_cert
    client_key = module.node_setup.kubernetes_client_key
    cluster_ca_certificate = module.node_setup.kubernetes_ca_crt 
  }
provider "kubectl" {
  host = module.nodes_setup.kubernetes_api_server_url
  client_certificate = module.node_setup.kubernetes_client_cert
  client_key = module.node_setup.kubernetes_client_key
  cluster_ca_certificate = module.node_setup.kubernetes_ca_crt
}

module "nodes_setup" {
  source = "./modules/nodes-setup"
  hcloud_secret          = var.hcloud_secret
  hcloud_ssh_key_public  = var.hcloud_ssh_key_public 
  hcloud_ssh_key_private = var.hcloud_ssh_key_private
  instance_count         = var.instance_count
  instance_prefix        = var.instance_prefix
  instance_type          = var.instance_type
  instance_zones         = var.instance_zones
  lb_location            = var.lb_location
  lb_name                = var.lb_name
  lb_type                = var.lb_type
  private_network_name   = var.private_network_name
}

module "cluster_setup" {
  source = "./modules/cluster-setup"  
  repository_name = var.repository_name
  github_owner = var.github_owner
}