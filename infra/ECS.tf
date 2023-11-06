module "ecs" {
  source = "terraform-aws-modules/ecs/aws" 

  cluster_name = var.environment
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        # weight = 50
        weight = 100
      }
    }
  }
}

resource "aws_ecs_task_definition" "api-task" {
  family                   = "api-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.responsibility.arn
  container_definitions    = jsonencode(
        [
            {
                "name" = var.environment
                "image" = "${aws_ecr_repository.repository.repository_url}:latest"
                "cpu" = 256
                "memory" = 512
                "essential" = true
                "portMappings" = [
                    {
                    "containerPort" = 3000
                    "hostPort" = 3000
                    }
                ],
                "environment" = [
                  {
                    "name" = "DATABASE_URL"
                    "value" = "postgresql://${aws_ssm_parameter.db_username.value}:${aws_ssm_parameter.db_password.value}@${aws_db_instance.rds-instance.endpoint}:5432/${aws_ssm_parameter.db_name.value}?schema=public"
                  },
                  {
                    "name" = "DB_USERNAME",
                    "value" = aws_ssm_parameter.db_username.value
                  },
                  {
                    "name" = "DB_PASSWORD",
                    "value" = aws_ssm_parameter.db_password.value
                  },
                  {
                    "name" = "DB_NAME",
                    "value" = aws_ssm_parameter.db_name.value
                  }
                ]
            }
        ]
    )

  # runtime_platform {
  #   operating_system_family = "LINUX"
  #   cpu_architecture        = "ARM64"
  # }
}

resource "aws_ecs_service" "api-service" {
  name            = "api-service"
  cluster         = module.ecs.cluster_id
  task_definition = aws_ecs_task_definition.api-task.arn
  desired_count   = 2

  load_balancer {
    target_group_arn = aws_lb_target_group.orders-tg.arn
    container_name   = var.environment
    container_port   = 3000
  }

  network_configuration {
    subnets = module.vpc.private_subnets
    security_groups = [aws_security_group.private.id]
    assign_public_ip = true
  }

  # capacity_provider_strategy {
  #   capacity_provider = "FARGATE"
  #   weight = 1
  # }
}