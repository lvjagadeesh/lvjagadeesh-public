# Module Names - Quick Reference

## 10 Azure Terraform Modules

| # | Module Name | Azure Resource |
|---|-------------|----------------|
| 1 | `resource-group` | Resource Group |
| 2 | `virtual-network` | Virtual Network + Subnets |
| 3 | `storage-account` | Storage Account |
| 4 | `key-vault` | Key Vault |
| 5 | `app-service-plan` | App Service Plan |
| 6 | `app-service` | Linux Web App |
| 7 | `sql-server` | SQL Server |
| 8 | `sql-database` | SQL Database |
| 9 | `container-registry` | Container Registry |
| 10 | `aks-cluster` | Kubernetes Cluster |

## Module Locations

All modules are located in the `modules/` directory:

```
modules/
├── resource-group/
├── virtual-network/
├── storage-account/
├── key-vault/
├── app-service-plan/
├── app-service/
├── sql-server/
├── sql-database/
├── container-registry/
└── aks-cluster/
```

## Usage

### Local Usage
```hcl
module "example" {
  source = "./modules/resource-group"
  # ... configuration
}
```

### Git Usage
```hcl
module "example" {
  source = "git::https://github.com/lvjagadeesh/lvjagadeesh-public.git//modules/resource-group?ref=main"
  # ... configuration
}
```

## Documentation

See **[MODULE-REFERENCE.md](MODULE-REFERENCE.md)** for complete details on each module including:
- Full feature list
- Usage examples
- Key features
- Configuration options

See **[README.md](README.md)** for comprehensive usage guide.
