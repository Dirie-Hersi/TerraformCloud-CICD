#---networking/main.tf ---

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
}

resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
  }

resource "aws_vpc" "terraform_dnd_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "terraform_dnd_vpc-${random_integer.random.id}"
  }
}

resource "aws_subnet" "dnd_public_subnet" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.terraform_dnd_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "terraform_dnd_public_${count.index + 1}"
  }
}

