resource "azurerm_virtual_network" "virtual_network" {
  name                = "fiap-tech-challenge-network"
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = var.environment
  }
}

resource "azurerm_subnet" "api_gateway_subnet" {
  name                 = "fiap-tech-challenge-gateway-subnet"
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "api_auth_subnet" {
  name                 = "fiap-tech-challenge-costumer-subnet"
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.1.0/24"]

  delegation {
    name = "fiap-tech-challenge-costumer-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "order_subnet" {
  name                 = "fiap-tech-challenge-order-subnet"
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "payment_subnet" {
  name                 = "fiap-tech-challenge-payment-subnet"
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.3.0/24"]

  delegation {
    name = "fiap-tech-challenge-payment-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_subnet" "admin_subnet" {
  name                 = "fiap-tech-challenge-admin-subnet"
  resource_group_name  = azurerm_virtual_network.virtual_network.resource_group_name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = ["10.0.4.0/24"]

  delegation {
    name = "fiap-tech-challenge-admin-subnet-delegation"

    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action", "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"]
    }
  }
}

resource "azurerm_public_ip" "public_ip" {
  name                = "fiap-tech-challenge-public-ip"
  resource_group_name = azurerm_virtual_network.virtual_network.resource_group_name
  location            = azurerm_virtual_network.virtual_network.location
  allocation_method   = "Static"
  domain_name_label   = "sanduba"
  sku                 = "Standard"

  tags = {
    environment = azurerm_virtual_network.virtual_network.tags["environment"]
  }
}