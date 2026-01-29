resource "azurerm_service_plan" "this" {
  for_each = var.app_service_plans

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name

  app_service_environment_id   = each.value.app_service_environment_id
  maximum_elastic_worker_count = each.value.maximum_elastic_worker_count
  worker_count                 = each.value.worker_count
  per_site_scaling_enabled     = each.value.per_site_scaling_enabled
  zone_balancing_enabled       = each.value.zone_balancing_enabled

  tags = each.value.tags

  dynamic "timeouts" {
    for_each = each.value.timeouts != null ? [each.value.timeouts] : []
    content {
      create = try(timeouts.value.create, "60m")
      read   = try(timeouts.value.read, "5m")
      update = try(timeouts.value.update, "60m")
      delete = try(timeouts.value.delete, "60m")
    }
  }
}
