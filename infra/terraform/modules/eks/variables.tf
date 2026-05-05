variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "cluster_enabled_log_types" {
  type        = list(string)
  description = "EKS control plane log types to publish to CloudWatch."
  default     = ["api", "audit", "authenticator"]
}

variable "cluster_endpoint_private_access" {
  type        = bool
  description = "Whether the EKS private API endpoint is enabled."
  default     = true
}

variable "cluster_endpoint_public_access" {
  type        = bool
  description = "Whether the EKS public API endpoint is enabled."
  default     = true
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "managed_node_groups" {
  type = any
}

variable "tags" {
  type    = map(string)
  default = {}
}
