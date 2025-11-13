variable "rg_name" {
  description = "The name of the resource group in which the network interface will be created."
  type        = string  
}
variable "location" {
  description = "The location where the network interface will be created."
  type        = string  
}
variable "nic_name" {
  description = "The name of the network interface to be created."
  type        = string  
}
variable "frontend_subnet_name" {
  description = "The name of the frontend subnet."
  type        = string  
}
variable "vnet_name" {
  description = "The name of the virtual network where the subnet is located."
  type        = string  
}