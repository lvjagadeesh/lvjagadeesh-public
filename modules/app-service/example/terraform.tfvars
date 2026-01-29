app_service_name    = "example-app"
location            = "East US"
resource_group_name = "example-rg"
service_plan_id     = "/subscriptions/xxxx/resourceGroups/example-rg/providers/Microsoft.Web/serverfarms/example-asp"
always_on           = true
docker_image_name   = "nginx:latest"
docker_registry_url = "https://index.docker.io"
app_settings = {
  "WEBSITE_HTTPLOGGING_RETENTION_DAYS" = "7"
}
tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
}
