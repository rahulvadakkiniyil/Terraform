resource "aws_s3_bucket" "my_s3_bucket" {
  bucket = "yourbucketname"
  acl = "private"

  tags = {
    Name        = "bucketname"
    Environment = "test"
  }
}
