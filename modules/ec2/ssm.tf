resource "aws_ssm_parameter" "server" {
  count = var.is_server == "yes" ? 1 : 0
  name  = "/wg/server-config"
  type  = "String"
  value = file("${path.module}/assests/server.cfg")
}

resource "aws_ssm_parameter" "peer" {
  count = var.is_server == "no" ? 1 : 0
  name  = "/wg/peer-config"
  type  = "String"
  value = file("${path.module}/assests/peer.cfg")
}

resource "aws_ssm_parameter" "wg_address" {
  name  = "/wg/address"
  type  = "String"
  value = var.wg_address
}

resource "aws_ssm_parameter" "wg_allowed_ips" {
  name  = "/wg/AllowedIPs"
  type  = "String"
  value = var.wg_allowed_ips
}

resource "aws_ssm_parameter" "target" {
  name  = "/wg/target"
  type  = "String"
  value = var.target_region
}
