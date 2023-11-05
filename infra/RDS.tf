resource "aws_db_instance" "rds-instance" {    
  allocated_storage    = 20
  storage_type        = "gp2"
  engine               = "postgres"
  engine_version       = "14.9"
  instance_class       = "db.t3.micro"
  
  db_name              = "tech_fase_1"
  username             = "tech1"
  password             = "tech1_123"
  
  # parameter_group_name = "default.postgres13"
  # vpc_security_group_ids = [aws_security_group.private.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet.id
  
  backup_retention_period = 7
  skip_final_snapshot     = true
  delete_automated_backups = true

}

resource "aws_db_subnet_group" "db_subnet" {
  name = "db_subnet"
  subnet_ids = module.vpc.private_subnets
}

output "rds_endpoint" {
  value = aws_db_instance.rds-instance.endpoint
}