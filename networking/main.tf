#---networking/main.tf ---

data "aws_availability_zones" "available" {}

resource "random_integer" "random" {
  min = 1
  max = 100
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
  
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "terraform_dnd_public_${count.index + 1}"
  }
}

resource "aws_subnet" "dnd_private_subnet" {
  count      = var.private_sn_count
  vpc_id     = aws_vpc.terraform_dnd_vpc.id
  cidr_block = var.private_cidrs[count.index]

  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "terraform_dnd_private_${count.index + 1}"
  }
}


resource "aws_internet_gateway" "dnd_internet_gateway" {
  vpc_id = aws_vpc.terraform_dnd_vpc.id

  tags = {
    Name = "dnd_igw"
  }
}

resource "aws_route_table" "dnd_public_rt" {
  vpc_id = aws_vpc.terraform_dnd_vpc.id

  tags = {
    Name = "dnd_public_rt"
  }
}

resource "aws_route_table_association" "dnd_public_assoc" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.dnd_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.dnd_public_rt.id
}


resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.dnd_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dnd_internet_gateway.id
}