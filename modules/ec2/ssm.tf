resource "aws_ssm_parameter" "server" {
  count = var.is_server == "yes" ? 1 : 0
  name  = "/wg/server-config"
  type  = "String"
  value = file("${path.module}/assests/server.cfg")
}

resource "aws_ssm_parameter" "peer" {
  count = var.is_server == "no" ? 1 : 0
  name  = "wg/peer-config"
  type  = "String"
  value = file("${path.module}/assests/peer.cfg")
}