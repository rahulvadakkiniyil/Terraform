resource "aws_security_group" "elb_security_group" {
  name        = "ALB-SG"
  description = "Allow HTTP inbound traffic, Allow all outbound traffic"
  vpc_id      = aws_vpc.main.id
  
  ingress {
    # HTTP
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP inbound"
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    description     = "Allow all traffic outbound"
  }

  tags = {
    Name = "EC2-SG"
  }

  depends_on = [aws_vpc.main]
}

resource "aws_security_group" "native" {
  name        = "native"
  description = "Internet reaching access for native"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_security_group.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "native_security_group"
  }

  depends_on = [aws_vpc.main, aws_security_group.elb_security_group]
}

resource "aws_security_group" "pulsar" {
  name        = "pulsar"
  description = "Internet reaching access for pulsar"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_security_group.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "pulsar_security_group"
  }

  depends_on = [aws_vpc.main, aws_security_group.elb_security_group]
}

resource "aws_security_group" "admin-website" {
  name        = "admin-website"
  description = "Internet reaching access for admin website"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 8093
    to_port         = 8093
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_security_group.id]
  }
  
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "admin-website"
  }

  depends_on = [aws_vpc.main, aws_security_group.elb_security_group]
}