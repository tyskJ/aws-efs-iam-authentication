# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform output.tf output                                                                                        ║
# ╠═════════════════════════════╤════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╣
# ║ efs_cmk_arn                 │ EFS CMK ARN.                                                                                                       ║
# ╚═════════════════════════════╧════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╝

output "efs_cmk_arn" {
  description = "EFS CMK ARN"
  value       = aws_kms_key.efs_cmk.arn
}
