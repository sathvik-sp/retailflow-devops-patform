resource "azurerm_virtual_network" "this" {
  name                = var.Vnet_name
  location            = var.Vnet_location
  resource_group_name = var.Vnet_resource_group_name
  address_space       = var.Vnet_address_space
}

resource "azurerm_subnet" "aks" {
  name                 = var.aks_subnet_name
  resource_group_name  = var.Vnet_resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = var.aks_subnet_address_prefix
}