#backend to store the state file in S3 bucket

terraform {
    backend "s3" {
      bucket = "meemo-surya-1"
      key = "terraform/surya-mallow/terraform.tfstate"
      region = "eu-west-1"
      profile = "surya-profile"
    }
}
