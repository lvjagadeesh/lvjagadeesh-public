# Linux VM Runners
variable "runner_vm_linux" {
  description = "(Optional) Map of Linux VM runners to create. Each runner is a single Ubuntu VM."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    vm_size             = optional(string, "Standard_B2s")
    admin_username      = optional(string, "azureuser")
    admin_ssh_key       = optional(string, null)
    os_disk_size_gb     = optional(number, 128)
    
    github_url          = string
    github_token        = string
    runner_group        = optional(string, "Default")
    runner_labels       = optional(list(string), ["azure", "linux"])
    runner_version      = optional(string, "latest")
    ephemeral           = optional(bool, false)
    
    subnet_id           = optional(string, null)
    public_ip_enabled   = optional(bool, true)
    
    tags                = optional(map(string), {})
  }))
  default = {}
}

# Windows VM Runners
variable "runner_vm_windows" {
  description = "(Optional) Map of Windows VM runners to create. Each runner is a single Windows Server VM."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    vm_size             = optional(string, "Standard_D2s_v3")
    admin_username      = optional(string, "azureuser")
    admin_password      = optional(string, null)
    os_disk_size_gb     = optional(number, 128)
    
    github_url          = string
    github_token        = string
    runner_group        = optional(string, "Default")
    runner_labels       = optional(list(string), ["azure", "windows"])
    runner_version      = optional(string, "latest")
    ephemeral           = optional(bool, false)
    
    subnet_id           = optional(string, null)
    public_ip_enabled   = optional(bool, true)
    
    tags                = optional(map(string), {})
  }))
  default = {}
}

# Linux VMSS Runners
variable "runner_vmss_linux" {
  description = "(Optional) Map of Linux VM Scale Sets for auto-scaling runners."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    vm_size             = optional(string, "Standard_B2s")
    instances_min       = optional(number, 0)
    instances_max       = optional(number, 10)
    instances_default   = optional(number, 1)
    
    github_url          = string
    github_token        = string
    runner_group        = optional(string, "Default")
    runner_labels       = optional(list(string), ["azure", "linux", "vmss"])
    runner_version      = optional(string, "latest")
    
    subnet_id           = optional(string, null)
    
    tags                = optional(map(string), {})
  }))
  default = {}
}

# Windows VMSS Runners
variable "runner_vmss_windows" {
  description = "(Optional) Map of Windows VM Scale Sets for auto-scaling runners."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    vm_size             = optional(string, "Standard_D2s_v3")
    instances_min       = optional(number, 0)
    instances_max       = optional(number, 10)
    instances_default   = optional(number, 1)
    
    github_url          = string
    github_token        = string
    runner_group        = optional(string, "Default")
    runner_labels       = optional(list(string), ["azure", "windows", "vmss"])
    runner_version      = optional(string, "latest")
    
    subnet_id           = optional(string, null)
    
    tags                = optional(map(string), {})
  }))
  default = {}
}

# Container Instance Runners
variable "runner_container_instance" {
  description = "(Optional) Map of Azure Container Instance runners (serverless)."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    cpu_cores           = optional(number, 2)
    memory_gb           = optional(number, 4)
    
    github_url          = string
    github_token        = string
    runner_group        = optional(string, "Default")
    runner_labels       = optional(list(string), ["azure", "aci", "docker"])
    
    subnet_id           = optional(string, null)
    
    tags                = optional(map(string), {})
  }))
  default = {}
}

# Docker Host Runners
variable "runner_docker_host" {
  description = "(Optional) Map of Docker host VMs running multiple container runners."
  type = map(object({
    name                = string
    resource_group_name = string
    location            = string
    vm_size             = optional(string, "Standard_D4s_v3")
    admin_username      = optional(string, "azureuser")
    admin_ssh_key       = optional(string, null)
    
    github_url          = string
    github_token        = string
    runner_count        = optional(number, 5)
    runner_labels       = optional(list(string), ["azure", "docker"])
    
    subnet_id           = optional(string, null)
    public_ip_enabled   = optional(bool, true)
    
    tags                = optional(map(string), {})
  }))
  default = {}
}
