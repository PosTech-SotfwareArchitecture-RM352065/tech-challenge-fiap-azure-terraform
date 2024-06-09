terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.90.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "fiap-tech-challenge-main-group"
    storage_account_name = "sandubaterraform"
    container_name       = "sanduba-terraform-storage-container"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }
}

data "azurerm_client_config" "current_config" {}

resource "azurerm_resource_group" "main_group" {
  name     = "fiap-tech-challenge-main-group"
  location = "eastus"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_account" "storage_account_terraform" {
  name                     = "sandubaterraform"
  resource_group_name      = azurerm_resource_group.main_group.name
  location                 = azurerm_resource_group.main_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = azurerm_resource_group.main_group.tags["environment"]
  }
}

resource "azurerm_storage_container" "storage_container_terraform" {
  name                  = "sanduba-terraform-storage-container"
  storage_account_name  = azurerm_storage_account.storage_account_terraform.name
  container_access_type = "private"
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "fiap-tech-key-vault"
  location                    = azurerm_resource_group.main_group.location
  resource_group_name         = azurerm_resource_group.main_group.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current_config.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current_config.tenant_id
    object_id = data.azurerm_client_config.current_config.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

  tags = {
    environment = azurerm_resource_group.main_group.tags["environment"]
  }
}

module "network" {
  source                  = "./network"
  resource_group_name     = azurerm_resource_group.main_group.name
  resource_group_location = azurerm_resource_group.main_group.location
  environment             = azurerm_resource_group.main_group.tags["environment"]
}

module "observability" {
  source                  = "./observability"
  resource_group_name     = azurerm_storage_account.storage_account_terraform.resource_group_name
  resource_group_location = azurerm_storage_account.storage_account_terraform.location
  environment             = azurerm_storage_account.storage_account_terraform.tags["environment"]
}