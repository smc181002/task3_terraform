variable "vpc_id" {}

resource "aws_subnet" "public_sn" {

  vpc_id     =  var.vpc_id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_sn_wp"
  }
}

resource "aws_subnet" "private_sn" {

  vpc_id     = var.vpc_id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_sn_db"
  }
}

output "pub_subnet_id" {
  value = "${aws_subnet.public_sn.id}"
}

output "pr_subnet_id" {
  value = "${aws_subnet.private_sn.id}"
}