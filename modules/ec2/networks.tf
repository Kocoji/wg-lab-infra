
# have to deep dive to make it more dynamic, select the right subnet
resource "aws_network_interface" "aws_wg_eni" {
  count           = 1
  subnet_id       = element(var.public_subnets.*, count.index)
  private_ips      = [var.wireguard_ip]
  security_groups = [aws_security_group.wg_sg.id]
  source_dest_check = false
  tags = {
    Name        = "${var.svc_name}-eni"
    Environment = var.environment
  }
}

resource "aws_network_interface" "aws_sv_eni" {
  count           = 1
  subnet_id       = element(var.private_subnets.*, count.index)
  private_ips      = [var.sv_ip]
  security_groups = [aws_security_group.sv_sg.id]
  tags = {
    Name        = "${var.svc_name}-eni"
    Environment = var.environment
  }
}

resource "aws_security_group" "wg_sg" {
  name   = "${var.svc_name}-${var.environment}-SG"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow all inbound traffic in the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
  ingress {
    description = "Wireguard"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"] # for lab env, allow all ingress to this port
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "sv_sg" {
  name   = "${var.svc_name}-${var.environment}-private-SG"
  vpc_id = var.vpc_id
  ingress {
    description = "Allow all inbound traffic in the VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
