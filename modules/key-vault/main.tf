data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  for_each = var.key_vaults

  name                            = each.value.name
  location                        = each.value.location
  resource_group_name             = each.value.resource_group_name
  tenant_id                       = each.value.tenant_id != null ? each.value.tenant_id : data.azurerm_client_config.current.tenant_id
  sku_name                        = each.value.sku_name
  soft_delete_retention_days      = each.value.soft_delete_retention_days
  purge_protection_enabled        = each.value.purge_protection_enabled
  enabled_for_deployment          = each.value.enabled_for_deployment
  enabled_for_disk_encryption     = each.value.enabled_for_disk_encryption
  enabled_for_template_deployment = each.value.enabled_for_template_deployment
  rbac_authorization_enabled      = each.value.rbac_authorization_enabled
  public_network_access_enabled   = each.value.public_network_access_enabled
  tags                            = each.value.tags

  network_acls {
    bypass                     = each.value.network_acls_bypass
    default_action             = each.value.network_acls_default_action
    ip_rules                   = each.value.network_acls_ip_rules
    virtual_network_subnet_ids = each.value.network_acls_virtual_network_subnet_ids
  }

  # IMPORTANT: When rbac_authorization_enabled is true, access policies are ignored by Azure Key Vault.
  # Access policies will still be created in Terraform state but will have no effect.
  # It is recommended to set create_default_access_policy = false and additional_access_policies = []
  # when using RBAC authorization.

  # Default access policy for current user/service principal (optional)
  dynamic "access_policy" {
    for_each = each.value.create_default_access_policy && !each.value.rbac_authorization_enabled ? [1] : []
    content {
      tenant_id               = each.value.tenant_id != null ? each.value.tenant_id : data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      key_permissions         = each.value.key_permissions
      secret_permissions      = each.value.secret_permissions
      certificate_permissions = each.value.certificate_permissions
      storage_permissions     = each.value.storage_permissions
    }
  }

  # Additional access policies
  dynamic "access_policy" {
    for_each = !each.value.rbac_authorization_enabled ? each.value.additional_access_policies : []
    content {
      tenant_id               = access_policy.value.tenant_id
      object_id               = access_policy.value.object_id
      application_id          = access_policy.value.application_id
      key_permissions         = access_policy.value.key_permissions
      secret_permissions      = access_policy.value.secret_permissions
      certificate_permissions = access_policy.value.certificate_permissions
      storage_permissions     = access_policy.value.storage_permissions
    }
  }

  # Contact blocks for certificate notifications
  dynamic "contact" {
    for_each = each.value.contacts
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }
}
