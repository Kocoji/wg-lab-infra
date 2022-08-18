variable "svc_name" {
  type        = string
  description = "service name"
}
variable "environment" {
  type = string
}
variable "public_key" {
  type = string
  description = "value of public key, to ssh access to the instance"
}