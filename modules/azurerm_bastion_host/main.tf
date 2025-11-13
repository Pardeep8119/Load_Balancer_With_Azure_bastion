resource "azurerm_bastion_host" "mybastion" {
  name                = var.bastion_name
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = data.azurerm_subnet.bastion_subnet.id
    public_ip_address_id = data.azurerm_public_ip.bastion.id
  }
}