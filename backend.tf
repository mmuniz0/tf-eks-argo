terraform {
  backend "s3" {
    bucket = "your-terraform-state-bucket" 
    key    = "path/to/environment/terraform.tfstate" 
    region = "us-west-2" 
  }
}
