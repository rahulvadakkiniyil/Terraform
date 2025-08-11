resource "aws_eip" "test_eip" {
  instance = "${aws_instance.web-server.id}"
  domain   = "vpc"
}