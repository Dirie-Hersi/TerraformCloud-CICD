# ---root/main.tf ---


module "networking" {
  source          = "./networking"
  vpc_cidr        = var.vpc_cidr
  public_sn_count = 3
  private_sn_count = 3
  max_subnets     = 20
  public_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  private_cidrs = [for i in range(2, 255, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
}