output "vpc_id" {
    value = aws_vpc.aws-vpc.id
}
output "public_subnet_ids" {
    value = aws_subnet.public.*.id
}
output "private_subnet_ids" {
    value = aws_subnet.private.*.id
}
output "cidr_block" {
    value = aws_vpc.aws-vpc.cidr_block
}