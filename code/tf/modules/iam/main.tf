# ╔══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════╗
# ║ EFS IAM Authentication Stack - Terraform main.tf resource                                                                                        ║
# ╠════════════════════════════════════╤═════════════════════════════════════════════════════╤═══════════════════════════════════════════════════════╣
# ║ ec2_role                           │ aws_iam_role                                        │ IAM Role for EC2.                                     ║
# ║ ec2_instance_profile               │ aws_iam_instance_profile                            │ IAM Instance Profile for EC2.                         ║
# ╚════════════════════════════════════╧═════════════════════════════════════════════════════╧═══════════════════════════════════════════════════════╝

resource "aws_iam_role" "ec2_role" {
  name               = "iam-role-ec2"
  description        = "IAM Role for EC2."
  assume_role_policy = file("${path.module}/json/ec2-trust-policy.json")
  tags = {
    Name = "iam-role-ec2"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:${var.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = aws_iam_role.ec2_role.name
  role = aws_iam_role.ec2_role.name
}
