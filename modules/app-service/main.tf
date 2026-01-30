resource "azurerm_linux_web_app" "this" {
  for_each = var.app_services

  # Required arguments
  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  service_plan_id     = each.value.service_plan_id

  # Core optional arguments
  enabled                                        = each.value.enabled
  app_settings                                   = each.value.app_settings
  tags                                           = each.value.tags
  public_network_access_enabled                  = each.value.public_network_access_enabled
  client_affinity_enabled                        = each.value.client_affinity_enabled
  client_certificate_enabled                     = each.value.client_certificate_enabled
  client_certificate_mode                        = each.value.client_certificate_mode
  client_certificate_exclusion_paths             = each.value.client_certificate_exclusion_paths
  https_only                                     = each.value.https_only
  virtual_network_subnet_id                      = each.value.virtual_network_subnet_id
  key_vault_reference_identity_id                = each.value.key_vault_reference_identity_id
  zip_deploy_file                                = each.value.zip_deploy_file
  webdeploy_publish_basic_authentication_enabled = each.value.webdeploy_publish_basic_authentication_enabled
  ftp_publish_basic_authentication_enabled       = each.value.ftp_publish_basic_authentication_enabled

  # ========================================
  # SITE_CONFIG BLOCK
  # ========================================
  site_config {
    # Core site_config attributes
    always_on                                     = each.value.always_on
    api_definition_url                            = each.value.api_definition_url
    api_management_api_id                         = each.value.api_management_api_id
    app_command_line                              = each.value.app_command_line
    container_registry_use_managed_identity       = each.value.container_registry_use_managed_identity
    container_registry_managed_identity_client_id = each.value.container_registry_managed_identity_client_id
    default_documents                             = each.value.default_documents
    ftps_state                                    = each.value.ftps_state
    health_check_path                             = each.value.health_check_path
    health_check_eviction_time_in_min             = each.value.health_check_eviction_time_in_min
    http2_enabled                                 = each.value.http2_enabled
    ip_restriction_default_action                 = each.value.ip_restriction_default_action
    load_balancing_mode                           = each.value.load_balancing_mode
    local_mysql_enabled                           = each.value.local_mysql_enabled
    managed_pipeline_mode                         = each.value.managed_pipeline_mode
    minimum_tls_version                           = each.value.minimum_tls_version
    remote_debugging_enabled                      = each.value.remote_debugging_enabled
    remote_debugging_version                      = each.value.remote_debugging_version
    scm_ip_restriction_default_action             = each.value.scm_ip_restriction_default_action
    scm_minimum_tls_version                       = each.value.scm_minimum_tls_version
    scm_use_main_ip_restriction                   = each.value.scm_use_main_ip_restriction
    use_32_bit_worker                             = each.value.use_32_bit_worker
    vnet_route_all_enabled                        = each.value.vnet_route_all_enabled
    websockets_enabled                            = each.value.websockets_enabled
    worker_count                                  = each.value.worker_count

    # Application stack configuration
    dynamic "application_stack" {
      for_each = (
        each.value.docker_image_name != null ||
        each.value.dotnet_version != null ||
        each.value.go_version != null ||
        each.value.java_version != null ||
        each.value.node_version != null ||
        each.value.php_version != null ||
        each.value.python_version != null ||
        each.value.ruby_version != null
      ) ? [1] : []

      content {
        docker_image_name        = each.value.docker_image_name
        docker_registry_url      = each.value.docker_image_name != null ? each.value.docker_registry_url : null
        docker_registry_username = each.value.docker_registry_username
        docker_registry_password = each.value.docker_registry_password
        dotnet_version           = each.value.dotnet_version
        go_version               = each.value.go_version
        java_server              = each.value.java_server
        java_server_version      = each.value.java_server_version
        java_version             = each.value.java_version
        node_version             = each.value.node_version
        php_version              = each.value.php_version
        python_version           = each.value.python_version
        ruby_version             = each.value.ruby_version
      }
    }

    # Auto-heal settings
    dynamic "auto_heal_setting" {
      for_each = each.value.auto_heal_setting != null ? [each.value.auto_heal_setting] : []

      content {
        action {
          action_type                    = auto_heal_setting.value.action.action_type
          minimum_process_execution_time = auto_heal_setting.value.action.minimum_process_execution_time
        }

        trigger {
          dynamic "requests" {
            for_each = auto_heal_setting.value.trigger.requests != null ? [auto_heal_setting.value.trigger.requests] : []

            content {
              count    = requests.value.count
              interval = requests.value.interval
            }
          }

          dynamic "slow_request" {
            for_each = auto_heal_setting.value.trigger.slow_request != null ? [auto_heal_setting.value.trigger.slow_request] : []

            content {
              count      = slow_request.value.count
              interval   = slow_request.value.interval
              time_taken = slow_request.value.time_taken
            }
          }

          dynamic "slow_request_with_path" {
            for_each = auto_heal_setting.value.trigger.slow_request_with_path != null ? auto_heal_setting.value.trigger.slow_request_with_path : []

            content {
              count      = slow_request_with_path.value.count
              interval   = slow_request_with_path.value.interval
              time_taken = slow_request_with_path.value.time_taken
              path       = slow_request_with_path.value.path
            }
          }

          dynamic "status_code" {
            for_each = auto_heal_setting.value.trigger.status_code != null ? auto_heal_setting.value.trigger.status_code : []

            content {
              count             = status_code.value.count
              interval          = status_code.value.interval
              status_code_range = status_code.value.status_code_range
              path              = status_code.value.path
              sub_status        = status_code.value.sub_status
              win32_status_code = status_code.value.win32_status_code
            }
          }
        }
      }
    }

    # CORS configuration
    dynamic "cors" {
      for_each = length(each.value.cors_allowed_origins) > 0 ? [1] : []

      content {
        allowed_origins     = each.value.cors_allowed_origins
        support_credentials = each.value.cors_support_credentials
      }
    }

    # IP restrictions
    dynamic "ip_restriction" {
      for_each = each.value.ip_restriction

      content {
        action                    = ip_restriction.value.action
        ip_address                = ip_restriction.value.ip_address
        name                      = ip_restriction.value.name
        priority                  = ip_restriction.value.priority
        service_tag               = ip_restriction.value.service_tag
        virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id

        dynamic "headers" {
          for_each = ip_restriction.value.headers != null ? [ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }

    # SCM IP restrictions
    dynamic "scm_ip_restriction" {
      for_each = each.value.scm_ip_restriction

      content {
        action                    = scm_ip_restriction.value.action
        ip_address                = scm_ip_restriction.value.ip_address
        name                      = scm_ip_restriction.value.name
        priority                  = scm_ip_restriction.value.priority
        service_tag               = scm_ip_restriction.value.service_tag
        virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id

        dynamic "headers" {
          for_each = scm_ip_restriction.value.headers != null ? [scm_ip_restriction.value.headers] : []

          content {
            x_azure_fdid      = headers.value.x_azure_fdid
            x_fd_health_probe = headers.value.x_fd_health_probe
            x_forwarded_for   = headers.value.x_forwarded_for
            x_forwarded_host  = headers.value.x_forwarded_host
          }
        }
      }
    }
  }

  # ========================================
  # AUTH_SETTINGS BLOCK
  # ========================================
  dynamic "auth_settings" {
    for_each = each.value.auth_settings != null ? [each.value.auth_settings] : []

    content {
      enabled                        = auth_settings.value.enabled
      additional_login_parameters    = auth_settings.value.additional_login_parameters
      allowed_external_redirect_urls = auth_settings.value.allowed_external_redirect_urls
      default_provider               = auth_settings.value.default_provider
      issuer                         = auth_settings.value.issuer
      runtime_version                = auth_settings.value.runtime_version
      token_refresh_extension_hours  = auth_settings.value.token_refresh_extension_hours
      token_store_enabled            = auth_settings.value.token_store_enabled
      unauthenticated_client_action  = auth_settings.value.unauthenticated_client_action

      dynamic "active_directory" {
        for_each = auth_settings.value.active_directory != null ? [auth_settings.value.active_directory] : []

        content {
          client_id                  = active_directory.value.client_id
          client_secret              = active_directory.value.client_secret
          client_secret_setting_name = active_directory.value.client_secret_setting_name
          allowed_audiences          = active_directory.value.allowed_audiences
        }
      }

      dynamic "facebook" {
        for_each = auth_settings.value.facebook != null ? [auth_settings.value.facebook] : []

        content {
          app_id                  = facebook.value.app_id
          app_secret              = facebook.value.app_secret
          app_secret_setting_name = facebook.value.app_secret_setting_name
          oauth_scopes            = facebook.value.oauth_scopes
        }
      }

      dynamic "github" {
        for_each = auth_settings.value.github != null ? [auth_settings.value.github] : []

        content {
          client_id                  = github.value.client_id
          client_secret              = github.value.client_secret
          client_secret_setting_name = github.value.client_secret_setting_name
          oauth_scopes               = github.value.oauth_scopes
        }
      }

      dynamic "google" {
        for_each = auth_settings.value.google != null ? [auth_settings.value.google] : []

        content {
          client_id                  = google.value.client_id
          client_secret              = google.value.client_secret
          client_secret_setting_name = google.value.client_secret_setting_name
          oauth_scopes               = google.value.oauth_scopes
        }
      }

      dynamic "microsoft" {
        for_each = auth_settings.value.microsoft != null ? [auth_settings.value.microsoft] : []

        content {
          client_id                  = microsoft.value.client_id
          client_secret              = microsoft.value.client_secret
          client_secret_setting_name = microsoft.value.client_secret_setting_name
          oauth_scopes               = microsoft.value.oauth_scopes
        }
      }

      dynamic "twitter" {
        for_each = auth_settings.value.twitter != null ? [auth_settings.value.twitter] : []

        content {
          consumer_key                 = twitter.value.consumer_key
          consumer_secret              = twitter.value.consumer_secret
          consumer_secret_setting_name = twitter.value.consumer_secret_setting_name
        }
      }
    }
  }

  # ========================================
  # AUTH_SETTINGS_V2 BLOCK
  # ========================================
  dynamic "auth_settings_v2" {
    for_each = each.value.auth_settings_v2 != null ? [each.value.auth_settings_v2] : []

    content {
      auth_enabled                            = auth_settings_v2.value.auth_enabled
      runtime_version                         = auth_settings_v2.value.runtime_version
      config_file_path                        = auth_settings_v2.value.config_file_path
      require_authentication                  = auth_settings_v2.value.require_authentication
      unauthenticated_action                  = auth_settings_v2.value.unauthenticated_action
      default_provider                        = auth_settings_v2.value.default_provider
      excluded_paths                          = auth_settings_v2.value.excluded_paths
      require_https                           = auth_settings_v2.value.require_https
      http_route_api_prefix                   = auth_settings_v2.value.http_route_api_prefix
      forward_proxy_convention                = auth_settings_v2.value.forward_proxy_convention
      forward_proxy_custom_host_header_name   = auth_settings_v2.value.forward_proxy_custom_host_header_name
      forward_proxy_custom_scheme_header_name = auth_settings_v2.value.forward_proxy_custom_scheme_header_name

      dynamic "apple_v2" {
        for_each = auth_settings_v2.value.apple_v2 != null ? [auth_settings_v2.value.apple_v2] : []

        content {
          client_id                  = apple_v2.value.client_id
          client_secret_setting_name = apple_v2.value.client_secret_setting_name
          login_scopes               = apple_v2.value.login_scopes
        }
      }

      dynamic "active_directory_v2" {
        for_each = auth_settings_v2.value.active_directory_v2 != null ? [auth_settings_v2.value.active_directory_v2] : []

        content {
          client_id                            = active_directory_v2.value.client_id
          tenant_auth_endpoint                 = active_directory_v2.value.tenant_auth_endpoint
          client_secret_setting_name           = active_directory_v2.value.client_secret_setting_name
          client_secret_certificate_thumbprint = active_directory_v2.value.client_secret_certificate_thumbprint
          jwt_allowed_groups                   = active_directory_v2.value.jwt_allowed_groups
          jwt_allowed_client_applications      = active_directory_v2.value.jwt_allowed_client_applications
          www_authentication_disabled          = active_directory_v2.value.www_authentication_disabled
          allowed_groups                       = active_directory_v2.value.allowed_groups
          allowed_identities                   = active_directory_v2.value.allowed_identities
          allowed_applications                 = active_directory_v2.value.allowed_applications
          login_parameters                     = active_directory_v2.value.login_parameters
          allowed_audiences                    = active_directory_v2.value.allowed_audiences
        }
      }

      dynamic "azure_static_web_app_v2" {
        for_each = auth_settings_v2.value.azure_static_web_app_v2 != null ? [auth_settings_v2.value.azure_static_web_app_v2] : []

        content {
          client_id = azure_static_web_app_v2.value.client_id
        }
      }

      dynamic "custom_oidc_v2" {
        for_each = auth_settings_v2.value.custom_oidc_v2 != null ? auth_settings_v2.value.custom_oidc_v2 : []

        content {
          name                          = custom_oidc_v2.value.name
          client_id                     = custom_oidc_v2.value.client_id
          openid_configuration_endpoint = custom_oidc_v2.value.openid_configuration_endpoint
          name_claim_type               = custom_oidc_v2.value.name_claim_type
          scopes                        = custom_oidc_v2.value.scopes
          client_credential_method      = custom_oidc_v2.value.client_credential_method
          client_secret_setting_name    = custom_oidc_v2.value.client_secret_setting_name
          authorisation_endpoint        = custom_oidc_v2.value.authorisation_endpoint
          token_endpoint                = custom_oidc_v2.value.token_endpoint
          issuer_endpoint               = custom_oidc_v2.value.issuer_endpoint
          certification_uri             = custom_oidc_v2.value.certification_uri
        }
      }

      dynamic "facebook_v2" {
        for_each = auth_settings_v2.value.facebook_v2 != null ? [auth_settings_v2.value.facebook_v2] : []

        content {
          app_id                  = facebook_v2.value.app_id
          app_secret_setting_name = facebook_v2.value.app_secret_setting_name
          graph_api_version       = facebook_v2.value.graph_api_version
          login_scopes            = facebook_v2.value.login_scopes
        }
      }

      dynamic "github_v2" {
        for_each = auth_settings_v2.value.github_v2 != null ? [auth_settings_v2.value.github_v2] : []

        content {
          client_id                  = github_v2.value.client_id
          client_secret_setting_name = github_v2.value.client_secret_setting_name
          login_scopes               = github_v2.value.login_scopes
        }
      }

      dynamic "google_v2" {
        for_each = auth_settings_v2.value.google_v2 != null ? [auth_settings_v2.value.google_v2] : []

        content {
          client_id                  = google_v2.value.client_id
          client_secret_setting_name = google_v2.value.client_secret_setting_name
          allowed_audiences          = google_v2.value.allowed_audiences
          login_scopes               = google_v2.value.login_scopes
        }
      }

      dynamic "microsoft_v2" {
        for_each = auth_settings_v2.value.microsoft_v2 != null ? [auth_settings_v2.value.microsoft_v2] : []

        content {
          client_id                  = microsoft_v2.value.client_id
          client_secret_setting_name = microsoft_v2.value.client_secret_setting_name
          allowed_audiences          = microsoft_v2.value.allowed_audiences
          login_scopes               = microsoft_v2.value.login_scopes
        }
      }

      dynamic "twitter_v2" {
        for_each = auth_settings_v2.value.twitter_v2 != null ? [auth_settings_v2.value.twitter_v2] : []

        content {
          consumer_key                 = twitter_v2.value.consumer_key
          consumer_secret_setting_name = twitter_v2.value.consumer_secret_setting_name
        }
      }

      dynamic "login" {
        for_each = auth_settings_v2.value.login != null ? [auth_settings_v2.value.login] : []

        content {
          logout_endpoint                   = login.value.logout_endpoint
          token_store_enabled               = login.value.token_store_enabled
          token_refresh_extension_time      = login.value.token_refresh_extension_time
          token_store_path                  = login.value.token_store_path
          token_store_sas_setting_name      = login.value.token_store_sas_setting_name
          preserve_url_fragments_for_logins = login.value.preserve_url_fragments_for_logins
          allowed_external_redirect_urls    = login.value.allowed_external_redirect_urls
          cookie_expiration_convention      = login.value.cookie_expiration_convention
          cookie_expiration_time            = login.value.cookie_expiration_time
          validate_nonce                    = login.value.validate_nonce
          nonce_expiration_time             = login.value.nonce_expiration_time
        }
      }
    }
  }

  # ========================================
  # BACKUP BLOCK
  # ========================================
  dynamic "backup" {
    for_each = each.value.backup != null ? [each.value.backup] : []

    content {
      name                = backup.value.name
      storage_account_url = backup.value.storage_account_url
      enabled             = backup.value.enabled

      schedule {
        frequency_interval       = backup.value.schedule.frequency_interval
        frequency_unit           = backup.value.schedule.frequency_unit
        keep_at_least_one_backup = backup.value.schedule.keep_at_least_one_backup
        retention_period_days    = backup.value.schedule.retention_period_days
        start_time               = backup.value.schedule.start_time
      }
    }
  }

  # ========================================
  # CONNECTION_STRING BLOCK
  # ========================================
  dynamic "connection_string" {
    for_each = each.value.connection_strings

    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  # ========================================
  # STORAGE_ACCOUNT BLOCK
  # ========================================
  dynamic "storage_account" {
    for_each = each.value.storage_accounts

    content {
      name         = storage_account.value.name
      type         = storage_account.value.type
      account_name = storage_account.value.account_name
      share_name   = storage_account.value.share_name
      access_key   = storage_account.value.access_key
      mount_path   = storage_account.value.mount_path
    }
  }

  # ========================================
  # LOGS BLOCK
  # ========================================
  dynamic "logs" {
    for_each = each.value.logs != null ? [each.value.logs] : []

    content {
      detailed_error_messages = logs.value.detailed_error_messages
      failed_request_tracing  = logs.value.failed_request_tracing

      dynamic "application_logs" {
        for_each = logs.value.application_logs != null ? [logs.value.application_logs] : []

        content {
          file_system_level = application_logs.value.file_system_level

          dynamic "azure_blob_storage" {
            for_each = application_logs.value.azure_blob_storage != null ? [application_logs.value.azure_blob_storage] : []

            content {
              level             = azure_blob_storage.value.level
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }
        }
      }

      dynamic "http_logs" {
        for_each = logs.value.http_logs != null ? [logs.value.http_logs] : []

        content {
          dynamic "azure_blob_storage" {
            for_each = http_logs.value.azure_blob_storage != null ? [http_logs.value.azure_blob_storage] : []

            content {
              retention_in_days = azure_blob_storage.value.retention_in_days
              sas_url           = azure_blob_storage.value.sas_url
            }
          }

          dynamic "file_system" {
            for_each = http_logs.value.file_system != null ? [http_logs.value.file_system] : []

            content {
              retention_in_days = file_system.value.retention_in_days
              retention_in_mb   = file_system.value.retention_in_mb
            }
          }
        }
      }
    }
  }

  # ========================================
  # IDENTITY BLOCK
  # ========================================
  identity {
    type         = each.value.identity_type
    identity_ids = each.value.identity_type != "SystemAssigned" ? each.value.identity_ids : null
  }

  # ========================================
  # STICKY_SETTINGS BLOCK
  # ========================================
  dynamic "sticky_settings" {
    for_each = each.value.sticky_settings != null ? [each.value.sticky_settings] : []

    content {
      app_setting_names       = sticky_settings.value.app_setting_names
      connection_string_names = sticky_settings.value.connection_string_names
    }
  }
}
