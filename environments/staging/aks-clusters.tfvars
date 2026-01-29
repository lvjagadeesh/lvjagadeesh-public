# Staging Environment - AKS Clusters Configuration

# AKS Clusters
aks_clusters = {
  "main" = {
    name                = "staging-aks"
    location            = "East US"
    resource_group_name = "staging-rg"
    dns_prefix          = "staging-aks"
    kubernetes_version  = "1.27.0"
    default_node_pool = {
      name       = "default"
      node_count = 2
      vm_size    = "Standard_D2_v2"
    }
    tags = {
      Purpose = "Staging Kubernetes cluster"
    }
  }
}
