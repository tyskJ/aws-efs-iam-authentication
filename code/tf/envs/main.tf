# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf module                                                                                          ║
# ╠═════════════════╤═══════════════════════════════════╤════════════════════════════════════════════════════════════════════════════════════════════╣
# ║ nw              │ ../modules/vpc_subnet             │ invoke vpc subnet module.                                                                  ║
# ║ iam             │ ../modules/iam                    │ invoke IAM module.                                                                         ║
# ║ kms             │ ../modules/kms                    │ invoke KMS module.                                                                         ║
# ║ ec2             │ ../modules/ec2                    │ invoke EC2 module.                                                                         ║
# ║ efs             │ ../modules/efs                    │ invoke EFS module.                                                                         ║
# ╚═════════════════╧═══════════════════════════════════╧════════════════════════════════════════════════════════════════════════════════════════════╝

module "nw" {
  source = "../modules/vpc_subnet"

  vpc_map         = { "name" = "vpc", "cidr_block" = "10.0.0.0/16", "enable_dns_support" = true, "enable_dns_hostnames" = true }
  subnet_map_list = [{ "name" = "public-subnet-a", "cidr_block" = "10.0.1.0/24", "availability_zone" = "${local.region_name}a", "map_public_ip_on_launch" = true }, { "name" = "private-subnet-a", "cidr_block" = "10.0.2.0/24", "availability_zone" = "${local.region_name}a", "map_public_ip_on_launch" = false }]
  nacl_assoc_list = ["public-subnet-a", "private-subnet-a"]
}

module "iam" {
  source = "../modules/iam"

  partition = local.partition_name
}

module "kms" {
  source = "../modules/kms"
}

module "ec2" {
  source = "../modules/ec2"

  instanceprofile_name = module.iam.instanceprofile_name
  ec2_sg_id            = module.nw.ec2_sg_id
  subnet_id            = module.nw.subnets["public-subnet-a"].id
  ec2_map              = { "name" = "ec2", "instancetype" = "t3.large", "volname" = "ebs-root", "volumesize" = "30", "ami" = "ami-0a290015b99140cd1" }
}

module "efs" {
  source = "../modules/efs"

  efs_sg_id = module.nw.efs_sg_id
  subnet_id = module.nw.subnets["private-subnet-a"].id
  cmk_arn   = module.kms.efs_cmk_arn
  ec2_role_arn = module.iam.ec2_role_arn
}
