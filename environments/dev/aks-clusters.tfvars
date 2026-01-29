# Development Environment - AKS Clusters Configuration

# AKS Clusters
aks_clusters = {
  "main" = {
    name                = "dev-aks"
    location            = "East US"
    resource_group_name = "dev-rg"
    dns_prefix          = "dev-aks"
    kubernetes_version  = "1.27.0"
    default_node_pool = {
      name       = "default"
      node_count = 1
      vm_size    = "Standard_B2s"
    }
    tags = {
      Purpose = "Development Kubernetes cluster"
    }
  }
}
