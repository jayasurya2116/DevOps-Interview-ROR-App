# Create an S3 bucket
resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "rails_app_bucket"
}
