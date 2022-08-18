resource "aws_key_pair" "key"  {
    key_name = "${var.svc_name}-key"
    public_key = var.public_key
}