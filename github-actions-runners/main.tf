terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.58"
    }
  }

  backend "azurerm" {
    # Override during init with backend config file
    resource_group_name  = "runners-tfstate-rg"
    storage_account_name = "runnerstfstate"
    container_name       = "tfstate"
    key                  = "runners.terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    virtual_machine {
      delete_os_disk_on_deletion     = true
      graceful_shutdown              = false
      skip_shutdown_and_force_delete = false
    }
  }
}

# Linux VM Runners - Single VMs for GitHub Actions
module "runner_vm_linux" {
  source = "./modules/runner-vm-linux"

  runners = var.runner_vm_linux

  depends_on = []
}

# Windows VM Runners - Single Windows Server VMs
module "runner_vm_windows" {
  source = "./modules/runner-vm-windows"

  runners = var.runner_vm_windows

  depends_on = []
}

# Linux VMSS Runners - Auto-scaling Linux runners
module "runner_vmss_linux" {
  source = "./modules/runner-vmss-linux"

  scale_sets = var.runner_vmss_linux

  depends_on = []
}

# Windows VMSS Runners - Auto-scaling Windows runners
module "runner_vmss_windows" {
  source = "./modules/runner-vmss-windows"

  scale_sets = var.runner_vmss_windows

  depends_on = []
}

# Container Instance Runners - Serverless ACI runners
module "runner_container_instance" {
  source = "./modules/runner-container-instance"

  containers = var.runner_container_instance

  depends_on = []
}

# Docker Host Runners - VM running multiple Docker containers
module "runner_docker_host" {
  source = "./modules/runner-docker-host"

  docker_hosts = var.runner_docker_host

  depends_on = []
}
