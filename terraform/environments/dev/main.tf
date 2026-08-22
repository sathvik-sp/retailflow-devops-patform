module "resource_group" {
  source = "../../modules/resource-group"
  Name   = var.Rd_Name
  Loc    = var.Rg_Loc
}

module "networking" {
  source                    = "../../modules/networking"
  Vnet_name                 = var.Vnet_name
  Vnet_location             = var.Rg_Loc
  Vnet_resource_group_name  = var.Rd_Name
  Vnet_address_space        = var.Vnet_address_space
  aks_subnet_name           = var.aks_subnet_name
  aks_subnet_address_prefix = var.aks_subnet_address_prefix
}