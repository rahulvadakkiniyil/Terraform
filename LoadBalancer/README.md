# Terraform AWS Load Balancer with Target Groups

This repository demonstrates how to provision an **Application Load Balancer (ALB)** on AWS using **Terraform**, and attach it to one or more **Target Groups** for efficient traffic routing.

The setup is ideal for highly-available web applications, microservices, or APIs that require intelligent traffic distribution across EC2 instances, ECS tasks, or Lambda functions.

---

## 🚀 Features

* **Application Load Balancer (ALB)** configured with Terraform.
* **Target Groups** with health checks for monitoring target availability.
* **Listeners** to forward requests based on rules (HTTP/HTTPS).
* **Dynamic attachment of targets** (e.g., EC2 instances or ECS services).
* Easy to extend for multi-environment (dev, stage, prod) setups.

---

## ⚙️ Terraform Resources Overview

1. **Load Balancer**

   * Created using `aws_lb`
   * Internet-facing or internal depending on configuration.
   * Deployed across multiple subnets for high availability.

2. **Target Groups**

   * Created with `aws_lb_target_group`
   * Supports HTTP/HTTPS protocols.
   * Health checks configured for application resilience.

3. **Listeners**

   * Defined using `aws_lb_listener`
   * Routes traffic from the Load Balancer to Target Groups.
   * Can be extended with path-based or host-based routing rules.

---

## 📝 Example Code Snippet

```hcl
resource "aws_lb" "app_lb" {
  name               = "app-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.subnets

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 2
    timeout             = 5
    matcher             = "200"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
```

---

## 📊 Outputs

After a successful `terraform apply`, useful details like the ALB DNS name are exported:

```hcl
output "load_balancer_dns_name" {
  value = aws_lb.app_lb.dns_name
}
```

Example:

```bash
load_balancer_dns_name = "app-loadbalancer-1234567890.us-east-1.elb.amazonaws.com"
```

## 🌱 Best Practices

* Always parameterize VPC, subnets, and ports in `variables.tf`.
* Use **Terraform workspaces** or `tfvars` files to manage multiple environments.
* Enable **access logs** on ALB for better observability.
* For production, consider enabling **HTTPS listener** with ACM certificates.

---

## 📚 References

* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group_attachment
* https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
* https://developer.hashicorp.com/terraform/language/values/outputs
