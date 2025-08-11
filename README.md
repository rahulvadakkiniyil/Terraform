# Terraform Provisioners Explained — A Beginner’s Guide
If you’ve been playing around with Terraform, you already know that it’s a tool to define and manage your infrastructure as code.
But sometimes, just creating infrastructure isn’t enough — you might need to run scripts, install packages, or configure things after the resource is created.

##  What is a Terraform Provisioner?

In simple words:
A provisioner in Terraform lets you execute scripts or commands on a resource after it’s created or before it’s destroyed.

## Types of Provisioners
Terraform offers a few different provisioners. Here are the most common:

1) local-exec
   Runs a command on the machine where Terraform is executed (your local system or CI/CD runner).

   Example:

   ```
   resource "aws_instance" "my_vm" {
   ami           = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"

   provisioner "local-exec" {
    command = "echo Instance ${self.id} created successfully!"
   }
   }
   ```
2) remote exec
   Runs commands on the remote resource after it’s created. Usually used for configuring servers right after they start.

   Example:
   
   ```
   resource "aws_instance" "my_vm" {
   ami           = "ami-0c55b159cbfafe1f0"
   instance_type = "t2.micro"

   provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install nginx -y"
    ]
   }

   connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    host     = self.public_ip
   }
   }
   ```
