module "prod" {
  source = "../../infra"

  environment       = "prod"
  repository_name   = "order-ecr"
  responsibilityIAM = "prod"
}

output "IP_alb" {
  value = module.prod.IP
}

output "DB" {
  value = module.prod.rds_endpoint
}


output "ECR_repository_url" {
  value = module.prod.ecr_repository_url
}

