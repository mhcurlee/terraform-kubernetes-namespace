# variables.tf
variable "host" {
  description = "hostname and port of the k8s endpoint"
}

variable "token" {
  description = "token for k8s access"

}

variable "cacert" {
  description = "the ca cert for the k8s host"

}

variable "namespace_name" {
  description = "name of namespace"
}

variable "max_pods" {
  description = "max pods for quota"
}

variable "cpu_request" {
  description = "cpu request for quota"
}

variable "cpu_limit" {
  description = "cpu limit for quota"
}

variable "memory_request" {
  description = "memory request for quota"
}

variable "memory_limit" {
  description = "memory limit for quota"
}

