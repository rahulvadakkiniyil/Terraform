resource "aws_instance" "my_ec2s" {
  ami = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name = "master"
  tags = {
      Name = "Bastion"
  }
  subnet_id = "${element(aws_subnet.public_subnets.*.id, 0)}"
  vpc_security_group_ids = ["${aws_security_group.elb_security_group.id}"]
  associate_public_ip_address = true 
  depends_on = ["aws_subnet.public_subnets","aws_security_group.elb_security_group"]
  
}