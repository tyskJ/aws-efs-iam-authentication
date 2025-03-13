# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform variable.tf variable                                                                                    ║
# ╠══════════════════════════════════╤═══════════════════════════════════╤═══════════════════════════════════════════════════════════════════════════╣
# ║ instanceprofile_name             │ string                            │ Name of the instance profile to be used by the EC2 instances.             ║
# ║ ec2_sg_id                        │ string                            │ Security group ID for the EC2 instances.                                  ║
# ║ subnet_id                        │ string                            │ Subnet ID for the EC2 instances.                                          ║
# ║ ec2_map                          │ map(string)                       │ EC2 settings map.                                                         ║
# ╚══════════════════════════════════╧═══════════════════════════════════╧═══════════════════════════════════════════════════════════════════════════╝

variable "instanceprofile_name" {
  type        = string
  description = "Name of the instance profile to be used by the EC2 instances."
}

variable "ec2_sg_id" {
  type        = string
  description = "Security group ID for the EC2 instances."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instances."
}

variable "ec2_map" {
  type        = map(string)
  description = "EC2 settings map."
}
