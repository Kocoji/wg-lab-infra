#!/usr/bin/bash

sudo su
apt update && apt install -y wireguard awscli jq
cd /etc/wireguard
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

wgpath="/etc/wireguard"
instanceId=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
wgPubkey=`cat $wgpath/publickey`
privatekey=`cat $wgpath/privatekey`
configPath="$wgpath/wg0.conf"
region=`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`

# ssm zone
ssmWgPubKey="/wg/publickey"
ssmServerIp="/wg/endpoint-IP"
ssmWgAddress="/wg/address"
ssmWgAllowedIPs="/wg/AllowedIPs"
ssmTarget="/wg/target"

isServer=`aws ec2 describe-tags --filters "Name=resource-id,Values=$instanceId" "Name=key,Values=is_server" --output text --region $region | cut -f5`


putSsmParam(){
    aws ssm put-parameter --name $1 --type String --value $2 --overwrite --region $3
}

getSsmParam() {
    cmd="aws ssm get-parameter --name $1 --query Parameter.Value --output text --region $2"
    until $cmd; do
        echo "seem like the value is not available, retry every 10s"
        sleep 10
    done
}

main() {
    # update the target region into ssm param.
    putSsmParam $ssmWgPubKey $wgPubkey $region
    
    target=`getSsmParam $ssmTarget $region`

    if [[ "$isServer" == "yes" || "$isServer" == "true" ]]; then 
        publicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
        putSsmParam $ssmServerIp $publicIP $region
        getSsmParam "/wg/server-config" $region > $configPath 

    else
        getSsmParam "/wg/peer-config" $region > $configPath 
        endpoint="`getSsmParam $ssmServerIp $target`:51820"
        until sed -i "s/Endpoint =.*/Endpoint = $endpoint/g" $configPath ; do
            sleep 10
        done
        # cleanup the parameters that not managed by terraform.
        aws ssm delete-parameter --name $ssmServerIp --region $target
    fi
    
    wgAddr=`getSsmParam $ssmWgAddress $region`
    peerPubkey=`getSsmParam $ssmWgPubKey $target`
    allowIps=`getSsmParam $ssmWgAllowedIPs $region`

    # update the wg tunnel address
    sed -e "s@Address =.*@Address = $wgAddr@" \
        -e "s@PrivateKey =.*@PrivateKey = $privatekey@" \
        -e "s@PublicKey =.*@PublicKey = $peerPubkey@" \
        -e "s@AllowedIPs =.*@AllowedIPs = $allowIps@" $configPath -i

    systemctl enable wg-quick@wg0
    systemctl start wg-quick@wg0
    systemctl status wg-quick@wg0
    # cleanup the parameters that not managed by terraform.
    aws ssm delete-parameter --name $ssmWgPubKey --region $target && echo "Deleted the $ssmWgPubKey at $target"

    # notification when the script was successful installed. future update.
}

main
