############################
# Security Group for ALB
############################
resource "aws_security_group" "alb_sg" {
  name        = "alb-sg"
  description = "Allow HTTP inbound traffic to ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }
   ingress {
    from_port   = 8080
    to_port     = 8080
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
  depends_on = [aws_vpc.main]
}

############################
# Security Group for Application
############################

resource "aws_security_group" "application_sg"{
  name = "application"
  description = "Allow"
  vpc_id      = aws_vpc.main.id

  egress{
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffice"
  }
  tags = {
    Name = "Application-sg"
  }
}

############################
# Security Group for Native App
############################
resource "aws_security_group" "native_sg" {
  name        = "native-sg"
  description = "Allow traffic from ALB, Pulsar, and Admin"
  vpc_id      = aws_vpc.main.id

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
  vpc_id      = aws_vpc.main.id

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
  vpc_id      = aws_vpc.main.id

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

# Application Website — Allow 8090 from ALB SG
resource "aws_security_group_rule" "allow_alb_to_application" {
  type                     = "ingress"
  from_port                = 8040
  to_port                  = 8040
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_sg.id
  security_group_id        = aws_security_group.application_sg.id
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

############################
# Allow ALL Traffic from Application SG → Native SG
############################
resource "aws_security_group_rule" "allow_application_to_native" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.application_sg.id
  security_group_id        = aws_security_group.native_sg.id
}

############################
# Allow ALL Traffic from Pulsar SG → Admin SG
############################
resource "aws_security_group_rule" "allow_pulsar_to_admin" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.pulsar_sg.id
  security_group_id        = aws_security_group.admin_sg.id
}

############################
# Allow ALL Traffic from Native SG → Admin SG
############################
resource "aws_security_group_rule" "allow_native_to_admin" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.native_sg.id
  security_group_id        = aws_security_group.admin_sg.id
}

############################
# Allow ALL Traffic from Application SG → Admin SG
############################
resource "aws_security_group_rule" "allow_application_to_admin" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.application_sg.id
  security_group_id        = aws_security_group.admin_sg.id
}

############################
# Allow ALL Traffic from Application SG → PulsarSG
############################
resource "aws_security_group_rule" "allow_application_to_pulsar" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.application_sg.id
  security_group_id        = aws_security_group.pulsar_sg.id
}

############################
# Allow ALL Traffic from Native SG → PulsarSG
############################
resource "aws_security_group_rule" "allow_native_to_pulsar" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.native_sg.id
  security_group_id        = aws_security_group.pulsar_sg.id
}

############################
# Allow ALL Traffic from Admin SG → PulsarSG
############################
resource "aws_security_group_rule" "allow_admin_to_pulsar" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.admin_sg.id
  security_group_id        = aws_security_group.pulsar_sg.id
}

############################
# Allow ALL Traffic from Native SG → Application SG
############################
resource "aws_security_group_rule" "allow_native_to_application" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.native_sg.id
  security_group_id        = aws_security_group.application_sg.id
}

############################
# Allow ALL Traffic from Pulsar SG → Application SG
############################
resource "aws_security_group_rule" "allow_pulsar_to_application" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.pulsar_sg.id
  security_group_id        = aws_security_group.application_sg.id
}

############################
# Allow ALL Traffic from Admin SG → Application SG
############################
resource "aws_security_group_rule" "allow_admin_to_application" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.admin_sg.id
  security_group_id        = aws_security_group.application_sg.id
}