output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "kubelet_identity_object_id" {
  description = "The object ID of the kubelet identity for the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}

output "workload_identity_client_id" {
  value = azurerm_user_assigned_identity.retailflow_workload.client_id
}

output "workload_identity_principal_id" {
  value = azurerm_user_assigned_identity.retailflow_workload.principal_id
}

output "oidc_issuer_url" {
  value = azurerm_kubernetes_cluster.this.oidc_issuer_url
}