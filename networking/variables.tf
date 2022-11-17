#--- networking/variables.tf ---

variable "vpc_cidr" {
  type = string
}

variable "max_subnets" {
  type = number
}

variable "public_sn_count" {
  type = number
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
  type = list(any)
}

variable "private_sn_count" {
  type = number
}