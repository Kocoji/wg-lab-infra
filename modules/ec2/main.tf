resource "aws_instance" "wireguard" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = file("${path.module}/scripts/userdata.sh")
  key_name      = aws_key_pair.key.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.aws_wg_eni.0.id
  }
  tags = {
    Name = "WireGuard-Server"
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = file("${path.module}/scripts/userdata.sh")
  key_name      = aws_key_pair.key.key_name
  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.aws_sv_eni.0.id
  }
  tags = {
    Name = "Server-private"
  }
}
