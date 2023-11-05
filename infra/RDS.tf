resource "aws_db_instance" "rds-instance" {
  allocated_storage    = 20
  storage_type        = "gp2"
  engine               = "postgres"
  engine_version       = "13.4"
  instance_class       = "db.t2.micro"
  
  db_name              = "tech_fase_1"
  username             = "tech1"
  password             = "tech1"
  
  parameter_group_name = "default.postgres13"

  vpc_security_group_ids = [aws_security_group.rds.id]
  
  backup_retention_period = 7
  skip_final_snapshot     = true
  delete_automated_backups = true

}

output "rds_endpoint" {
  value = aws_db_instance.rds-instance.endpoint
}