data "azurerm_subnet" "bastion_subnet" {
  name                 = var.bastion_subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.rg_name
}

data "azurerm_public_ip" "bastion" {
  name                = var.public_ip_name
  resource_group_name = var.rg_name
}
    