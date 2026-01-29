app_services = {
  # Example 1: Docker-based Node.js application
  "web-app-prod" = {
    name                = "myorg-web-app-prod"
    location            = "East US"
    resource_group_name = "rg-production"
    service_plan_id     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-production/providers/Microsoft.Web/serverfarms/asp-production"

    always_on           = true
    https_only          = true
    docker_image_name   = "nginx:latest"
    docker_registry_url = "https://index.docker.io"

    app_settings = {
      "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "7"
      "ENVIRONMENT"                        = "production"
      "LOG_LEVEL"                          = "info"
    }

    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      CostCenter  = "Engineering"
    }

    health_check_path                 = "/health"
    health_check_eviction_time_in_min = 5

    ip_restriction = [
      {
        name       = "Allow Office"
        ip_address = "203.0.113.0/24"
        action     = "Allow"
        priority   = 100
      }
    ]
  }

  # Example 2: Python application with custom settings
  "api-app-staging" = {
    name                = "myorg-api-app-staging"
    location            = "West US 2"
    resource_group_name = "rg-staging"
    service_plan_id     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-staging/providers/Microsoft.Web/serverfarms/asp-staging"

    always_on      = true
    https_only     = true
    python_version = "3.11"

    app_settings = {
      "ENVIRONMENT"                        = "staging"
      "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "3"
      "ENABLE_ORYX_BUILD"                  = "true"
      "SCM_DO_BUILD_DURING_DEPLOYMENT"     = "true"
    }

    tags = {
      Environment = "Staging"
      ManagedBy   = "Terraform"
      Team        = "Backend"
    }

    http2_enabled       = true
    websockets_enabled  = true
    minimum_tls_version = "1.2"

    cors_allowed_origins = [
      "https://staging.example.com",
      "https://dev.example.com"
    ]
    cors_support_credentials = true

    connection_strings = [
      {
        name  = "DefaultConnection"
        type  = "SQLAzure"
        value = "Server=tcp:myserver.database.windows.net,1433;Database=mydb;"
      }
    ]
  }

  # Example 3: .NET application with backup and advanced settings
  "dotnet-app-dev" = {
    name                = "myorg-dotnet-app-dev"
    location            = "Central US"
    resource_group_name = "rg-development"
    service_plan_id     = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/rg-development/providers/Microsoft.Web/serverfarms/asp-development"

    always_on      = false
    https_only     = true
    dotnet_version = "8.0"

    app_settings = {
      "ASPNETCORE_ENVIRONMENT"             = "Development"
      "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "1"
    }

    tags = {
      Environment = "Development"
      ManagedBy   = "Terraform"
      Project     = "CustomerPortal"
    }

    client_certificate_enabled = true
    client_certificate_mode    = "Optional"

    remote_debugging_enabled = true
    remote_debugging_version = "VS2022"

    ftps_state = "FtpsOnly"

    logs = {
      detailed_error_messages = true
      failed_request_tracing  = true

      application_logs = {
        file_system_level = "Information"
      }

      http_logs = {
        file_system = {
          retention_in_days = 7
          retention_in_mb   = 35
        }
      }
    }

    sticky_settings = {
      app_setting_names = ["ASPNETCORE_ENVIRONMENT"]
    }
  }
}
