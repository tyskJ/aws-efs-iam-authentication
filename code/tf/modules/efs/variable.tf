# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform variable.tf variable                                                                                    ║
# ╠══════════════════════════════════╤═══════════════════════════════════╤═══════════════════════════════════════════════════════════════════════════╣
# ║ efs_sg_id                        │ string                            │ Security group ID for the EFS MountTarget.                                ║
# ║ subnet_id                        │ string                            │ Subnet ID for the EFS MountTarget.                                        ║
# ║ cmk_arn                          │ string                            │ CMK ARN for the EFS FileSystem.                                           ║
# ║ ec2_role_arn                     │ string                            │ EC2 Role ARN.                                                             ║
# ╚══════════════════════════════════╧═══════════════════════════════════╧═══════════════════════════════════════════════════════════════════════════╝

variable "efs_sg_id" {
  type        = string
  description = "Security group ID for the EFS MountTarget."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EFS MountTarget."
}

variable "cmk_arn" {
  type        = string
  description = "CMK ARN for the EFS FileSystem."
}

variable "ec2_role_arn" {
  type        = string
  description = "EC2 Role ARN."
}
