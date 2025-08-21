resource "aws_ecr_repository" "native" {
  name                 = "native"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "pulsar" {
  name                 = "pulsar"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "application" {
  name                 = "application"
  image_tag_mutability = "MUTABLE"
}

resource "aws_ecr_repository" "admin-website" {
  name                 = "admin-website"
  image_tag_mutability = "MUTABLE"
}
