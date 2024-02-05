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
  features {}
}

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

resource "azurerm_storage_container" "storage_containe_terraform" {
  name                  = "sanduba-terraform-storage-container"
  storage_account_name  = azurerm_storage_account.storage_account_terraform.name
  container_access_type = "private"
}