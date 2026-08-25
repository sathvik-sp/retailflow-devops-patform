variable "acr_name" {
  description = "The name of the container registry"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The location of the container registry"
  type        = string
}

variable "sku_type" {
  description = "The SKU tier for the container registry"
  type        = string

  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku_type)
    error_message = "The SKU type must be either 'Basic', 'Standard', or 'Premium'."
  }

}