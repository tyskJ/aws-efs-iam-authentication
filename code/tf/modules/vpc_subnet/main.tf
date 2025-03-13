# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf resource                                                                                        ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ vpc                                │ aws_vpc                                             │ VPC.                                                  ║
# ║ subnet                             │ aws_subnet                                          │ Subnet.                                               ║
# ║ nacl                               │ aws_network_acl                                     │ NACL.                                                 ║
# ║ nacl_in_rule100                    │ aws_network_acl_rule                                │ NACL Inbound Rule.                                    ║
# ║ nacl_out_rule100                   │ aws_network_acl_rule                                │ NACL Outbound Rule.                                   ║
# ║ assoc_nacl                         │ aws_network_acl_association                         │ NACL Association Subnet.                              ║
# ║ igw                                │ aws_internet_gateway                                │ IGW.                                                  ║
# ║ rtb_public                         │ aws_route_table                                     │ Public RouteTable.                                    ║
# ║ rtb_private                        │ aws_route_table                                     │ Private RouteTable.                                   ║
# ║ assoc_rtb_pub1                     │ aws_route_table_association                         │ RouteTable Association Subnet.                        ║
# ║ assoc_rtb_pri1                     │ aws_route_table_association                         │ RouteTable Association Subnet.                        ║
# ║ ec2_sg                             │ aws_security_group                                  │ Security Group for EC2.                               ║
# ║ efs_sg                             │ aws_security_group                                  │ Security Group for EFS.                               ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_map.cidr_block
  enable_dns_support   = var.vpc_map.enable_dns_support
  enable_dns_hostnames = var.vpc_map.enable_dns_hostnames
  tags = {
    Name = var.vpc_map.name
  }
}

resource "aws_subnet" "subnet" {
  for_each                = { for i in var.subnet_map_list : i.name => i }
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.availability_zone
  map_public_ip_on_launch = each.value.map_public_ip_on_launch
  tags = {
    Name = each.value.name
  }
}

resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "nacl"
  }
}

resource "aws_network_acl_rule" "nacl_in_rule100" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = false
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_rule" "nacl_out_rule100" {
  network_acl_id = aws_network_acl.nacl.id
  rule_number    = 100
  rule_action    = "allow"
  egress         = true
  protocol       = -1
  cidr_block     = "0.0.0.0/0"
}

resource "aws_network_acl_association" "assoc_nacl" {
  for_each       = toset(var.nacl_assoc_list)
  network_acl_id = aws_network_acl.nacl.id
  subnet_id      = aws_subnet.subnet[each.value].id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "igw"
  }
}

resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rtb-public"
  }
}

resource "aws_route_table" "rtb_private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "rtb-private"
  }
}

resource "aws_route_table_association" "assoc_rtb_pub1" {
  subnet_id      = aws_subnet.subnet["public-subnet-a"].id
  route_table_id = aws_route_table.rtb_public.id
}

resource "aws_route_table_association" "assoc_rtb_pri1" {
  subnet_id      = aws_subnet.subnet["private-subnet-a"].id
  route_table_id = aws_route_table.rtb_private.id
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Security Group for EC2."
  tags = {
    Name = "ec2-sg"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Security Group for EFS."
  tags = {
    Name = "efs-sg"
  }
}
