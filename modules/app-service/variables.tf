variable "app_services" {
  description = "(Required) Map of app services to create. Each key is a unique identifier and value contains the app service configuration"
  type = map(object({
    # ========================================
    # REQUIRED ATTRIBUTES
    # ========================================
    name                = string # (Required) Name of the App Service. Must be globally unique (1-60 chars, alphanumeric and hyphens only)
    location            = string # (Required) Azure region where the App Service will be created
    resource_group_name = string # (Required) Name of the resource group where the App Service will be created
    service_plan_id     = string # (Required) ID of the App Service Plan where the App Service will be deployed

    # ========================================
    # CORE OPTIONAL ATTRIBUTES
    # ========================================
    app_settings                                   = optional(map(string), {})
    tags                                           = optional(map(string), {})
    enabled                                        = optional(bool, true)
    public_network_access_enabled                  = optional(bool, true)
    client_affinity_enabled                        = optional(bool, false)
    client_certificate_enabled                     = optional(bool, false)
    client_certificate_mode                        = optional(string, "Required") # Possible values: 'Required', 'Optional', 'OptionalInteractiveUser'
    client_certificate_exclusion_paths             = optional(string)
    https_only                                     = optional(bool, true)
    virtual_network_subnet_id                      = optional(string)
    key_vault_reference_identity_id                = optional(string)
    zip_deploy_file                                = optional(string)
    webdeploy_publish_basic_authentication_enabled = optional(bool, true)
    ftp_publish_basic_authentication_enabled       = optional(bool, true)

    # ========================================
    # SITE_CONFIG ATTRIBUTES
    # ========================================
    always_on             = optional(bool, true)
    api_definition_url    = optional(string)
    api_management_api_id = optional(string)
    app_command_line      = optional(string)
    auto_heal_setting = optional(object({
      action = object({
        action_type                    = string
        minimum_process_execution_time = optional(string)
      })
      trigger = object({
        requests = optional(object({
          count    = number
          interval = string
        }))
        slow_request = optional(object({
          count      = number
          interval   = string
          time_taken = string
        }))
        slow_request_with_path = optional(list(object({
          count      = number
          interval   = string
          time_taken = string
          path       = optional(string)
        })))
        status_code = optional(list(object({
          count             = number
          interval          = string
          status_code_range = string
          path              = optional(string)
          sub_status        = optional(number)
          win32_status_code = optional(number)
        })))
      })
    }))
    container_registry_use_managed_identity       = optional(bool, false)
    container_registry_managed_identity_client_id = optional(string)
    default_documents                             = optional(list(string))
    ftps_state                                    = optional(string, "Disabled") # Possible values: 'AllAllowed', 'FtpsOnly', 'Disabled'
    health_check_path                             = optional(string)
    health_check_eviction_time_in_min             = optional(number) # Must be between 2 and 10
    http2_enabled                                 = optional(bool, false)
    ip_restriction = optional(list(object({
      action                    = optional(string)
      ip_address                = optional(string)
      name                      = optional(string)
      priority                  = optional(number)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
      headers = optional(object({
        x_azure_fdid      = optional(list(string))
        x_fd_health_probe = optional(list(string))
        x_forwarded_for   = optional(list(string))
        x_forwarded_host  = optional(list(string))
      }))
    })), [])
    ip_restriction_default_action = optional(string, "Allow")         # Possible values: 'Allow', 'Deny'
    load_balancing_mode           = optional(string, "LeastRequests") # Possible values: 'LeastRequests', 'WeightedRoundRobin', 'LeastResponseTime', 'WeightedTotalTraffic', 'RequestHash', 'PerSiteRoundRobin'
    local_mysql_enabled           = optional(bool, false)
    managed_pipeline_mode         = optional(string, "Integrated") # Possible values: 'Integrated', 'Classic'
    minimum_tls_version           = optional(string, "1.2")        # Possible values: '1.0', '1.1', '1.2', '1.3'
    remote_debugging_enabled      = optional(bool, false)
    remote_debugging_version      = optional(string) # Possible values: 'VS2017', 'VS2019', 'VS2022'
    scm_ip_restriction = optional(list(object({
      action                    = optional(string)
      ip_address                = optional(string)
      name                      = optional(string)
      priority                  = optional(number)
      service_tag               = optional(string)
      virtual_network_subnet_id = optional(string)
      headers = optional(object({
        x_azure_fdid      = optional(list(string))
        x_fd_health_probe = optional(list(string))
        x_forwarded_for   = optional(list(string))
        x_forwarded_host  = optional(list(string))
      }))
    })), [])
    scm_ip_restriction_default_action = optional(string, "Allow") # Possible values: 'Allow', 'Deny'
    scm_minimum_tls_version           = optional(string, "1.2")   # Possible values: '1.0', '1.1', '1.2', '1.3'
    scm_use_main_ip_restriction       = optional(bool, false)
    use_32_bit_worker                 = optional(bool, false)
    vnet_route_all_enabled            = optional(bool, false)
    websockets_enabled                = optional(bool, false)
    worker_count                      = optional(number) # Must be between 1 and 100

    # ========================================
    # APPLICATION_STACK ATTRIBUTES
    # ========================================
    docker_image_name        = optional(string) # (Optional) Docker image name (e.g., nginx:latest)
    docker_registry_url      = optional(string, "https://index.docker.io")
    docker_registry_username = optional(string)
    docker_registry_password = optional(string)
    dotnet_version           = optional(string) # Possible values: '3.1', '5.0', '6.0', '7.0', '8.0'
    go_version               = optional(string) # Possible values: '1.18', '1.19', '1.20', '1.21'
    java_server              = optional(string) # Possible values: 'JAVA', 'TOMCAT', 'JBOSSEAP'
    java_server_version      = optional(string)
    java_version             = optional(string) # Possible values: '8', '11', '17', '21'
    node_version             = optional(string) # Possible values: '12-lts', '14-lts', '16-lts', '18-lts', '20-lts'
    php_version              = optional(string) # Possible values: '7.4', '8.0', '8.1', '8.2'
    python_version           = optional(string) # Possible values: '3.7', '3.8', '3.9', '3.10', '3.11'
    ruby_version             = optional(string) # Possible values: '2.6', '2.7'

    # ========================================
    # CORS ATTRIBUTES
    # ========================================
    cors_allowed_origins     = optional(list(string), [])
    cors_support_credentials = optional(bool, false)

    # ========================================
    # AUTH_SETTINGS / AUTH_SETTINGS_V2 ATTRIBUTES
    # ========================================
    auth_settings_enabled = optional(bool, false)
    auth_settings = optional(object({
      enabled                        = bool
      additional_login_parameters    = optional(map(string))
      allowed_external_redirect_urls = optional(list(string))
      default_provider               = optional(string)
      issuer                         = optional(string)
      runtime_version                = optional(string)
      token_refresh_extension_hours  = optional(number)
      token_store_enabled            = optional(bool)
      unauthenticated_client_action  = optional(string)
      active_directory = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        allowed_audiences          = optional(list(string))
      }))
      facebook = optional(object({
        app_id                  = string
        app_secret              = optional(string)
        app_secret_setting_name = optional(string)
        oauth_scopes            = optional(list(string))
      }))
      github = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      google = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      microsoft = optional(object({
        client_id                  = string
        client_secret              = optional(string)
        client_secret_setting_name = optional(string)
        oauth_scopes               = optional(list(string))
      }))
      twitter = optional(object({
        consumer_key                 = string
        consumer_secret              = optional(string)
        consumer_secret_setting_name = optional(string)
      }))
    }))
    auth_settings_v2 = optional(object({
      auth_enabled                            = optional(bool)
      runtime_version                         = optional(string)
      config_file_path                        = optional(string)
      require_authentication                  = optional(bool)
      unauthenticated_action                  = optional(string)
      default_provider                        = optional(string)
      excluded_paths                          = optional(list(string))
      require_https                           = optional(bool)
      http_route_api_prefix                   = optional(string)
      forward_proxy_convention                = optional(string)
      forward_proxy_custom_host_header_name   = optional(string)
      forward_proxy_custom_scheme_header_name = optional(string)
      apple_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string))
      }))
      active_directory_v2 = optional(object({
        client_id                            = string
        tenant_auth_endpoint                 = string
        client_secret_setting_name           = optional(string)
        client_secret_certificate_thumbprint = optional(string)
        jwt_allowed_groups                   = optional(list(string))
        jwt_allowed_client_applications      = optional(list(string))
        www_authentication_disabled          = optional(bool)
        allowed_groups                       = optional(list(string))
        allowed_identities                   = optional(list(string))
        allowed_applications                 = optional(list(string))
        login_parameters                     = optional(map(string))
        allowed_audiences                    = optional(list(string))
      }))
      azure_static_web_app_v2 = optional(object({
        client_id = string
      }))
      custom_oidc_v2 = optional(list(object({
        name                          = string
        client_id                     = string
        openid_configuration_endpoint = string
        name_claim_type               = optional(string)
        scopes                        = optional(list(string))
        client_credential_method      = optional(string)
        client_secret_setting_name    = optional(string)
        authorisation_endpoint        = optional(string)
        token_endpoint                = optional(string)
        issuer_endpoint               = optional(string)
        certification_uri             = optional(string)
      })))
      facebook_v2 = optional(object({
        app_id                  = string
        app_secret_setting_name = string
        graph_api_version       = optional(string)
        login_scopes            = optional(list(string))
      }))
      github_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        login_scopes               = optional(list(string))
      }))
      google_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string))
        login_scopes               = optional(list(string))
      }))
      microsoft_v2 = optional(object({
        client_id                  = string
        client_secret_setting_name = string
        allowed_audiences          = optional(list(string))
        login_scopes               = optional(list(string))
      }))
      twitter_v2 = optional(object({
        consumer_key                 = string
        consumer_secret_setting_name = string
      }))
      login = optional(object({
        logout_endpoint                   = optional(string)
        token_store_enabled               = optional(bool)
        token_refresh_extension_time      = optional(number)
        token_store_path                  = optional(string)
        token_store_sas_setting_name      = optional(string)
        preserve_url_fragments_for_logins = optional(bool)
        allowed_external_redirect_urls    = optional(list(string))
        cookie_expiration_convention      = optional(string)
        cookie_expiration_time            = optional(string)
        validate_nonce                    = optional(bool)
        nonce_expiration_time             = optional(string)
      }))
    }))

    # ========================================
    # BACKUP ATTRIBUTES
    # ========================================
    backup = optional(object({
      name                = string
      storage_account_url = string
      enabled             = optional(bool)
      schedule = object({
        frequency_interval       = number
        frequency_unit           = string
        keep_at_least_one_backup = optional(bool)
        retention_period_days    = optional(number)
        start_time               = optional(string)
      })
    }))

    # ========================================
    # CONNECTION_STRING ATTRIBUTES
    # ========================================
    connection_strings = optional(list(object({
      name  = string
      type  = string # Possible values: APIHub, Custom, DocDb, EventHub, MySQL, NotificationHub, PostgreSQL, RedisCache, ServiceBus, SQLAzure, SQLServer
      value = string
    })), [])

    # ========================================
    # STORAGE_ACCOUNT ATTRIBUTES
    # ========================================
    storage_accounts = optional(list(object({
      name         = string
      type         = string # Possible values: AzureBlob, AzureFiles
      account_name = string
      share_name   = string
      access_key   = string
      mount_path   = optional(string)
    })), [])

    # ========================================
    # LOGS ATTRIBUTES
    # ========================================
    logs = optional(object({
      detailed_error_messages = optional(bool)
      failed_request_tracing  = optional(bool)
      application_logs = optional(object({
        file_system_level = optional(string) # Possible values: Off, Verbose, Information, Warning, Error
        azure_blob_storage = optional(object({
          level             = string # Possible values: Off, Verbose, Information, Warning, Error
          retention_in_days = number
          sas_url           = string
        }))
      }))
      http_logs = optional(object({
        azure_blob_storage = optional(object({
          retention_in_days = number
          sas_url           = string
        }))
        file_system = optional(object({
          retention_in_days = number
          retention_in_mb   = number
        }))
      }))
    }))

    # ========================================
    # IDENTITY ATTRIBUTES
    # ========================================
    identity_type = optional(string, "SystemAssigned") # Possible values: 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned'
    identity_ids  = optional(list(string), [])         # Required when identity_type includes UserAssigned

    # ========================================
    # STICKY_SETTINGS ATTRIBUTES
    # ========================================
    sticky_settings = optional(object({
      app_setting_names       = optional(list(string))
      connection_string_names = optional(list(string))
    }))
  }))

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      can(regex("^[a-zA-Z0-9-]{1,60}$", app_service.name))
    ])
    error_message = "All app service names must be 1-60 characters, alphanumeric and hyphens only."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      length(app_service.location) > 0
    ])
    error_message = "All app services must have a location specified."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      length(app_service.resource_group_name) > 0
    ])
    error_message = "All app services must have a resource group name specified."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      length(app_service.service_plan_id) > 0
    ])
    error_message = "All app services must have a service plan ID specified."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["Required", "Optional", "OptionalInteractiveUser"], app_service.client_certificate_mode)
    ])
    error_message = "All app services client_certificate_mode must be one of: Required, Optional, OptionalInteractiveUser."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["AllAllowed", "FtpsOnly", "Disabled"], app_service.ftps_state)
    ])
    error_message = "All app services ftps_state must be one of: AllAllowed, FtpsOnly, Disabled."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.health_check_eviction_time_in_min == null || (app_service.health_check_eviction_time_in_min >= 2 && app_service.health_check_eviction_time_in_min <= 10)
    ])
    error_message = "All app services health_check_eviction_time_in_min must be between 2 and 10."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["Allow", "Deny"], app_service.ip_restriction_default_action)
    ])
    error_message = "All app services ip_restriction_default_action must be one of: Allow, Deny."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["LeastRequests", "WeightedRoundRobin", "LeastResponseTime", "WeightedTotalTraffic", "RequestHash", "PerSiteRoundRobin"], app_service.load_balancing_mode)
    ])
    error_message = "All app services load_balancing_mode must be one of: LeastRequests, WeightedRoundRobin, LeastResponseTime, WeightedTotalTraffic, RequestHash, PerSiteRoundRobin."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["Integrated", "Classic"], app_service.managed_pipeline_mode)
    ])
    error_message = "All app services managed_pipeline_mode must be one of: Integrated, Classic."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["1.0", "1.1", "1.2", "1.3"], app_service.minimum_tls_version)
    ])
    error_message = "All app services minimum_tls_version must be one of: 1.0, 1.1, 1.2, 1.3."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.remote_debugging_version == null || contains(["VS2017", "VS2019", "VS2022"], app_service.remote_debugging_version)
    ])
    error_message = "All app services remote_debugging_version must be one of: VS2017, VS2019, VS2022."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["Allow", "Deny"], app_service.scm_ip_restriction_default_action)
    ])
    error_message = "All app services scm_ip_restriction_default_action must be one of: Allow, Deny."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["1.0", "1.1", "1.2", "1.3"], app_service.scm_minimum_tls_version)
    ])
    error_message = "All app services scm_minimum_tls_version must be one of: 1.0, 1.1, 1.2, 1.3."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.worker_count == null || (app_service.worker_count >= 1 && app_service.worker_count <= 100)
    ])
    error_message = "All app services worker_count must be between 1 and 100."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.dotnet_version == null || contains(["3.1", "5.0", "6.0", "7.0", "8.0"], app_service.dotnet_version)
    ])
    error_message = "All app services dotnet_version must be one of: 3.1, 5.0, 6.0, 7.0, 8.0."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.go_version == null || contains(["1.18", "1.19", "1.20", "1.21"], app_service.go_version)
    ])
    error_message = "All app services go_version must be one of: 1.18, 1.19, 1.20, 1.21."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.java_server == null || contains(["JAVA", "TOMCAT", "JBOSSEAP"], app_service.java_server)
    ])
    error_message = "All app services java_server must be one of: JAVA, TOMCAT, JBOSSEAP."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.java_version == null || contains(["8", "11", "17", "21"], app_service.java_version)
    ])
    error_message = "All app services java_version must be one of: 8, 11, 17, 21."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.node_version == null || contains(["12-lts", "14-lts", "16-lts", "18-lts", "20-lts"], app_service.node_version)
    ])
    error_message = "All app services node_version must be one of: 12-lts, 14-lts, 16-lts, 18-lts, 20-lts."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.php_version == null || contains(["7.4", "8.0", "8.1", "8.2"], app_service.php_version)
    ])
    error_message = "All app services php_version must be one of: 7.4, 8.0, 8.1, 8.2."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.python_version == null || contains(["3.7", "3.8", "3.9", "3.10", "3.11"], app_service.python_version)
    ])
    error_message = "All app services python_version must be one of: 3.7, 3.8, 3.9, 3.10, 3.11."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.ruby_version == null || contains(["2.6", "2.7"], app_service.ruby_version)
    ])
    error_message = "All app services ruby_version must be one of: 2.6, 2.7."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      alltrue([
        for cs in app_service.connection_strings : contains([
          "APIHub", "Custom", "DocDb", "EventHub", "MySQL", "NotificationHub",
          "PostgreSQL", "RedisCache", "ServiceBus", "SQLAzure", "SQLServer"
        ], cs.type)
      ])
    ])
    error_message = "All connection_string types must be one of: APIHub, Custom, DocDb, EventHub, MySQL, NotificationHub, PostgreSQL, RedisCache, ServiceBus, SQLAzure, SQLServer."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      alltrue([
        for sa in app_service.storage_accounts : contains(["AzureBlob", "AzureFiles"], sa.type)
      ])
    ])
    error_message = "All storage_account types must be one of: AzureBlob, AzureFiles."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.logs == null || (
        app_service.logs.application_logs == null ||
        app_service.logs.application_logs.file_system_level == null ||
        contains(["Off", "Verbose", "Information", "Warning", "Error"], app_service.logs.application_logs.file_system_level)
      )
    ])
    error_message = "All app services application_logs.file_system_level must be one of: Off, Verbose, Information, Warning, Error."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      app_service.logs == null || (
        app_service.logs.application_logs == null ||
        app_service.logs.application_logs.azure_blob_storage == null ||
        contains(["Off", "Verbose", "Information", "Warning", "Error"], app_service.logs.application_logs.azure_blob_storage.level)
      )
    ])
    error_message = "All app services application_logs.azure_blob_storage.level must be one of: Off, Verbose, Information, Warning, Error."
  }

  validation {
    condition = alltrue([
      for key, app_service in var.app_services :
      contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], app_service.identity_type)
    ])
    error_message = "All app services identity_type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}
