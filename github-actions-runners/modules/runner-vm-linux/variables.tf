/**
 * GitHub Actions Runner - Linux VM Module
 * Variables Definition
 */

variable "runners" {
  description = "(Required) Map of GitHub Actions runners to create on Linux VMs"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    
    # VM Configuration
    vm_size            = optional(string, "Standard_D2s_v3")
    admin_username     = optional(string, "azureuser")
    os_disk_size_gb    = optional(number, 30)
    os_disk_type       = optional(string, "Premium_LRS")
    
    # GitHub Configuration
    github_url         = string  # e.g., "https://github.com/org/repo"
    github_token       = string  # GitHub PAT with repo and admin:org scope
    runner_group       = optional(string, "Default")
    runner_labels      = optional(list(string), ["self-hosted", "linux", "x64"])
    
    # Network Configuration
    subnet_id          = string
    public_ip_enabled  = optional(bool, false)
    
    # Optional Features
    enable_spot_instance    = optional(bool, false)
    spot_eviction_policy    = optional(string, "Deallocate")
    spot_max_bid_price      = optional(number, -1)
    
    # Monitoring
    enable_boot_diagnostics = optional(bool, true)
    
    # Tags
    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for k, r in var.runners : can(regex("^[a-zA-Z0-9-]{1,64}$", r.name))
    ])
    error_message = "Runner names must be 1-64 characters and contain only letters, numbers, and hyphens."
  }

  validation {
    condition = alltrue([
      for k, r in var.runners : contains([
        "Standard_B2s", "Standard_B2ms", "Standard_D2s_v3", "Standard_D4s_v3",
        "Standard_D8s_v3", "Standard_D16s_v3", "Standard_D32s_v3", "Standard_F2s_v2",
        "Standard_F4s_v2", "Standard_F8s_v2"
      ], r.vm_size)
    ])
    error_message = "VM size must be a valid Azure VM size."
  }

  validation {
    condition = alltrue([
      for k, r in var.runners : r.os_disk_size_gb >= 30 && r.os_disk_size_gb <= 2048
    ])
    error_message = "OS disk size must be between 30 and 2048 GB."
  }
}
