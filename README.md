This is the lab environment for my post,
You can read it here: https://kocoji.co/posts/s2s-wireguard/

The files/folders structure
```  
.
├── README.md
├── ap-southeast-1
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   └── variables.tf
├── modules
│   ├── ec2
│   │   ├── README.md
│   │   ├── assests
│   │   │   ├── peer.cfg
│   │   │   ├── policy.json
│   │   │   └── server.cfg
│   │   ├── data.tf
│   │   ├── iam.tf
│   │   ├── keys.tf
│   │   ├── main.tf
│   │   ├── networks.tf
│   │   ├── outputs.tf
│   │   ├── scripts
│   │   │   └── userdata-wg.sh
│   │   ├── ssm.tf
│   │   └── variables.tf
│   └── vpc
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── us-east-1
    ├── main.tf
    ├── outputs.tf
    ├── provider.tf
    └── variables.tf
```


You can go into two folders: `ap-southeast-1` and `us-east-1`, then use `terraform init && terraform apply` and input the required variable when asked, or create a predefined `.tfvars` file. To create the demonstrate infrastructure.

The EC2 modules leverage the SSM Parameter to store the configuration data. So, this will fully install the WireGuard Lab environment, you don't need to manually config anymore.

Sample output:
``` bash
Apply complete! Resources: 26 added, 0 changed, 0 destroyed.

Outputs:

server_ip = "10.20.0.10"
wireguard-server = <<EOT
WG Peer public IP: 13.215.248.230
WG Server Private IP: 10.20.100.10
ssh ubuntu@13.215.248.230 -i Your_private_key
EOT
```
After that, you can ssh access and continue to the manual configuration step.



This source is still not the most optimized terraform structure, and I still learning the TF to apply the `DRY` principle.
