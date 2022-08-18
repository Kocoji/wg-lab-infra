variable "environment" {
  type = string
}
variable "svc_name" {
  type = string
}
variable "cidr_block" {
  type = string
}
variable "public_subnets" {
  description = "List of public subnets"
}

variable "private_subnets" {
  description = "List of private subnets"
}

variable "availability_zones" {
  description = "List of availability zones"
}

variable "other_site_cidr_block" {
  description = "List of site subnets"
}
variable "public_eni" {
  type = string
  description = "(optional) describe your variable"
}