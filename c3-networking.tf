# Resource-1: Create VM Subnet
resource "azurerm_subnet" "lb_subnet" {
  name                 = var.vm_subnet_name
  resource_group_name  = azurerm_resource_group.lb_rg.name
  virtual_network_name = azurerm_virtual_network.lb_vnet.name
  address_prefixes     = var.vm_subnet_address
}

# Resource-2: Create Network Security Group (NSG)
resource "azurerm_network_security_group" "lb_nsg" {
  name                = "${var.vm_subnet_name}-nsg"
  resource_group_name = azurerm_resource_group.lb_rg.name
  location            = azurerm_resource_group.lb_rg.location
}

# Resource-3: Create NSG Rules
## Locals Block for Security Rules
locals {
  inbound_ports = {
    "100" : "80", # If the key starts with a number, you must use the colon syntax ":" instead of "="
    "110" : "443",
    "120" : "3389"
  }
}

resource "azurerm_network_security_rule" "lb_nsg_rule" {
  for_each                    = local.inbound_ports
  name                        = "Rule-Port-${each.value}"
  priority                    = each.key
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = each.value
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.lb_rg.name
  network_security_group_name = azurerm_network_security_group.lb_nsg.name
}

# Resource-4: Associate NSG and Subnet
resource "azurerm_subnet_network_security_group_association" "web_subnet_nsg_associate" {
  depends_on                = [azurerm_network_security_rule.lb_nsg_rule] # Every NSG Rule Association will disassociate NSG from Subnet and Associate it, so we associate it only after NSG is completely created - Azure Provider Bug https://github.com/terraform-providers/terraform-provider-azurerm/issues/354  
  subnet_id                 = azurerm_subnet.lb_subnet.id
  network_security_group_id = azurerm_network_security_group.lb_nsg.id
}

