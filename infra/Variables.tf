variable "repository_name" {
    type = string
    default = "order-ecr"
}

variable "responsibilityIAM" {
  type = string
  default = "prod"
}

variable "environment" {
  type = string
  default = "prod"
}

variable "aws_region" {
  type = string
  default = "us-east-1"
}
