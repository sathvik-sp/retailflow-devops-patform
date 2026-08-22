output "resource_group_id" {
  description = "ID of the development Resource Group"
  value       = module.resource_group.resource_group_id
}

output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = module.networking.Vnet_id
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = module.networking.aks_subnet_id
} 