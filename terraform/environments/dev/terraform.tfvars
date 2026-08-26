Rg_Name = "rg-retailflow-devops-platform"
Rg_Loc  = "East US"

Vnet_name                 = "vnet-retailflow-dev"
Vnet_address_space        = ["10.0.0.0/16"]
aks_subnet_name           = "snet-aks"
aks_subnet_address_prefix = ["10.0.1.0/24"]

acr_name = "acrretailflowdev"
sku_type = "Basic"

cluster_name                 = "aks-retailflow-dev"
default_node_pool_name       = "system"
default_node_pool_node_count = 1
default_node_pool_vm_size    = "Standard_D2als_v7"
dns_prefix                   = "aks-retailflow-dev"
service_cidr                 = "10.1.0.0/16"
dns_service_ip               = "10.1.0.10"