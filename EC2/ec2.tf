resource "aws_instance" "terraformcreated" {
  ami = "ami-0f918f7e67a3323f0"
  key_name = "master"
  instance_type = "t3.micro"

  tags = {
    Name = "terraform"
  }
  user_data = <<-EOF
                #!/bin/bash
                sudo apt update
                sudo apt install -y apache2
                sudo systemctl enable apache2
                sudo systemctl start apache2
                sudo systemctl status apache2
                EOF

}