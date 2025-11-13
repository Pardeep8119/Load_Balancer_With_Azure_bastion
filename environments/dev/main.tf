module "resource_group" {
  source   = "../../modules/azurerm_resource_group"
  rg_name  = "parnew_rg"
  location = "centralindia"
}
module "virtual_network" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_virtual_network"

  vnet_name     = "vnet-lb"
  location      = "centralindia"
  rg_name       = "parnew_rg"
  address_space = ["10.0.0.0/16"]
}

module "frontend_subnet" {
  depends_on = [module.virtual_network]
  source     = "../../modules/azurerm_subnet"

  rg_name          = "parnew_rg"
  vnet_name        = "vnet-lb"
  subnet_name      = "frontend-subnet"
  address_prefixes = ["10.0.1.0/24"]
}

module "bastion_subnet" {
  depends_on = [module.virtual_network]
  source     = "../../modules/azurerm_subnet"

  rg_name          = "parnew_rg"
  vnet_name        = "vnet-lb"
  subnet_name      = "AzureBastionSubnet"
  address_prefixes = ["10.0.2.0/26"]
}

module "nic_chinki_vm" {
  source               = "../../modules/azurerm_nic"
  depends_on           = [module.virtual_network, module.frontend_subnet]
  nic_name             = "nic-chinki-vm"
  rg_name              = "parnew_rg"
  location             = "centralindia"
  vnet_name            = "vnet-lb"
  frontend_subnet_name = "frontend-subnet"
}

module "nsg" {
  depends_on = [module.resource_group]
  source     = "../../modules/azurerm_network_security_group"
  rg_name    = "parnew_rg"
  location   = "centralindia"
  nsg_name   = "secure-nsg"
}

module "chinki_nic_nsg_association" {
  source     = "../../modules/azurerm_nic_nsg_association"
  depends_on = [module.nic_chinki_vm, module.nsg]
  nic_name   = "nic-chinki-vm"
  rg_name    = "parnew_rg"
  nsg_name   = "secure-nsg"
}

module "pinki_nic_nsg_association" {
  source     = "../../modules/azurerm_nic_nsg_association"
  depends_on = [module.nic_pinki_vm, module.nsg]
  nic_name   = "nic-pinki-vm"
  rg_name    = "parnew_rg"
  nsg_name   = "secure-nsg"
}

module "nic_pinki_vm" {
  source               = "../../modules/azurerm_nic"
  depends_on           = [module.virtual_network, module.frontend_subnet]
  nic_name             = "nic-pinki-vm"
  rg_name              = "parnew_rg"
  location             = "centralindia"
  vnet_name            = "vnet-lb"
  frontend_subnet_name = "frontend-subnet"
}

module "chinki_vm" {
  source               = "../../modules/azurerm_virtual_machine"
  depends_on           = [module.nic_chinki_vm]
  rg_name              = "parnew_rg"
  location             = "centralindia"
  vm_name              = "chinki-vm"
  vm_size              = "Standard_B1s"
  admin_username       = "devopsadmin"
  admin_password       = "P@ssw01rd@123"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-chinki-vm"
  vnet_name            = "vnet-lb"
  frontend_subnet_name = "frontend-subnet"
}

module "pinki_vm" {
  source               = "../../modules/azurerm_virtual_machine"
  depends_on           = [module.nic_pinki_vm]
  rg_name              = "parnew_rg"
  location             = "centralindia"
  vm_name              = "pinki-vm"
  vm_size              = "Standard_B1s"
  admin_username       = "devopsadmin"
  admin_password       = "P@ssw01rd@123"
  image_publisher      = "Canonical"
  image_offer          = "0001-com-ubuntu-server-focal"
  image_sku            = "20_04-lts"
  image_version        = "latest"
  nic_name             = "nic-pinki-vm"
  vnet_name            = "vnet-lb"
  frontend_subnet_name = "frontend-subnet"
}

module "public_ip_lb" {
  depends_on        = [module.resource_group]
  source            = "../../modules/azurerm_public_ip"
  public_ip_name    = "loadbalancer_ip"
  rg_name           = "parnew_rg"
  location          = "centralindia"
  allocation_method = "Static"
}

module "public_ip_bastion" {
  depends_on        = [module.resource_group]
  source            = "../../modules/azurerm_public_ip"
  public_ip_name    = "bastion_ip"
  rg_name           = "parnew_rg"
  location          = "centralindia"
  allocation_method = "Static"
}

# lb, frontend_ip-config, probe, backend address pool, rule
module "lb" {
  depends_on = [module.public_ip_lb]
  source     = "../../modules/azurerm_loadbalancer"
}

module "pinki2lb_jod_yojna" {
  depends_on                = [module.lb, module.chinki_vm, module.nic_chinki_vm]
  source                    = "../../modules/azurerm_nic_lb_association"
  nic_name                  = "nic-pinki-vm"
  rg_name                   = "parnew_rg"
  lb_name                   = "pretrail-lb"
  backend_address_pool_name = "lb-BackEndAddressPool1"
  ip_configuration_name     = "internal"
}

module "chinki2lb_jod_yojna" {
  depends_on                = [module.lb, module.pinki_vm, module.nic_pinki_vm]
  source                    = "../../modules/azurerm_nic_lb_association"
  nic_name                  = "nic-chinki-vm"
  rg_name                   = "parnew_rg"
  lb_name                   = "pretrail-lb"
  backend_address_pool_name = "lb-BackEndAddressPool1"
  ip_configuration_name     = "internal"
}

module "bastion" {
  depends_on          = [module.bastion_subnet, module.public_ip_bastion]
  source              = "../../modules/azurerm_bastion_host"
  bastion_name        = "myBastionHost"
  rg_name             = "parnew_rg"
  location            = "centralindia"
  bastion_subnet_name = "AzureBastionSubnet"
  public_ip_name      = "bastion_ip"
  vnet_name           = "vnet-lb"
}

