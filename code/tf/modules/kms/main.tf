# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf resource                                                                                        ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ efs_cmk                            │ aws_kms_key                                         │ EFS CMK.                                              ║
# ║ efs_cmk_alias                      │ aws_kms_alias                                       │ EFS CMK ALIAS.                                        ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "aws_kms_key" "efs_cmk" {
  description             = "EFS CMK"
  enable_key_rotation     = true
  deletion_window_in_days = 7
  key_usage               = "ENCRYPT_DECRYPT"
  is_enabled              = true
  tags = {
    Name = "efs-cmk"
  }
}

resource "aws_kms_alias" "efs_cmk_alias" {
  name          = "alias/efs-cmk"
  target_key_id = aws_kms_key.efs_cmk.key_id
}
