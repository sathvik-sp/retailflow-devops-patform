variable "Rg_Name" {
  description = "Name of the resource group"
  type        = string
}

variable "Rg_Loc" {
  description = "Location of the resource group"
  type        = string
}

variable "Vnet_name" {
  description = "Name of the virtual network"
  type        = string
}

variable "Vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

variable "aks_subnet_name" {
  description = "Name of the AKS subnet"
  type        = string
}

variable "aks_subnet_address_prefix" {
  description = "Address prefix for the AKS subnet"
  type        = list(string)
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
}

variable "sku_type" {
  description = "SKU type for the Azure Container Registry"
  type        = string
}

variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "default_node_pool_name" {
  description = "Name of the default node pool"
  type        = string
}

variable "default_node_pool_node_count" {
  description = "Number of nodes in the default node pool"
  type        = number
}

variable "default_node_pool_vm_size" {
  description = "VM size for the default node pool"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "service_cidr" {
  description = "The CIDR block for the Kubernetes service network"
  type        = string
}

variable "dns_service_ip" {
  description = "The IP address for the Kubernetes DNS service"
  type        = string
}