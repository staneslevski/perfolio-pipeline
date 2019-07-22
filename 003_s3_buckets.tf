resource "aws_s3_bucket" "perfolio-pipeline-bucket" {
  bucket = "perfolio-pipeline-bucket"
  acl = "private"
}