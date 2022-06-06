##############
# EC2 MODULE #
##############
module "ec2" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "${var.environment}-${var.project}-frontend"
  instance_count         = "${var.instance_count}"

  ami                    = data.aws_ami.aws-linux.id
  instance_type          = "${var.instance_type}"

  vpc_security_group_ids = [aws_security_group.sg_frontend.id]
  subnet_id              = module.vpc.public_subnets[1]
  tags                   = local.common_tags

}
