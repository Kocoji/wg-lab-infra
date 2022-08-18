output "wireguard-server" {
    value =  format("WG Server public IP: %s\nWG Server Private IP: %s\nssh ubuntu@%s -i Your_private_key", module.ec2.wireguard_public_ip,module.ec2.wireguard_private_ip,module.ec2.wireguard_public_ip)
}
output "server_ip" {
    value =  module.ec2.server_private_ip
}