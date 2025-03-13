# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform variable.tf variable                                                                                    ║
# ╠══════════════════════════════════╤═══════════════════════════════════╤═══════════════════════════════════════════════════════════════════════════╣
# ║ vpc_map                          │ map(string)                       │ VPC settings map.                                                         ║
# ║ subnet_map_list                  │ list(map(string))                 │ Subnet settings map list.                                                 ║
# ║ nacl_assoc_list                  │ list(string)                      │ NACL settings list.                                                       ║
# ╚══════════════════════════════════╧═══════════════════════════════════╧═══════════════════════════════════════════════════════════════════════════╝

variable "vpc_map" {
  type        = map(string)
  description = "VPC Settings map."
}

variable "subnet_map_list" {
  type        = list(map(string))
  description = "Subnet settings map list."
}

variable "nacl_assoc_list" {
  type        = list(string)
  description = "NACL settings list."
}
