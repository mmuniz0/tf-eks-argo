terraform {
  backend "s3" {
    bucket = "manu-tf-state-app"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
