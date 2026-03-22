terraform {
  backend "s3" {
    bucket         = "st-terraform-state-nonprod"
    key            = "monitoring/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "st-terraform-locks"
    encrypt        = true
  }
}
