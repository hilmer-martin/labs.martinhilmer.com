module "run_rke_cluster_with_flux" {
    source = "../"
    hcloud_secret          = ""
    hcloud_ssh_key_public  = "" 
    hcloud_ssh_key_private = "" 
    instance_count         = 2
    instance_prefix        = "rke-cluster"
    instance_type          = "cx31"
    instance_zones         = ["nbg1", "hel1"]
    lb_location            = "nbg1"
    lb_name                = "rke-cluster-lb"
    lb_type                = "lb11"
    private_network_name   = "kubernetes-internal"
    repository_name = ""
    github_owner = ""
}