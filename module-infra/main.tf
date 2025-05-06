terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_security_group" "tool" {
  name        = "${var.name}-sg"
  description = "${var.name}- Security Group"

  tags = {
    name = "${var.name}-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.tool.id
  from_port         = 22
  cidr_ipv4         = "0.0.0.0/0"
  to_port           = 22
  description       = "ssh"
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  ip_protocol       = "tcp"
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = var.port
  to_port           = var.port
  description       = var.name
}

resource "aws_vpc_security_group_egress_rule" "egress_allow_all" {
  ip_protocol       = "-1"
  security_group_id = aws_security_group.tool.id
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_instance" "tool" {
  ami                     = var.ami_id
  instance_type           = var.instance_type
  vpc_security_group_ids  = [aws_security_group.tool.id]
  tags = {
    Name                  = var.name
  }
}

# resource "aws_route53_record" "private" {
#   name    = "${var.name}-private"
#   type    = "A"
#   ttl     = 10
#   zone_id = var.zone_id
#   records = [aws_instance.tool.private_ip]
# }

resource "aws_route53_record" "public" {
  name    = "${var.name}-private"
  type    = "A"
  ttl     = 10
  zone_id = var.zone_id
  records = [aws_instance.tool.public_ip]
}