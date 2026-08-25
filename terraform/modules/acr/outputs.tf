output "login_server" {
  description = "The login server URL for the Azure Container Registry."
  value       = azurerm_container_registry.this.login_server
}

output "acr_id" {
  description = "The resource ID of the Azure Container Registry."
  value       = azurerm_container_registry.this.id
}
