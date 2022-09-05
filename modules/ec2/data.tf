data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}


data "aws_iam_policy" "ssm_ec2" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}