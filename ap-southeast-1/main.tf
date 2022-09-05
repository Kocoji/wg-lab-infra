module "vpc" {
  source                = "../modules/vpc"
  svc_name              = var.svc_name
  environment           = var.environment
  cidr_block            = "10.20.0.0/16"
  availability_zones    = ["ap-southeast-1a"]
  public_subnets        = ["10.20.100.0/24"]
  private_subnets       = ["10.20.0.0/24"]
  public_eni            = module.ec2.public_eni
  other_site_cidr_block = "10.10.0.0/16"
}

module "ec2" {
  source          = "../modules/ec2"
  svc_name        = var.svc_name
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  cidr_block      = module.vpc.cidr_block
  public_subnets  = module.vpc.public_subnet_ids
  private_subnets = module.vpc.private_subnet_ids
  public_key      = var.public_key
  wireguard_ip    = "10.20.100.10"
  sv_ip           = "10.20.0.10"

  wg_ec2_name      = "site-b"
  target_region    = "us-east-1"
  wg_address       = "10.0.1.2/24"
  wg_allowed_ips   = "10.0.1.0/24, 10.10.0.0/16"
  private_ec2_name = "site-b-private-instance"
  is_server        = "no"
}
