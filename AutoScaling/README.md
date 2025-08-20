# Terraform AWS Auto Scaling Group (ASG) with Launch Template

This repository demonstrates how to provision an **AWS Auto Scaling Group (ASG)** using **Terraform** to automatically scale EC2 instances based on demand.
It includes a **Launch Template**, **Scaling Policies**, and **CloudWatch Alarms** to ensure seamless elasticity and high availability.

---

## 🚀 Features

* **Launch Template** for EC2 instance configuration.
* **Auto Scaling Group (ASG)** to automatically add/remove instances.
* **Dynamic scaling policies** based on CPU utilization.
* **CloudWatch Alarms** to trigger scale-in and scale-out events.
* Works seamlessly with **Application Load Balancer (ALB)** and **Target Groups**.

---

## ⚙️ Terraform Resources Overview

1. **Launch Template**

   * Created using `aws_launch_template`.
   * Defines the instance AMI, type, key pair, security groups, and user data.

2. **Auto Scaling Group (ASG)**

   * Created using `aws_autoscaling_group`.
   * Launches EC2 instances across multiple availability zones.
   * Integrates with ALB Target Groups for traffic distribution.

3. **Scaling Policies**

   * Defined using `aws_autoscaling_policy`.
   * Triggers scale-in and scale-out based on CloudWatch alarms.

4. **CloudWatch Alarms**

   * Monitors metrics like **CPU utilization**.
   * Invokes scaling policies when thresholds are breached.

---

## 📝 Example Code Snippet

```hcl
# Launch Template
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-launch-template"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = base64encode(<<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install -y nginx
              echo "<h1>Welcome to Terraform Auto Scaling</h1>" > /var/www/html/index.html
              systemctl enable nginx
              systemctl start nginx
              EOF
  )

  network_interfaces {
    security_groups = [aws_security_group.app_sg.id]
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-auto-scaling"
  desired_capacity          = 2
  max_size                  = 4
  min_size                  = 1
  vpc_zone_identifier       = var.subnets
  target_group_arns         = [aws_lb_target_group.app_tg.arn]
  health_check_type         = "EC2"
  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "terraform-asg-instance"
    propagate_at_launch = true
  }
}

# Scale-Out Policy
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out-policy"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# Scale-In Policy
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in-policy"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
}

# CloudWatch Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "cpu-utilization-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "This metric monitors high CPU usage"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}

resource "aws_cloudwatch_metric_alarm" "cpu_low" {
  alarm_name          = "cpu-utilization-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 30
  alarm_description   = "This metric monitors low CPU usage"
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.app_asg.name
  }
  alarm_actions = [aws_autoscaling_policy.scale_in.arn]
}
```

---

## 📊 Outputs

```hcl
output "autoscaling_group_name" {
  value = aws_autoscaling_group.app_asg.name
}

output "launch_template_id" {
  value = aws_launch_template.app_lt.id
}
```

Example output:

```bash
autoscaling_group_name = "app-auto-scaling"
launch_template_id = "lt-0ab12cd34efgh5678"
```
---

## 🌱 Best Practices

* Always parameterize AMI IDs, instance types, and desired capacities in `variables.tf`.
* Use **target tracking scaling** instead of manual CloudWatch-based scaling for simplicity.
* Combine ASG with **Application Load Balancer** for zero-downtime deployments.
* Enable **detailed monitoring** for faster scaling response times.

---

## 📚 References

* [Terraform AWS Auto Scaling Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group)
* [AWS Auto Scaling](https://docs.aws.amazon.com/autoscaling/)
* [Launch Templates](https://docs.aws.amazon.com/autoscaling/ec2/userguide/LaunchTemplates.html)
* [Manage AWS Auto Scaling Groups](https://developer.hashicorp.com/terraform/tutorials/aws/aws-asg)


