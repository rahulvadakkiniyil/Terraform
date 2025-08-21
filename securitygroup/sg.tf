############################
# Security Group for ALB
############################
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic to ALB"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "ALB-SG"
  }
}

############################
# Security Group for Native App
############################
resource "aws_security_group" "native_sg" {
  name        = "native-sg"
  description = "Allow traffic from ALB, Pulsar, and Admin"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Native-SG"
  }
}

############################
# Security Group for Pulsar App
############################
resource "aws_security_group" "pulsar_sg" {
  name        = "pulsar-sg"
  description = "Allow Pulsar traffic from ALB only"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Pulsar-SG"
  }
}

############################
# Security Group for Admin Website
############################
resource "aws_security_group" "admin_sg" {
  name        = "admin-sg"
  description = "Allow Admin traffic from ALB only"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "Admin-SG"
  }
}

############################
# SG Rules - Allow ALB to Apps
############################

# Native App — Allow 80 from ALB SG
resource "aws_security_group_rule" "allow_alb_to_native" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.native_sg.id
}

# Pulsar App — Allow 8080 from ALB SG
resource "aws_security_group_rule" "allow_alb_to_pulsar" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.pulsar_sg.id
}

# Admin Website — Allow 8090 from ALB SG
resource "aws_security_group_rule" "allow_alb_to_admin" {
  type                     = "ingress"
  from_port                = 8090
  to_port                  = 8090
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.admin_sg.id
}

############################
# Allow ALL Traffic from Pulsar SG → Native SG
############################
resource "aws_security_group_rule" "allow_pulsar_to_native" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.pulsar_sg.id
  security_group_id        = aws_security_group.native_sg.id
}

############################
# Allow ALL Traffic from Admin SG → Native SG
############################
resource "aws_security_group_rule" "allow_admin_to_native" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.admin_sg.id
  security_group_id        = aws_security_group.native_sg.id
}