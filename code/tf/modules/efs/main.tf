# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf resource                                                                                        ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ efs                                │ aws_efs_file_system                                 │ FileSystem.                                           ║
# ║ mount_target                       │ aws_efs_mount_target                                │ MountTarget.                                          ║
# ║ filesystem_policy                  │ aws_efs_file_system_policy                          │ FileSystemPolicy.                                     ║
# ║ access_point                       │ aws_efs_access_point                                │ AccessPoint.                                          ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "aws_efs_file_system" "efs" {
  encrypted        = true
  kms_key_id       = var.cmk_arn
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"
  tags = {
    Name = "efs-filesystem"
  }
}

resource "aws_efs_mount_target" "mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_id
  security_groups = [var.efs_sg_id]
}

resource "aws_efs_file_system_policy" "filesystem_policy" {
  file_system_id = aws_efs_file_system.efs.id
  policy = templatefile("${path.module}/json/filesystem-policy.json", {
    Ec2RoleArn = var.ec2_role_arn
  })
}

resource "aws_efs_access_point" "access_point" {
  file_system_id = aws_efs_file_system.efs.id
  posix_user {
    uid = "1500"
    gid = "1500"
  }
  root_directory {
    path = "/App"
    creation_info {
      owner_uid   = "1500"
      owner_gid   = "1500"
      permissions = "0755"
    }
  }
  tags = {
    Name = "efs-access-point"
  }
}
