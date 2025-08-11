resource "aws_instance" "web-server" {
  ami = "ami-0f918f7e67a3323f0"
  key_name = "master"
  instance_type   = "t2.micro"
  user_data       = <<-EOF
    #!/bin/bash
    sudo su         
    yum update -y
    yum install httpd -y
    systemctl start httpd
    systemctl enable httpd
    echo "<html><h1> Welcome to Test Server. Happy Learning... </h1></html>" >> /var/www/html/index.html   
    EOF
}