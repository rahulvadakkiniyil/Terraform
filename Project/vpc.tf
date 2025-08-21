resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cidr}"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "main-vpc"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = {
    Name = "main-igw"
  }
  depends_on = ["aws_vpc.main"]
}

resource "aws_nat_gateway" "NATGW" {
    allocation_id = "${aws_eip.EIP.id}"
    subnet_id = "${aws_subnet.public_subnets[0].id}"

    tags = {
        Name  = "NATGW"
    }
    depends_on = ["aws_eip.EIP","aws_subnet.public_subnets"]
  
}

resource "aws_eip" "EIP" {
  domain = "vpc"
  tags = {
    Name = "EIP"
  }

}