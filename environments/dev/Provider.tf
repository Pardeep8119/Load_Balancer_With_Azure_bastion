terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.32.0"
    }
}

  backend "azurerm" {
    resource_group_name   = "DoNotDeleteRg"
    storage_account_name  = "donotdeletestorage5555"
    container_name        = "tfstate"
    key                   = "dev.terraform.tfstate"
}
}

provider "azurerm" {
  features {}
  subscription_id = "13dfd1e6-6770-4299-b7ea-6aa09b346468"
}