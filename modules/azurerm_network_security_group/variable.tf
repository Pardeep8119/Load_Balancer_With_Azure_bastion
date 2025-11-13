variable "rg_name" {
  description = "The name of the resource group in which to create the network security group."
  type        = string
}

variable "location" {
  description = "The Azure region where the network security group will be created."
  type        = string
}
variable "nsg_name" {
  description = "The name of the network security group."
  type        = string
}