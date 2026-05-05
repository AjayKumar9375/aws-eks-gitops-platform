variable "name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "azs" {
  type = list(string)

  validation {
    condition     = length(var.azs) >= 2
    error_message = "At least two availability zones are required for an EKS-ready VPC."
  }
}

variable "public_subnets" {
  type = list(string)

  validation {
    condition     = length(var.public_subnets) >= 2
    error_message = "At least two public subnets are required for an EKS-ready VPC."
  }
}

variable "private_subnets" {
  type = list(string)

  validation {
    condition     = length(var.private_subnets) >= 2
    error_message = "At least two private subnets are required for an EKS-ready VPC."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
