#### Rede Pública do Load Balance #####
resource "aws_security_group" "alb" {
  name        = "balancers-security-group"
  description = "Allow traffic from api gateway to ecs"
  vpc_id      = aws_vpc.this # module.vpc.vpc_id
}

resource "aws_security_group_rule" "inbound_alb" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "outbound_alb" {
  type              = "egress"
  from_port         = 0    # qualquer porta    80
  to_port           = 0    # qualquer porta    80
  protocol          = "-1" #qualquer protocolo  "tcp" 
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb.id
}

#### Rede Privada do Cluster ECS #####
resource "aws_security_group" "private" {
  name        = "cluster-security-group"
  description = "Cluster ecs security group"
  vpc_id      = aws_vpc.this # module.vpc.vpc_id
}

resource "aws_security_group_rule" "inbound_ecs" {
  type                     = "ingress"
  from_port                = 3000
  to_port                  = 3000
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb.id # Restringe o acesso de requisições apenas a rede pública
  security_group_id        = aws_security_group.private.id
}

resource "aws_security_group_rule" "outbound_ecs" {
  type              = "egress"
  from_port         = 0    # qualquer porta
  to_port           = 0    # qualquer porta
  protocol          = "-1" #qualquer protocolo
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.private.id
}

### Rede do RDS ####
# resource "aws_security_group" "rds" {
#   name        = "rds-security-group"
#   description = "RDS security group"
#   vpc_id      = module.vpc.vpc_id
# }
# 
# resource "aws_security_group_rule" "inbound_rds" {
#   type              = "ingress"
#   from_port         = 5432
#   to_port           = 5432
#   protocol          = "tcp"
#   source_security_group_id = aws_security_group.private.id  # Restringe o acesso de requisições apenas a rede privada
#   security_group_id = aws_security_group.private.id
# }
# 
# resource "aws_security_group_rule" "outbound_rds" {
#   type              = "egress"
#   from_port         = 5432
#   to_port           = 5432
#   protocol          = "tcp"
#   cidr_blocks       = ["0.0.0.0/0"]
#   security_group_id = aws_security_group.private.id
# }
