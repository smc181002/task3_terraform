variable "instance_type" {}
variable "pub_subnet_id" {}
variable "pr_subnet_id" {}
variable "public_wp3_id" {}
variable "private_db3_id" {}

resource "aws_instance" "db3" {
  ami = "ami-0025b3a1ef8df0c3b"
  instance_type = var.instance_type
  subnet_id = var.pr_subnet_id
  vpc_security_group_ids = [var.private_db3_id]
  key_name = "mypem11"

  tags = {
    Name: "db3"
  }
}

resource "aws_instance" "wp3" {
  depends_on = [aws_instance.db3]
  ami = "ami-01b9cb595fc660622"
  instance_type = var.instance_type
  subnet_id = var.pub_subnet_id
  vpc_security_group_ids = [var.public_wp3_id]
  key_name = "mypem11"

  tags = {
    Name: "Wp3"
  }
}
