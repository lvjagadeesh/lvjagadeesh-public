# GitHub Actions Runner - Linux VM Module

terraform {
  required_version = ">= 1.14.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.58"
    }
  }
}

# Linux Virtual Machine for GitHub Actions Runner
resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.runners

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username

  network_interface_ids = [azurerm_network_interface.this[each.key].id]

  admin_ssh_key {
    username   = each.value.admin_username
    public_key = each.value.admin_ssh_key != null ? each.value.admin_ssh_key : tls_private_key.this[each.key].public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
    disk_size_gb         = each.value.os_disk_size_gb
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  custom_data = base64encode(templatefile("${path.module}/scripts/install-runner.sh", {
    github_url      = each.value.github_url
    github_token    = each.value.github_token
    runner_group    = each.value.runner_group
    runner_labels   = join(",", each.value.runner_labels)
    runner_version  = each.value.runner_version
    ephemeral       = each.value.ephemeral ? "--ephemeral" : ""
    runner_name     = each.value.name
  }))

  identity {
    type = "SystemAssigned"
  }

  tags = merge(
    each.value.tags,
    {
      RunnerType = "LinuxVM"
      ManagedBy  = "Terraform"
    }
  )

  lifecycle {
    ignore_changes = [
      custom_data, # Don't recreate VM if script changes
    ]
  }
}

# Network Interface
resource "azurerm_network_interface" "this" {
  for_each = var.runners

  name                = "${each.value.name}-nic"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id != null ? each.value.subnet_id : azurerm_subnet.this[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.public_ip_enabled ? azurerm_public_ip.this[each.key].id : null
  }

  tags = each.value.tags
}

# Public IP (if enabled)
resource "azurerm_public_ip" "this" {
  for_each = {
    for k, v in var.runners : k => v
    if v.public_ip_enabled
  }

  name                = "${each.value.name}-pip"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = each.value.tags
}

# Virtual Network (if subnet not provided)
resource "azurerm_virtual_network" "this" {
  for_each = {
    for k, v in var.runners : k => v
    if v.subnet_id == null
  }

  name                = "${each.value.name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  tags = each.value.tags
}

# Subnet (if not provided)
resource "azurerm_subnet" "this" {
  for_each = {
    for k, v in var.runners : k => v
    if v.subnet_id == null
  }

  name                 = "${each.value.name}-subnet"
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = azurerm_virtual_network.this[each.key].name
  address_prefixes     = ["10.0.1.0/24"]
}

# NSG for runner
resource "azurerm_network_security_group" "this" {
  for_each = var.runners

  name                = "${each.value.name}-nsg"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = each.value.tags
}

# Associate NSG with NIC
resource "azurerm_network_interface_security_group_association" "this" {
  for_each = var.runners

  network_interface_id      = azurerm_network_interface.this[each.key].id
  network_security_group_id = azurerm_network_security_group.this[each.key].id
}

# Generate SSH key if not provided
resource "tls_private_key" "this" {
  for_each = {
    for k, v in var.runners : k => v
    if v.admin_ssh_key == null
  }

  algorithm = "RSA"
  rsa_bits  = 4096
}
