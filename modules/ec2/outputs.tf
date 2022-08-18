output "wireguard_public_ip" {
    value = aws_instance.wireguard.public_ip
}
output "wireguard_private_ip" {
    value = aws_instance.wireguard.private_ip
}
output "server_private_ip" {
    value = aws_instance.server.private_ip
}
output "public_eni" {
    value = aws_network_interface.aws_wg_eni.0.id
}