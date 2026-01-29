# ========================================
# REQUIRED VARIABLES
# ========================================

variable "app_service_name" {
  description = "(Required) Name of the App Service. Must be globally unique"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,60}$", var.app_service_name))
    error_message = "App Service name must be 1-60 characters, alphanumeric and hyphens only."
  }
}

variable "location" {
  description = "(Required) Azure region where the App Service will be created"
  type        = string

  validation {
    condition     = length(var.location) > 0
    error_message = "Location must be specified."
  }
}

variable "resource_group_name" {
  description = "(Required) Name of the resource group where the App Service will be created"
  type        = string

  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name must be specified."
  }
}

variable "service_plan_id" {
  description = "(Required) ID of the App Service Plan where the App Service will be deployed"
  type        = string

  validation {
    condition     = length(var.service_plan_id) > 0
    error_message = "Service Plan ID must be specified."
  }
}

# ========================================
# CORE OPTIONAL VARIABLES
# ========================================

variable "app_settings" {
  description = "(Optional) Application settings for the App Service as key-value pairs. Default: {}"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "tags" {
  description = "(Optional) Tags to apply to the App Service"
  type        = map(string)
  default     = {}
  nullable    = false
}

variable "enabled" {
  description = "(Optional) Should the Linux Web App be enabled? Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "public_network_access_enabled" {
  description = "(Optional) Should public network access be enabled for the Web App? Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "client_affinity_enabled" {
  description = "(Optional) Should Client Affinity be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "client_certificate_enabled" {
  description = "(Optional) Should Client Certificates be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "client_certificate_mode" {
  description = "(Optional) The Client Certificate mode. Possible values: 'Required', 'Optional', 'OptionalInteractiveUser'. Default: Required"
  type        = string
  default     = "Required"
  nullable    = false

  validation {
    condition     = contains(["Required", "Optional", "OptionalInteractiveUser"], var.client_certificate_mode)
    error_message = "client_certificate_mode must be one of: Required, Optional, OptionalInteractiveUser."
  }
}

variable "client_certificate_exclusion_paths" {
  description = "(Optional) Paths to exclude when using client certificates, separated by ; Default: null"
  type        = string
  default     = null
}

variable "https_only" {
  description = "(Optional) Should the Linux Web App require HTTPS connections? Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "virtual_network_subnet_id" {
  description = "(Optional) The subnet ID for VNet integration. Default: null"
  type        = string
  default     = null
}

variable "key_vault_reference_identity_id" {
  description = "(Optional) The identity ID to use for Key Vault references. Default: null"
  type        = string
  default     = null
}

variable "zip_deploy_file" {
  description = "(Optional) The local path to the ZIP file to deploy. Default: null"
  type        = string
  default     = null
}

variable "webdeploy_publish_basic_authentication_enabled" {
  description = "(Optional) Should basic authentication be enabled for WebDeploy publishing? Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "ftp_publish_basic_authentication_enabled" {
  description = "(Optional) Should basic authentication be enabled for FTP publishing? Default: true"
  type        = bool
  default     = true
  nullable    = false
}

# ========================================
# SITE_CONFIG VARIABLES
# ========================================

variable "always_on" {
  description = "(Optional) Should the app be loaded at all times? Default: true"
  type        = bool
  default     = true
  nullable    = false
}

variable "api_definition_url" {
  description = "(Optional) The URL of the OpenAPI (Swagger) definition for this web app. Default: null"
  type        = string
  default     = null
}

variable "api_management_api_id" {
  description = "(Optional) The ID of the API Management API this Web App is associated with. Default: null"
  type        = string
  default     = null
}

variable "app_command_line" {
  description = "(Optional) The command to launch the app. Default: null"
  type        = string
  default     = null
}

variable "auto_heal_setting" {
  description = "(Optional) Auto-heal configuration block. Default: null"
  type = object({
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
  })
  default = null
}

variable "container_registry_use_managed_identity" {
  description = "(Optional) Should Managed Identity be used for container registry access? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "container_registry_managed_identity_client_id" {
  description = "(Optional) The Client ID of the Managed Identity to use for container registry. Default: null"
  type        = string
  default     = null
}

variable "default_documents" {
  description = "(Optional) List of default documents. Default: null"
  type        = list(string)
  default     = null
}

variable "ftps_state" {
  description = "(Optional) The state of FTP/FTPS service. Possible values: 'AllAllowed', 'FtpsOnly', 'Disabled'. Default: Disabled"
  type        = string
  default     = "Disabled"
  nullable    = false

  validation {
    condition     = contains(["AllAllowed", "FtpsOnly", "Disabled"], var.ftps_state)
    error_message = "ftps_state must be one of: AllAllowed, FtpsOnly, Disabled."
  }
}

variable "health_check_path" {
  description = "(Optional) The path to check for health. Default: null"
  type        = string
  default     = null
}

variable "health_check_eviction_time_in_min" {
  description = "(Optional) Time in minutes after which instance is evicted if unhealthy. Default: null"
  type        = number
  default     = null

  validation {
    condition     = var.health_check_eviction_time_in_min == null || (var.health_check_eviction_time_in_min >= 2 && var.health_check_eviction_time_in_min <= 10)
    error_message = "health_check_eviction_time_in_min must be between 2 and 10."
  }
}

variable "http2_enabled" {
  description = "(Optional) Should HTTP2 be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "ip_restriction" {
  description = "(Optional) List of IP restriction rules for the Web App. Default: []"
  type = list(object({
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
  }))
  default  = []
  nullable = false
}

variable "ip_restriction_default_action" {
  description = "(Optional) Default action for IP restrictions. Possible values: 'Allow', 'Deny'. Default: Allow"
  type        = string
  default     = "Allow"
  nullable    = false

  validation {
    condition     = contains(["Allow", "Deny"], var.ip_restriction_default_action)
    error_message = "ip_restriction_default_action must be one of: Allow, Deny."
  }
}

variable "load_balancing_mode" {
  description = "(Optional) The load balancing mode. Possible values: 'LeastRequests', 'WeightedRoundRobin', 'LeastResponseTime', 'WeightedTotalTraffic', 'RequestHash', 'PerSiteRoundRobin'. Default: LeastRequests"
  type        = string
  default     = "LeastRequests"
  nullable    = false

  validation {
    condition     = contains(["LeastRequests", "WeightedRoundRobin", "LeastResponseTime", "WeightedTotalTraffic", "RequestHash", "PerSiteRoundRobin"], var.load_balancing_mode)
    error_message = "load_balancing_mode must be one of: LeastRequests, WeightedRoundRobin, LeastResponseTime, WeightedTotalTraffic, RequestHash, PerSiteRoundRobin."
  }
}

variable "local_mysql_enabled" {
  description = "(Optional) Should local MySQL be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "managed_pipeline_mode" {
  description = "(Optional) The managed pipeline mode. Possible values: 'Integrated', 'Classic'. Default: Integrated"
  type        = string
  default     = "Integrated"
  nullable    = false

  validation {
    condition     = contains(["Integrated", "Classic"], var.managed_pipeline_mode)
    error_message = "managed_pipeline_mode must be one of: Integrated, Classic."
  }
}

variable "minimum_tls_version" {
  description = "(Optional) The minimum TLS version. Possible values: '1.0', '1.1', '1.2', '1.3'. Default: 1.2"
  type        = string
  default     = "1.2"
  nullable    = false

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.minimum_tls_version)
    error_message = "minimum_tls_version must be one of: 1.0, 1.1, 1.2, 1.3."
  }
}

variable "remote_debugging_enabled" {
  description = "(Optional) Should remote debugging be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "remote_debugging_version" {
  description = "(Optional) The remote debugging version. Possible values: 'VS2017', 'VS2019', 'VS2022'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.remote_debugging_version == null || contains(["VS2017", "VS2019", "VS2022"], var.remote_debugging_version)
    error_message = "remote_debugging_version must be one of: VS2017, VS2019, VS2022."
  }
}

variable "scm_ip_restriction" {
  description = "(Optional) List of IP restriction rules for SCM site. Default: []"
  type = list(object({
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
  }))
  default  = []
  nullable = false
}

variable "scm_ip_restriction_default_action" {
  description = "(Optional) Default action for SCM IP restrictions. Possible values: 'Allow', 'Deny'. Default: Allow"
  type        = string
  default     = "Allow"
  nullable    = false

  validation {
    condition     = contains(["Allow", "Deny"], var.scm_ip_restriction_default_action)
    error_message = "scm_ip_restriction_default_action must be one of: Allow, Deny."
  }
}

variable "scm_minimum_tls_version" {
  description = "(Optional) The minimum TLS version for SCM. Possible values: '1.0', '1.1', '1.2', '1.3'. Default: 1.2"
  type        = string
  default     = "1.2"
  nullable    = false

  validation {
    condition     = contains(["1.0", "1.1", "1.2", "1.3"], var.scm_minimum_tls_version)
    error_message = "scm_minimum_tls_version must be one of: 1.0, 1.1, 1.2, 1.3."
  }
}

variable "scm_use_main_ip_restriction" {
  description = "(Optional) Should SCM site use the same IP restrictions as main site? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "use_32_bit_worker" {
  description = "(Optional) Should 32-bit worker process be used? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "vnet_route_all_enabled" {
  description = "(Optional) Should all outbound traffic be routed through VNet? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "websockets_enabled" {
  description = "(Optional) Should WebSockets be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "worker_count" {
  description = "(Optional) Number of workers. Default: null"
  type        = number
  default     = null

  validation {
    condition     = var.worker_count == null || (var.worker_count >= 1 && var.worker_count <= 100)
    error_message = "worker_count must be between 1 and 100."
  }
}

# ========================================
# APPLICATION_STACK VARIABLES
# ========================================

variable "docker_image_name" {
  description = "(Optional) Docker image name for containerized deployments (e.g., nginx:latest). Default: null"
  type        = string
  default     = null
}

variable "docker_registry_url" {
  description = "(Optional) Docker registry URL. Default: https://index.docker.io"
  type        = string
  default     = "https://index.docker.io"
  nullable    = false
}

variable "docker_registry_username" {
  description = "(Optional) Username for docker registry. Default: null"
  type        = string
  default     = null
  sensitive   = true
}

variable "docker_registry_password" {
  description = "(Optional) Password for docker registry. Default: null"
  type        = string
  default     = null
  sensitive   = true
}

variable "dotnet_version" {
  description = "(Optional) The version of .NET to use. Possible values: '3.1', '5.0', '6.0', '7.0', '8.0'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.dotnet_version == null || contains(["3.1", "5.0", "6.0", "7.0", "8.0"], var.dotnet_version)
    error_message = "dotnet_version must be one of: 3.1, 5.0, 6.0, 7.0, 8.0."
  }
}

variable "go_version" {
  description = "(Optional) The version of Go to use. Possible values: '1.18', '1.19', '1.20', '1.21'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.go_version == null || contains(["1.18", "1.19", "1.20", "1.21"], var.go_version)
    error_message = "go_version must be one of: 1.18, 1.19, 1.20, 1.21."
  }
}

variable "java_server" {
  description = "(Optional) The Java server type. Possible values: 'JAVA', 'TOMCAT', 'JBOSSEAP'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.java_server == null || contains(["JAVA", "TOMCAT", "JBOSSEAP"], var.java_server)
    error_message = "java_server must be one of: JAVA, TOMCAT, JBOSSEAP."
  }
}

variable "java_server_version" {
  description = "(Optional) The Java server version. Default: null"
  type        = string
  default     = null
}

variable "java_version" {
  description = "(Optional) The version of Java to use. Possible values: '8', '11', '17', '21'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.java_version == null || contains(["8", "11", "17", "21"], var.java_version)
    error_message = "java_version must be one of: 8, 11, 17, 21."
  }
}

variable "node_version" {
  description = "(Optional) The version of Node.js to use. Possible values: '12-lts', '14-lts', '16-lts', '18-lts', '20-lts'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.node_version == null || contains(["12-lts", "14-lts", "16-lts", "18-lts", "20-lts"], var.node_version)
    error_message = "node_version must be one of: 12-lts, 14-lts, 16-lts, 18-lts, 20-lts."
  }
}

variable "php_version" {
  description = "(Optional) The version of PHP to use. Possible values: '7.4', '8.0', '8.1', '8.2'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.php_version == null || contains(["7.4", "8.0", "8.1", "8.2"], var.php_version)
    error_message = "php_version must be one of: 7.4, 8.0, 8.1, 8.2."
  }
}

variable "python_version" {
  description = "(Optional) The version of Python to use. Possible values: '3.7', '3.8', '3.9', '3.10', '3.11'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.python_version == null || contains(["3.7", "3.8", "3.9", "3.10", "3.11"], var.python_version)
    error_message = "python_version must be one of: 3.7, 3.8, 3.9, 3.10, 3.11."
  }
}

variable "ruby_version" {
  description = "(Optional) The version of Ruby to use. Possible values: '2.6', '2.7'. Default: null"
  type        = string
  default     = null

  validation {
    condition     = var.ruby_version == null || contains(["2.6", "2.7"], var.ruby_version)
    error_message = "ruby_version must be one of: 2.6, 2.7."
  }
}

# ========================================
# CORS VARIABLES
# ========================================

variable "cors_allowed_origins" {
  description = "(Optional) List of allowed origins for CORS. Default: []"
  type        = list(string)
  default     = []
  nullable    = false
}

variable "cors_support_credentials" {
  description = "(Optional) Should credentials be supported in CORS requests? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

# ========================================
# AUTH_SETTINGS / AUTH_SETTINGS_V2
# ========================================

variable "auth_settings_enabled" {
  description = "(Optional) Should App Service Authentication be enabled? Default: false"
  type        = bool
  default     = false
  nullable    = false
}

variable "auth_settings" {
  description = "(Optional) Authentication settings for the App Service. Default: null"
  type = object({
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
  })
  default = null
}

variable "auth_settings_v2" {
  description = "(Optional) Authentication settings v2 for the App Service. Default: null"
  type = object({
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
  })
  default = null
}

# ========================================
# BACKUP VARIABLES
# ========================================

variable "backup" {
  description = "(Optional) Backup configuration for the App Service. Default: null"
  type = object({
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
  })
  default = null
}

# ========================================
# CONNECTION_STRING VARIABLES
# ========================================

variable "connection_strings" {
  description = "(Optional) Connection strings for the App Service. Default: []"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default   = []
  nullable  = false
  sensitive = true

  validation {
    condition = alltrue([
      for cs in var.connection_strings : contains([
        "APIHub", "Custom", "DocDb", "EventHub", "MySQL", "NotificationHub",
        "PostgreSQL", "RedisCache", "ServiceBus", "SQLAzure", "SQLServer"
      ], cs.type)
    ])
    error_message = "connection_string type must be one of: APIHub, Custom, DocDb, EventHub, MySQL, NotificationHub, PostgreSQL, RedisCache, ServiceBus, SQLAzure, SQLServer."
  }
}

# ========================================
# STORAGE_ACCOUNT VARIABLES
# ========================================

variable "storage_accounts" {
  description = "(Optional) Storage account mounts for the App Service. Default: []"
  type = list(object({
    name         = string
    type         = string
    account_name = string
    share_name   = string
    access_key   = string
    mount_path   = optional(string)
  }))
  default   = []
  nullable  = false
  sensitive = true

  validation {
    condition = alltrue([
      for sa in var.storage_accounts : contains(["AzureBlob", "AzureFiles"], sa.type)
    ])
    error_message = "storage_account type must be one of: AzureBlob, AzureFiles."
  }
}

# ========================================
# LOGS VARIABLES
# ========================================

variable "logs" {
  description = "(Optional) Logging configuration for the App Service. Default: null"
  type = object({
    detailed_error_messages = optional(bool)
    failed_request_tracing  = optional(bool)
    application_logs = optional(object({
      file_system_level = optional(string)
      azure_blob_storage = optional(object({
        level             = string
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
  })
  default = null

  validation {
    condition = var.logs == null || (
      var.logs.application_logs == null ||
      var.logs.application_logs.file_system_level == null ||
      contains(["Off", "Verbose", "Information", "Warning", "Error"], var.logs.application_logs.file_system_level)
    )
    error_message = "application_logs.file_system_level must be one of: Off, Verbose, Information, Warning, Error."
  }

  validation {
    condition = var.logs == null || (
      var.logs.application_logs == null ||
      var.logs.application_logs.azure_blob_storage == null ||
      contains(["Off", "Verbose", "Information", "Warning", "Error"], var.logs.application_logs.azure_blob_storage.level)
    )
    error_message = "application_logs.azure_blob_storage.level must be one of: Off, Verbose, Information, Warning, Error."
  }
}

# ========================================
# IDENTITY VARIABLES
# ========================================

variable "identity_type" {
  description = "(Optional) The type of Managed Identity. Possible values: 'SystemAssigned', 'UserAssigned', 'SystemAssigned, UserAssigned'. Default: SystemAssigned"
  type        = string
  default     = "SystemAssigned"
  nullable    = false

  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "identity_type must be one of: SystemAssigned, UserAssigned, SystemAssigned, UserAssigned."
  }
}

variable "identity_ids" {
  description = "(Optional) List of User Assigned Identity IDs. Required when identity_type includes UserAssigned. Default: []"
  type        = list(string)
  default     = []
  nullable    = false
}

# ========================================
# STICKY_SETTINGS VARIABLES
# ========================================

variable "sticky_settings" {
  description = "(Optional) Sticky settings configuration. Default: null"
  type = object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  })
  default = null
}
