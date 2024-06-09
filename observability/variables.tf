variable "resource_group_location" {
  type      = string
  sensitive = false
  default   = "eastus"
}

variable "resource_group_name" {
  type      = string
  sensitive = false
  default   = "fiap-tech-challenge-main-group"
}

variable "environment" {
  type      = string
  sensitive = false
  default   = "development"
}