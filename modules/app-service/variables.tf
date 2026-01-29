variable "app_service_name" {
  description = "Name of the App Service"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "service_plan_id" {
  description = "ID of the App Service Plan"
  type        = string
}

variable "always_on" {
  description = "Enable Always On"
  type        = bool
  default     = true
}

variable "docker_image_name" {
  description = "Docker image name"
  type        = string
  default     = null
}

variable "docker_registry_url" {
  description = "Docker registry URL"
  type        = string
  default     = "https://index.docker.io"
}

variable "app_settings" {
  description = "App settings for the App Service"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the App Service"
  type        = map(string)
  default     = {}
}
