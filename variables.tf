##Resource Group
# Azure Resource Group Name 
variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
  default     = "rafi-lb-rg"
}

# Azure Resources Location
variable "resource_group_location" {
  description = "Region in which Azure Resources to be created"
  type        = string
  default     = "central india"
}

## Virtual Network
variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
  default     = "rafi-lb-vnet"
}
variable "vnet_address_space" {
  description = "Virtual Network address_space"
  type        = list(string)
  default     = ["10.1.1.0/24"]
}

# vm Subnet Name
variable "vm_subnet_name" {
  description = "Virtual Network vm Subnet Name"
  type        = string
  default     = "websubnet"
}
# vm Subnet Address Space
variable "vm_subnet_address" {
  description = "Virtual Network vm Subnet Address Spaces"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

#loadbalancer name
variable "lb_name" {
  type        = string
  description = "loadbalancer name"
  default     = "rafi-lb"
}
