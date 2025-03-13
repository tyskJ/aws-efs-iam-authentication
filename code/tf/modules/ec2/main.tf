# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf resource                                                                                        ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ ssh_keygen                         │ tls_private_key                                     │ setting SSH keygen algorithm.                         ║
# ║ keypair_pem                        │ local_sensitive_file                                │ create private key file to local.                     ║
# ║ keypair                            │ aws_key_pair                                        │ Key Pair.                                             ║
# ║ ec2_instance                       │ aws_instance                                        │ EC2 Instance.                                         ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "tls_private_key" "ssh_keygen" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_sensitive_file" "keypair_pem" {
  filename        = "./.keypair/keypair.pem"
  content         = tls_private_key.ssh_keygen.private_key_pem
  file_permission = "0600"
}

resource "aws_key_pair" "keypair" {
  key_name   = "keypair"
  public_key = tls_private_key.ssh_keygen.public_key_openssh
  tags = {
    Name = "keypair"
  }
}

resource "aws_instance" "ec2_instance" {
  ami                         = var.ec2_map.ami
  associate_public_ip_address = true
  iam_instance_profile        = var.instanceprofile_name
  key_name                    = aws_key_pair.keypair.key_name
  instance_type               = var.ec2_map.instancetype
  disable_api_termination     = false
  root_block_device {
    volume_size           = var.ec2_map.volumesize
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
    encrypted             = true
    tags = {
      Name = var.ec2_map.volname
    }
  }
  metadata_options {
    http_tokens = "required"
  }
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.ec2_sg_id]
  tags = {
    Name = var.ec2_map.name
  }
}
