#! /bin/bash
sudo su
apt update && apt install -y wireguard awscli
cd /etc/wireguard
umask 077; wg genkey | tee privatekey | wg pubkey > publickey
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
sysctl -p

instanceId=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
wgPubkey = `cat pubkey`
privatekey = `cat /etc/wireguard/privatekey`
configPath = "/etc/wireguard/wg0.cfg"

ssmWgKeypath="/wg/publickey"
ssmServerIpPath="/wg/server-publicIP"

isServer=`aws ec2 describe-tags --filters "Name=resource-id,Values=$instanceId" "Name=key,Values=is_server" --output text | cut -f5`

# server, put public IP and key.

publicIP=`curl http://169.254.169.254/latest/meta-data/public-ipv4`
aws ssm put-parameter --name $ssmWgKeypath --type String --value $wgPubkey --overwrite

if [["$isServer" == "yes" || "$isServer" == "true"]] ; then 
    aws ssm put-parameter --name $ssmServerIpPath --type String --value $publicIP --overwrite
fi



getSsmParam() {
    cmd = "aws ssm get-parameter --name "+$1+" --query Parameter.Value --output text --region "+$2
    until $cmd; do
        echo "seem like the metric is not available, retry every 10s"
        sleep 10
    done
}

# genConf() {
#     privatekey = `cat /etc/wireguard/privatekey`

# }

main() {
    # 'aws ssm get-parameter --name /wg-publickey --query Parameter.Value --output text --region'
    #check the 
    region=`curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region`
    # update the target region into ssm param.
    if [[ "$region" == *"us"* ]]; then
        # publickey=`getSsmParam "ap-southeast-1"`
        target="ap-southeast-1"
    else
        target="us-east-1"
    fi

    # targetPublickey= `getSsmParam $ssmkeypath $target`

    if [["$isServer" == "yes" || "$isServer" == "true"]] ; then 
        getSsmParam "/wg/server-config" $region > $configPath 
    else
        getSsmParam "/wg/server-config" $region > $configPath 
    fi

}

main