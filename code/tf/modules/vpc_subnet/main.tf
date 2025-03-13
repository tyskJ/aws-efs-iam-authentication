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
# ║ ec2_sg_out1                        │ aws_security_group_rule                             │ Security Group unrestricted outboud rule.             ║
# ║ efs_sg_in1                         │ aws_security_group_rule                             │ Security Group tcp/2049 inboud rule from EC2 SG.      ║
# ║ efs_sg_out1                        │ aws_security_group_rule                             │ Security Group unrestricted outboud rule.             ║
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

resource "aws_security_group_rule" "ec2_sg_out1" {
  description       = "Security Group unrestricted outboud rule."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}

resource "aws_security_group_rule" "efs_sg_in1" {
  description              = "Security Group tcp/2049 inboud rule from EC2 SG."
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ec2_sg.id
  security_group_id        = aws_security_group.efs_sg.id
}

resource "aws_security_group_rule" "efs_sg_out1" {
  description       = "Security Group unrestricted outboud rule."
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.efs_sg.id
}
