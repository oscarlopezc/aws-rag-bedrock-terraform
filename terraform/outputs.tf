###################################
# EC2 PUBLIC IP
###################################

output "ec2_public_ip" {

  description = "Public IP of EC2 instance"

  value = aws_instance.docker_host.public_ip

}

###################################
# EC2 PUBLIC DNS
###################################

output "ec2_public_dns" {

  description = "Public DNS of EC2 instance"

  value = aws_instance.docker_host.public_dns

}

###################################
# VPC ID
###################################

output "vpc_id" {

  description = "AWS VPC ID"

  value = aws_vpc.main.id

}