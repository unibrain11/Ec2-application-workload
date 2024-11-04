provider "aws" {
    region = var.region
  }

 
 resource "aws_instance" "web" {
  ami           = var.os_name
  instance_type = var.instance_type
  key_name = var.key_name
  subnet_id = aws_subnet.test.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
 
 }

 resource "aws_vpc" "main" {
  cidr_block = var.vpc-cidr
}

resource "aws_subnet" "test" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.subnet-cidr
  availability_zone = var.subnet-az

  tags = {
    Name = "test"
  }
}

resource "aws_internet_gateway" "demo" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "demo"
  }
}
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.demo.id
  }

  tags = {
    Name = "example"
  }
}

# resource "aws_subnet" "test" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"

#   tags = {
#     Name = "test"
#   }
# }

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.main.id

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = aws_vpc.main.cidr_block
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}