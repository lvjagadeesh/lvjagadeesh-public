cluster_name               = "example-aks"
location                   = "East US"
resource_group_name        = "example-rg"
dns_prefix                 = "example-aks"
kubernetes_version         = "1.27.0"
default_node_pool_name     = "default"
default_node_pool_count    = 3
default_node_pool_vm_size  = "Standard_D2_v2"
enable_auto_scaling        = true
min_node_count             = 1
max_node_count             = 5
network_plugin             = "azure"
load_balancer_sku          = "standard"
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
