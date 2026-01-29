resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  default_node_pool {
    name                = var.default_node_pool_name
    node_count          = var.default_node_pool_count
    vm_size             = var.default_node_pool_vm_size
    enable_auto_scaling = var.enable_auto_scaling
    min_count           = var.enable_auto_scaling ? var.min_node_count : null
    max_count           = var.enable_auto_scaling ? var.max_node_count : null
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = var.network_plugin
    load_balancer_sku = var.load_balancer_sku
  }
}
