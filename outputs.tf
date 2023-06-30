# LB Public IP
output "web_lb_public_ip_address" {
  description = "Web Load Balancer Public Address"
  value       = azurerm_public_ip.lb_pip.ip_address
}

# VM RDP port access
output "vm_rdp_port" {
  description = "Port to connect to the VM using RDP"
  value       = azurerm_lb_nat_rule.lb_nat_rule.frontend_port
}

#RDP Username and Password
