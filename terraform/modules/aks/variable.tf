variable "cluster_name" {
  description = "The name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "The Azure region where the AKS cluster will be deployed."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the AKS cluster."
  type        = string
}

variable "default_node_pool_name" {
  description = "The name of the default node pool."
  type        = string
}

variable "default_node_pool_node_count" {
  description = "The number of nodes in the default node pool."
  type        = number
}

variable "default_node_pool_vm_size" {
  description = "The size of the virtual machines in the default node pool."
  type        = string
}

variable "aks_subnet_id" {
  description = "The ID of the subnet in which to deploy the AKS cluster."
  type        = string
}

variable "dns_prefix" {
  description = "The DNS prefix to use with the AKS cluster."
  type        = string
}

variable "service_cidr" {
  description = "The CIDR block for the Kubernetes service network."
  type        = string
}

variable "dns_service_ip" {
  description = "The IP address for the Kubernetes DNS service."
  type        = string
}