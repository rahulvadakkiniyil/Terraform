variable "region" {
  
}

variable "vpc_cidr" {
    
}

variable "instance_type" {
  default  = "t2.micro"
}

variable "ami" {
  default = "ami-0f918f7e67a3323f0"
  
}

variable "public_subnet_cidr" {
  type = list(string)
}


variable "private_subnet_cidr" {
  type = list(string)
}

variable "availability_zone" {
  type = list(string)
}

variable "public_subnet_names" {
  type = list(string)
  
}

variable "private_subnet_names" {
  type = list(string)
  
}

