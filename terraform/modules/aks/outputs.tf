output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}

output "kubelet_identity_object_id" {
  description = "The object ID of the kubelet identity for the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}