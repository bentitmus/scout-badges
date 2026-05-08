variable "environment" {
  type        = string
  description = "Deployment environment name"
  default     = "dev"

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "common_tags" {
  type      = map

}

variable "specific_tags" {
  type      = map
  
}

variable "public_subnet1" {
  type      = string
}

variable "public_subnet2" {
  type      = string
}

variable "private_subnet1" {
  type      = string
  default   = ""
}

variable "private_subnet2" {
  type      = string
  default   = ""
}