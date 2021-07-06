output "aurora_endpoint" {
  value     = aws_rds_cluster.rds_cluster.endpoint
  sensitive = true
}

output "bastion_ip" {
  value     = aws_instance.bastion.public_ip
  sensitive = true
}

output "secret_string" {
  value     = aws_secretsmanager_secret_version.db_creds_version.secret_string
  sensitive = true
}