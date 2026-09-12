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

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = module.keyvault.key_vault_id
}

output "key_vault_name" {
  description = "Name of the Key Vault"
  value       = module.keyvault.key_vault_name
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.keyvault.key_vault_uri
}

output "workload_identity_client_id" {
  description = "Client ID of the workload identity"
  value       = module.aks.workload_identity_client_id
}

output "workload_identity_principal_id" {
  description = "Principal ID of the workload identity"
  value       = module.aks.workload_identity_principal_id
}

output "oidc_issuer_url" {
  description = "URL of the OIDC issuer"
  value       = module.aks.oidc_issuer_url
}