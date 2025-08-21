resource "aws_alb" "common_load_balancer" {
  load_balancer_type = "application"
  name            = "Common-LoadBalancer"
  internal        = false
  security_groups = ["${aws_security_group.elb_security_group.id}"]

tags = {
    Name = "common_load_balancer"
  }
  subnets = "${aws_subnet.public_subnets.*.id}"
  depends_on = [aws_subnet.public_subnets,aws_security_group.elb_security_group]
}


resource "aws_alb_target_group" "native" {
	name	= "native"
	vpc_id	= "${aws_vpc.main.id}"
	port	= "80"
	protocol	= "HTTP"
	health_check {
                path = "/"
                port = "80"
                protocol = "HTTP"
                healthy_threshold = 5
                unhealthy_threshold = 2
                interval = 5
                timeout = 4
                matcher = "200"
        } 
    tags = {
        Name = "native"
    }
  depends_on = [aws_vpc.main]
}

resource "aws_alb_target_group_attachment" "targetgroup_alb" {
  target_group_arn = "${aws_alb_target_group.native.arn}"
  count    = "${length(var.public_subnet_cidr)}"
  port     = 80
  target_id        = "${aws_instance.my_ec2s.id}"
}

resource "aws_alb_listener" "front_end" {
  load_balancer_arn = "${aws_alb.common_load_balancer.arn}"
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = "${aws_alb_target_group.native.arn}"
  }
 
  depends_on = ["aws_alb.common_load_balancer","aws_alb_target_group.native"]
}
