
###################################
# UBUNTU AMI
###################################

data "aws_ami" "ubuntu" {

  most_recent = true

  owners = ["099720109477"]

  filter {

    name = "name"

    values = [
      "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
    ]

  }

}

###################################
# EC2 INSTANCE
###################################

resource "aws_instance" "docker_host" {

  ami = data.aws_ami.ubuntu.id

  instance_type = "t2.micro"

  subnet_id = aws_subnet.main.id

  key_name = "sre-devops-key-v3"

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]
  associate_public_ip_address = true

  user_data = file("${path.module}/userdata/docker-install.sh")

  tags = {
    Name = "sre-devops-ec2"
  }

}
