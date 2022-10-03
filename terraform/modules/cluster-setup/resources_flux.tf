provider "kubernetes" {
  config_path = "kubeconfig.yaml"
}

provider "kubectl" {
  config_path = "kubeconfig.yaml"
}

data "flux_install" "main" {
  target_path = var.target_path
}

# Generate manifests
data "flux_sync" "main" {
  target_path = var.target_path
  url         = "https://github.com/${var.github_owner}/${var.repository_name}"
}


data "kubectl_file_documents" "install" {
  content = data.flux_install.main.content
}

# Split multi-doc YAML with
# https://registry.terraform.io/providers/gavinbunney/kubectl/latest
data "kubectl_file_documents" "sync" {
  content = data.flux_sync.main.content
}

# Convert documents list to include parsed yaml data
locals {
  install = [for v in data.kubectl_file_documents.install.documents : {
    data : yamldecode(v)
    content : v
    }
  ]
  sync = [ for v in data.kubectl_file_documents.sync.documents : {
      data: yamldecode(v)
      content: v
    }
  ]
}

# Kubernetes
resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].labels,
    ]
  }
}

resource "kubectl_manifest" "install" {
  for_each   = { for v in local.install : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body  = each.value
}

# Apply manifests on the cluster
resource "kubectl_manifest" "sync" {
  for_each   = { for v in local.sync : lower(join("/", compact([v.data.apiVersion, v.data.kind, lookup(v.data.metadata, "namespace", ""), v.data.metadata.name]))) => v.content }
  depends_on = [kubernetes_namespace.flux_system]
  yaml_body = each.value
}