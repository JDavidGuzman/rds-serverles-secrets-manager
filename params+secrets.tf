locals {
  db_creds = {
    username = var.username
    password = var.password
  }
}

resource "aws_ssm_parameter" "db_name" {

  name  = "/${var.project}/${terraform.workspace}/database/name"
  type  = "String"
  value = var.database_name

  tags = local.common_tags
}

resource "aws_ssm_parameter" "db_endpoint" {

  name  = "/${var.project}/${terraform.workspace}/database/endpoint"
  type  = "String"
  value = aws_rds_cluster.rds_cluster.endpoint

  tags = local.common_tags
}

resource "aws_secretsmanager_secret" "db_creds" {

  name = "rds-db-credentials/${var.project}/${terraform.workspace}/mysql"

  tags = local.common_tags
}

resource "aws_secretsmanager_secret_version" "db_creds_version" {

  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = jsonencode(local.db_creds)
}