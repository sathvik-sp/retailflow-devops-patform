resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name

  dns_prefix = var.dns_prefix

  role_based_access_control_enabled = true

  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  node_provisioning_profile {
    mode = "Manual"
  }

  default_node_pool {
    name           = var.default_node_pool_name
    node_count     = var.default_node_pool_node_count
    vm_size        = var.default_node_pool_vm_size
    vnet_subnet_id = var.aks_subnet_id

    upgrade_settings {
      max_surge = "10%"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    service_cidr   = var.service_cidr
    network_plugin = "azure"
    dns_service_ip = var.dns_service_ip
  }
}

