resource "aws_iam_role" "this" {
  name = "${var.svc_name}-ec2_ssm_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Service = "${var.svc_name}-role"
  }
}

resource "aws_iam_policy" "policy" {
  name        = "${var.svc_name}-test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = file("${path.module}/assests/policy.json")
}


resource "aws_iam_role_policy_attachment" "ec2-attach" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ec2-attach2" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_iam_instance_profile" "this" {
  name = "${var.svc_name}-ec2_ssm_profile"
  role = aws_iam_role.this.name
}
