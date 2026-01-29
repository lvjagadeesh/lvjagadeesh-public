resource "azurerm_virtual_network" "this" {
  name                    = var.vnet_name
  address_space           = var.address_space
  location                = var.location
  resource_group_name     = var.resource_group_name
  bgp_community           = var.bgp_community
  dns_servers             = var.dns_servers
  edge_zone               = var.edge_zone
  flow_timeout_in_minutes = var.flow_timeout_in_minutes
  tags                    = var.tags

  dynamic "ddos_protection_plan" {
    for_each = var.ddos_protection_plan != null ? [var.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = var.encryption != null ? [var.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                                          = each.value.name
  resource_group_name                           = var.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.this.name
  address_prefixes                              = each.value.address_prefixes
  private_endpoint_network_policies             = try(each.value.private_endpoint_network_policies, null)
  private_link_service_network_policies_enabled = try(each.value.private_link_service_network_policies_enabled, null)
  service_endpoints                             = try(each.value.service_endpoints, [])
  service_endpoint_policy_ids                   = try(each.value.service_endpoint_policy_ids, null)

  dynamic "delegation" {
    for_each = try(each.value.delegations, [])
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = try(delegation.value.service_delegation.actions, null)
      }
    }
  }
}
