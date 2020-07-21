provider "aws" {
  region  = "ap-south-1"
  profile = "root"
}

resource "aws_vpc" "vpc_t3" {
  cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "task_3_vpc"
  }
}

module "subnet" {
  source = "./subnet"
  vpc_id = aws_vpc.vpc_t3.id
}

resource "aws_internet_gateway" "ig_for_wp" {
  depends_on = [aws_vpc.vpc_t3, module.subnet]
  vpc_id     = aws_vpc.vpc_t3.id

  tags = {
    Name = "t3main"
  }
}

resource "aws_route_table" "routes_wp" {
  depends_on = [aws_vpc.vpc_t3, aws_internet_gateway.ig_for_wp]
  vpc_id     = aws_vpc.vpc_t3.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig_for_wp.id
  }

  tags = {
    Name = "routeforwp"
  }
}

resource "aws_route_table_association" "routes_wp_assoc" {
  depends_on = [
    aws_vpc.vpc_t3, 
    aws_internet_gateway.ig_for_wp, 
    aws_route_table.routes_wp
  ]

  subnet_id      = module.subnet.pub_subnet_id
  route_table_id = aws_route_table.routes_wp.id
}

module "secgrps" {
  source = "./secgrps"
  vpc_id = aws_vpc.vpc_t3.id
}

module "instances" {
  source = "./instances"
  instance_type = var.instance_type
  pub_subnet_id = module.subnet.pub_subnet_id
  pr_subnet_id = module.subnet.pr_subnet_id
  public_wp3_id = module.secgrps.public_sec
  private_db3_id = module.secgrps.private_sec
}