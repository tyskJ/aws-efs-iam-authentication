# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform output.tf output                                                                                        ║
# ╠═════════════════════════════╤════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
# ║ instanceprofile_name        │ Instance Profile Name.                                                                                             ║
# ║ ec2_role_arn                │ EC2 IAM Role ARN.                                                                                                  ║
# ╚═════════════════════════════╧════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

output "instanceprofile_name" {
  description = "EC2 Instance Profile Name"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}

output "ec2_role_arn" {
  description = "EC2 IAM Role ARN"
  value       = aws_iam_role.ec2_role.arn
}
