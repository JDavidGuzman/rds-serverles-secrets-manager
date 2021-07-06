data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_security_group" "bastion" {

  description = "Allow access to Bastion Host for Aurora"
  name        = "${local.prefix}-bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = [var.user_ip]
  }

  egress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.common_tags
}

resource "aws_security_group_rule" "allow_bastion_access_to_rds" {
  type                     = "egress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.bastion.id
  source_security_group_id = aws_security_group.sg_rds.id
}


resource "aws_key_pair" "bastion" {

  key_name   = "${local.prefix}-bastion"
  public_key = file(var.key_file)
}

resource "aws_instance" "bastion" {

  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t3.nano"
  key_name      = aws_key_pair.bastion.key_name
  subnet_id     = aws_subnet.bastion_subnet.id

  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = merge(
    local.common_tags,
    tomap({ "Name" = "${local.prefix}-bastion" })
  )
}