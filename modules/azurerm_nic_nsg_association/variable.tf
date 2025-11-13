variable "rg_name" {
  description = "The name of the resource group in which to create the network interface security group association."
  type        = string
}
variable "nic_name" {
  description = "The name of the network interface to associate with the network security group."
  type        = string
}
variable "nsg_name" {
  description = "The name of the network security group to associate with the network interface."
  type        = string
}