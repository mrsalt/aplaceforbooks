output "public_url" {
  description = "Public URL for webserver"
  value       = "https://${aws_instance.webserver.public_ip}"
}

output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.db.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.db.username
}