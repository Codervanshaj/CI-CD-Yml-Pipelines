variable "location" {
  description = "The Azure region where resources will be created."
  type        = string
  default     = "eastus"
  
}

variable "admin_password" {
  description = "The admin password for the virtual machine."
  type        = string
  sensitive   = true
}

variable "managed_disk_type" {
  description = "The type of managed disk to create."
  type        = string
  default     = "Standard_LRS"
}   
