terraform {
  backend "s3" {
    bucket = "terraform-state-tech"
    key    = "Prod/terraform.tfstate"
    region = "us-east-1"
  }
}
