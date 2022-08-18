variable "svc_name" {
  type        = string
  description = "service name"
  default = "wireguard"
}
variable "environment" {
  type = string
  default = "test"
}
variable "public_key" {
  type = string
  description = "value of public key, to ssh access to the instance"
}