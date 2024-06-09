resource "azurerm_storage_account" "log_storage_account" {
  name                     = "sandubalog"
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_log_analytics_workspace" "log_workspace" {
  name                = "fiap-tech-challenge-observability-workspace"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  sku                 = "PerGB2018"

  tags = {
    environment = var.environment
  }
}

resource "azurerm_log_analytics_solution" "log_solution_container_insights" {
  solution_name         = "fiap-tech-challenge-container-insights"
  resource_group_name   = azurerm_log_analytics_workspace.log_workspace.resource_group_name
  location              = azurerm_log_analytics_workspace.log_workspace.location
  workspace_resource_id = azurerm_log_analytics_workspace.log_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.log_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "ContainerInsights"
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_application_insights" "observability_application_insights" {
  name                = "fiap-tech-challenge-application-insights"
  resource_group_name = azurerm_log_analytics_workspace.log_workspace.resource_group_name
  location            = azurerm_log_analytics_workspace.log_workspace.location
  workspace_id        = azurerm_log_analytics_workspace.log_workspace.id
  application_type    = "web"

  tags = {
    environment = var.environment
  }
}