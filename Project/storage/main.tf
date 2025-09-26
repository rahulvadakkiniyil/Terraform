resource "aws_s3_bucket" "storage" {
  bucket = "my-storage-bucket-rahul"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
   backend "s3" {
    bucket = "my-terraform-state-bucket"  # replace with your bucket name
    key    = "terraform.tfstate"           # path inside the bucket
    region = "us-east-2"                   # replace with your region
    # encrypt = true  # optional, enables server-side encryption
  }
}

resource "aws_s3_bucket_public_access_block" "storage" {
  bucket = "${aws_s3_bucket.storage.id}"

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
resource "aws_s3_bucket_versioning" "storage_example" {
  bucket = aws_s3_bucket.storage.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_policy" "storage-policy" {
  bucket = aws_s3_bucket.storage.id

  policy = <<EOT
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowS3ObjectActions",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::345594561060:root"
      },
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": "arn:aws:s3:::my-storage-bucket-rahul/*"
    }
  ]
}
EOT
}