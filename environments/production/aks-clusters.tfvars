# Production Environment - AKS Clusters Configuration

# AKS Clusters
aks_clusters = {
  "main" = {
    name                = "prod-aks"
    location            = "East US"
    resource_group_name = "prod-rg"
    dns_prefix          = "prod-aks"
    kubernetes_version  = "1.27.0"
    default_node_pool = {
      name                = "default"
      node_count          = 3
      vm_size             = "Standard_D4_v2"
      enable_auto_scaling = true
      min_count           = 3
      max_count           = 10
    }
    tags = {
      Purpose = "Production Kubernetes cluster with auto-scaling"
    }
  }
}
