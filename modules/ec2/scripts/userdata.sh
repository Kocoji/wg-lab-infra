#! /bin/bash
sudo su
apt update && apt install -y wireguard jq
cd /etc/wireguard
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p
