resource "aws_security_group" "sg_rds" {

  description = "Allow access to RDS Cluster"
  name        = "${local.prefix}-rds"
  vpc_id      = aws_vpc.main.id

  tags = local.common_tags
}

resource "aws_security_group_rule" "allow_rds_access_from_bastion" {

  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.sg_rds.id
  source_security_group_id = aws_security_group.bastion.id
}

resource "aws_db_subnet_group" "rds_subnet_group" {

  name       = "${local.prefix}-rds-subnet-group"
  subnet_ids = [aws_subnet.rds_subnet[0].id, aws_subnet.rds_subnet[1].id]

  tags = local.common_tags
}

resource "aws_rds_cluster" "rds_cluster" {

  cluster_identifier     = "${local.prefix}-rds-cluster"
  engine                 = "aurora-mysql"
  engine_mode            = "serverless"
  engine_version         = "5.7.mysql_aurora.2.07.1"
  database_name          = aws_ssm_parameter.db_name.value
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  master_username        = jsondecode(aws_secretsmanager_secret_version.db_creds_version.secret_string)["username"]
  master_password        = jsondecode(aws_secretsmanager_secret_version.db_creds_version.secret_string)["password"]
  enable_http_endpoint   = true
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sg_rds.id]


  scaling_configuration {
    auto_pause               = true
    max_capacity             = 8
    min_capacity             = 1
    seconds_until_auto_pause = 300
  }

  tags = local.common_tags
}