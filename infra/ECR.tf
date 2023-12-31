resource "aws_ecr_repository" "repository" {
  name = "${var.environment}_${var.repository_name}"
  force_delete = true
}

output "ecr_repository_url" {
  value = aws_ecr_repository.repository.repository_url
}