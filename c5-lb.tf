#Resource 1: Frontend IP for loadbalancer
resource "azurerm_public_ip" "lb_pip" {
  name                = "lb-publicip"
  resource_group_name = azurerm_resource_group.lb_rg.name
  location            = azurerm_resource_group.lb_rg.location
  allocation_method   = "Static"
}

#Resource 2: Loadbalancer
resource "azurerm_lb" "lb" {
  name                = var.lb_name
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lb_pip.id
  }

}
#Resource 3: LB backendpool
resource "azurerm_lb_backend_address_pool" "lb_bap" {
  name            = "vm-backend"
  loadbalancer_id = azurerm_lb.lb.id
}
#Resource 4: LB rule
resource "azurerm_lb_rule" "lb_rule" {
  name                           = "lb-rule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_lb.lb.frontend_ip_configuration[0].name
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.lb_bap.id
  loadbalancer_id                = azurerm_lb.lb.id
}
#Resource 5: Inbound NAT Rule
#Nat rule
resource "azurerm_lb_nat_rule" "lb_nat_rule" {
  resource_group_name            = azurerm_resource_group.lb_rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "RDPAccess"
  protocol                       = "Tcp"
  frontend_port                  = 1337
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}
#Nat rule association
resource "azurerm_network_interface_nat_rule_association" "web_nic_nat_rule_associate" {
  network_interface_id  = azurerm_network_interface.lb_vm_nic.id
  ip_configuration_name = azurerm_network_interface.lb_vm_nic.ip_configuration[0].name
  nat_rule_id           = azurerm_lb_nat_rule.lb_nat_rule.id
}
