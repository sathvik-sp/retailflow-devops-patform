terraform {
  backend "azurerm" {
    resource_group_name  = "rg-retailflow-tfstate"
    storage_account_name = "tfstatefile08202026"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
    
    
  }
}