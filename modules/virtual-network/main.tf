locals {
  # Flatten subnets from all vnets into a single map
  subnets_flat = merge([
    for vnet_key, vnet in var.virtual_networks : {
      for subnet in try(vnet.subnets, []) :
      "${vnet_key}-${subnet.name}" => {
        vnet_key            = vnet_key
        subnet              = subnet
        resource_group_name = vnet.resource_group_name
      }
    }
  ]...)
}

resource "azurerm_virtual_network" "this" {
  for_each = var.virtual_networks

  name                    = each.value.name
  address_space           = each.value.address_space
  location                = each.value.location
  resource_group_name     = each.value.resource_group_name
  bgp_community           = try(each.value.bgp_community, null)
  dns_servers             = try(each.value.dns_servers, [])
  edge_zone               = try(each.value.edge_zone, null)
  flow_timeout_in_minutes = try(each.value.flow_timeout_in_minutes, null)
  tags                    = try(each.value.tags, {})

  dynamic "ddos_protection_plan" {
    for_each = try(each.value.ddos_protection_plan, null) != null ? [each.value.ddos_protection_plan] : []
    content {
      id     = ddos_protection_plan.value.id
      enable = ddos_protection_plan.value.enable
    }
  }

  dynamic "encryption" {
    for_each = try(each.value.encryption, null) != null ? [each.value.encryption] : []
    content {
      enforcement = encryption.value.enforcement
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each = local.subnets_flat

  name                                          = each.value.subnet.name
  resource_group_name                           = each.value.resource_group_name
  virtual_network_name                          = azurerm_virtual_network.this[each.value.vnet_key].name
  address_prefixes                              = each.value.subnet.address_prefixes
  private_endpoint_network_policies             = try(each.value.subnet.private_endpoint_network_policies, null)
  private_link_service_network_policies_enabled = try(each.value.subnet.private_link_service_network_policies_enabled, null)
  service_endpoints                             = try(each.value.subnet.service_endpoints, [])
  service_endpoint_policy_ids                   = try(each.value.subnet.service_endpoint_policy_ids, null)

  dynamic "delegation" {
    for_each = try(each.value.subnet.delegations, [])
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = try(delegation.value.service_delegation.actions, null)
      }
    }
  }
}
