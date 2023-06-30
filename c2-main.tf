resource "azurerm_resource_group" "lb_rg" {
  name     = var.resource_group_name
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "lb_vnet" {
  name                = var.vnet_name
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name
  address_space       = var.vnet_address_space
}