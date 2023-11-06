resource "aws_ssm_parameter" "db_name" {
  name  = "/${var.environment}/orders/database/name"
  type  = "String"
  value = "tech_fase_1"
}

resource "aws_ssm_parameter" "db_username" {
  name  = "/${var.environment}/orders/database/username"
  type  = "String"
  value = "tech1"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.environment}/orders/database/password"
  type  = "SecureString"
  value = "tech1_123"
}
