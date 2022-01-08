output "db_subnet_1_id" {
  value = aws_subnet.db_subnet_1.id
}

output "db_subnet_2_id" {
  value = aws_subnet.db_subnet_2.id
}

output "database_endpoint" {
  value = aws_db_instance.database.endpoint
}

output "database_password" {
  value = random_password.password[0].result
  sensitive = true
}