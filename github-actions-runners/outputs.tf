# Linux VM Runners Outputs
output "linux_vm_runners" {
  description = "Details of Linux VM runners"
  value       = module.runner_vm_linux
}

# Windows VM Runners Outputs
output "windows_vm_runners" {
  description = "Details of Windows VM runners"
  value       = module.runner_vm_windows
}

# Linux VMSS Runners Outputs
output "linux_vmss_runners" {
  description = "Details of Linux VMSS runners"
  value       = module.runner_vmss_linux
}

# Windows VMSS Runners Outputs
output "windows_vmss_runners" {
  description = "Details of Windows VMSS runners"
  value       = module.runner_vmss_windows
}

# Container Instance Runners Outputs
output "container_instance_runners" {
  description = "Details of Container Instance runners"
  value       = module.runner_container_instance
}

# Docker Host Runners Outputs
output "docker_host_runners" {
  description = "Details of Docker host runners"
  value       = module.runner_docker_host
}

# Summary Output
output "runners_summary" {
  description = "Summary of all deployed runners"
  value = {
    linux_vm_count        = length(var.runner_vm_linux)
    windows_vm_count      = length(var.runner_vm_windows)
    linux_vmss_count      = length(var.runner_vmss_linux)
    windows_vmss_count    = length(var.runner_vmss_windows)
    container_count       = length(var.runner_container_instance)
    docker_host_count     = length(var.runner_docker_host)
    total_runner_types    = length(var.runner_vm_linux) + length(var.runner_vm_windows) + length(var.runner_vmss_linux) + length(var.runner_vmss_windows) + length(var.runner_container_instance) + length(var.runner_docker_host)
  }
}
