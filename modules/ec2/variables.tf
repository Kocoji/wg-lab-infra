# variable "sv_eni" {
#   type = string
# }
# variable "ami_id" {
#   type = string
# }
  
variable "svc_name" {
  type        = string
  description = "service name"
}
variable "environment" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "public_key" {
    type = string
}

variable "public_subnets" {
  description = "The pubsub of the VPC."
  type = list(string)
}

variable "private_subnets" {
  description = "The private sub of the VPC."
  type = list(string)
}


variable "cidr_block" {
   description = "The CIDR block of the VPC."
   type = string
}

variable "wireguard_ip" {
  type = string
}

variable "sv_ip" {
  type = string
}

variable "wg_ec2_name"{
  type = string
}

variable "private_ec2_name" {
  type = string
}

variable "is_server"{
  type = string
  description = "yes/no"
}