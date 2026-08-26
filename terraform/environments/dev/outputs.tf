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

output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = module.acr.acr_id
}

output "aks_cluster_id" {
  description = "ID of the AKS cluster"
  value       = module.aks.cluster_id
}

output "kubelet_identity_object_id" {
  description = "Object ID of the kubelet identity"
  value       = module.aks.kubelet_identity_object_id
}