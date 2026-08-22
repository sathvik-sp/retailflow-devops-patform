variable "Rd_Name" {
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