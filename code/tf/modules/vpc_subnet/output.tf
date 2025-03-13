# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform output.tf output                                                                                        ║
# ╠═════════════════════════════╤════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
# ║ subnets                     │ Subnet List Map.                                                                                                   ║
# ║ ec2_sg_id                   │ SG ID for EC2.                                                                                                     ║
# ║ efs_sg_id                   │ SG ID for EFS.                                                                                                     ║
# ╚═════════════════════════════╧════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

output "subnets" {
  description = "Subnet List Map."
  value = aws_subnet.subnet
}

output "ec2_sg_id" {
  description = "SG ID for EC2."
  value = aws_security_group.ec2_sg.id
}

output "efs_sg_id" {
  description = "SG ID for EFS."
  value = aws_security_group.efs_sg.id
}
