resource "aws_instance" "wireguard" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  user_data     = file("${path.module}/scripts/userdata-wg.sh")
  key_name      = aws_key_pair.key.key_name

  iam_instance_profile = aws_iam_instance_profile.this.name


  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.aws_wg_eni.0.id
  }
  tags = {
    Name      = var.wg_ec2_name
    is_server = var.is_server
  }
}

resource "aws_instance" "server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.aws_sv_eni.0.id
  }
  tags = {
    Name = var.private_ec2_name
  }
}
