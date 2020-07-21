variable "vpc_id" {}

resource "aws_security_group" "public_wp3" {
  name        = "server_public_wp3"
  description = "allow icmp http ssh"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name : "WP_public_grp3"
  }
}

resource "aws_security_group" "private_db3" {
  name   = "mysql_private_db3"
  vpc_id = var.vpc_id

  ingress {
    description     = "mysql"
    security_groups = [aws_security_group.public_wp3.id]
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name : "DB_private_grp"
  }
}

output "public_sec" {
  value = aws_security_group.public_wp3.id
}

output "private_sec" {
  value = aws_security_group.private_db3.id
}
