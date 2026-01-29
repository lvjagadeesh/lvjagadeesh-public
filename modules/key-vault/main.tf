data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "this" {
  name                            = var.key_vault_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  tenant_id                       = var.tenant_id != null ? var.tenant_id : data.azurerm_client_config.current.tenant_id
  sku_name                        = var.sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  purge_protection_enabled        = var.purge_protection_enabled
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  rbac_authorization_enabled      = var.rbac_authorization_enabled
  public_network_access_enabled   = var.public_network_access_enabled
  tags                            = var.tags

  network_acls {
    bypass                     = var.network_acls_bypass
    default_action             = var.network_acls_default_action
    ip_rules                   = var.network_acls_ip_rules
    virtual_network_subnet_ids = var.network_acls_virtual_network_subnet_ids
  }

  # IMPORTANT: When rbac_authorization_enabled is true, access policies are ignored by Azure Key Vault.
  # Access policies will still be created in Terraform state but will have no effect.
  # It is recommended to set create_default_access_policy = false and additional_access_policies = []
  # when using RBAC authorization.

  # Default access policy for current user/service principal (optional)
  dynamic "access_policy" {
    for_each = var.create_default_access_policy && !var.rbac_authorization_enabled ? [1] : []
    content {
      tenant_id               = var.tenant_id != null ? var.tenant_id : data.azurerm_client_config.current.tenant_id
      object_id               = data.azurerm_client_config.current.object_id
      key_permissions         = var.key_permissions
      secret_permissions      = var.secret_permissions
      certificate_permissions = var.certificate_permissions
      storage_permissions     = var.storage_permissions
    }
  }

  # Additional access policies
  dynamic "access_policy" {
    for_each = !var.rbac_authorization_enabled ? var.additional_access_policies : []
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
    for_each = var.contacts
    content {
      email = contact.value.email
      name  = contact.value.name
      phone = contact.value.phone
    }
  }
}
