# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf module                                                                                          ║
# ╠═════════════════╤═══════════════════════════════════╤════════════════════════════════════════════════════════════════════════════════════════════╣
# ║ nw              │ ../modules/vpc_subnet             │ invoke vpc subnet module.                                                                  ║
# ╚═════════════════╧═══════════════════════════════════╧════════════════════════════════════════════════════════════════════════════════════════════╝

module "nw" {
  source = "../modules/vpc_subnet"

  vpc_map         = { "name" = "vpc", "cidr_block" = "10.0.0.0/16", "enable_dns_support" = true, "enable_dns_hostnames" = true }
  subnet_map_list = [{ "name" = "public-subnet-a", "cidr_block" = "10.0.1.0/24", "availability_zone" = "${local.region_name}a", "map_public_ip_on_launch" = true }, { "name" = "private-subnet-a", "cidr_block" = "10.0.2.0/24", "availability_zone" = "${local.region_name}a", "map_public_ip_on_launch" = false }]
  nacl_assoc_list = ["public-subnet-a", "private-subnet-a"]
}
