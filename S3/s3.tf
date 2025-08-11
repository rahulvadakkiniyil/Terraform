resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "rahulvadakkiniyil"
  acl = "private"

  tags = {
    Name        = "rahulvadakkiniyil"
    Environment = "test"
  }
}