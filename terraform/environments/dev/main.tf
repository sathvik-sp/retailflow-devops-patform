module "resource_group" {
  source = "../../modules/resource-group"
  Name   = var.Rg_Name
  Loc    = var.Rg_Loc
}

module "networking" {
  source                    = "../../modules/networking"
  Vnet_name                 = var.Vnet_name
  Vnet_location             = var.Rg_Loc
  Vnet_resource_group_name  = var.Rg_Name
  Vnet_address_space        = var.Vnet_address_space
  aks_subnet_name           = var.aks_subnet_name
  aks_subnet_address_prefix = var.aks_subnet_address_prefix
}

module "acr" {
  source              = "../../modules/acr"
  acr_name            = var.acr_name
  resource_group_name = var.Rg_Name
  location            = var.Rg_Loc
  sku_type            = var.sku_type
}

module "aks" {
  source                       = "../../modules/aks"
  cluster_name                 = var.cluster_name
  location                     = var.Rg_Loc
  resource_group_name          = var.Rg_Name
  dns_prefix                   = var.dns_prefix
  default_node_pool_name       = var.default_node_pool_name
  default_node_pool_node_count = var.default_node_pool_node_count
  default_node_pool_vm_size    = var.default_node_pool_vm_size
  aks_subnet_id                = module.networking.aks_subnet_id
  service_cidr                 = var.service_cidr
  dns_service_ip                = var.dns_service_ip
}