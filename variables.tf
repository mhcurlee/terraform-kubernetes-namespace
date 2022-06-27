# variables.tf
variable "host" {
  description = "hostname and port of the k8s endpoint"
  type        = string
}

variable "token" {
  description = "token for k8s access"
  type        = string

}

variable "cacert" {
  description = "the ca cert for the k8s host"
  type        = string

}



variable "namespace_name" {
  description = "name of namespace"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.namespace_name))
    error_message = "Namespace name can only contain lower case letters, numbers, and hyphens.  The name must also start and end with a lower case alphanumeric character."
  }

  validation {
    condition = length(var.namespace_name) < 63
    error_message = "Namespace name has a max size of 63 chars."
  }
}



variable "max_pods" {
  description = "max pods for quota"
  default     = 20
  type        = number
}

variable "max_services" {
  description = "max pods for quota"
  default     = 20
  type        = number
}

variable "cpu_request" {
  description = "cpu request for quota"
  type        = string
  default     = "1000m"
}

variable "cpu_limit" {
  description = "cpu limit for quota"
  type        = string
  default     = "1000m"
}

variable "memory_request" {
  description = "memory request for quota"
  type        = string
  default     = "1Gi"
}

variable "memory_limit" {
  description = "memory limit for quota"
  type        = string
  default     = "1Gi"
}

