#Resource 1: Network Interface
resource "azurerm_network_interface" "lb_vm_nic" {
  name                = "vm-nic"
  location            = azurerm_resource_group.lb_rg.location
  resource_group_name = azurerm_resource_group.lb_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.lb_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

#Resource 2: VM 
resource "azurerm_windows_virtual_machine" "lb_vm" {
  name                = "windows-vm"
  resource_group_name = azurerm_resource_group.lb_rg.name
  location            = azurerm_resource_group.lb_rg.location
  size                = "Standard_B2s"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.lb_vm_nic.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
}