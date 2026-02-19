data "aws_ami" "al2023_latest" {
  most_recent = true
  owners = ["amazon"]

  filter {
    name = "name"
    values = ["al2023-ami-*"]
  }

#   name_regex = "^al2023-ami-[0-9]{4}.[0-9].[0-9]{8}.[0-9]-kernel-[0-9]+.[0-9]+-x86_64"
  filter {
    name = "architecture"
    values = ["arm64"]
  }

}

resource "aws_launch_template" "main" {
  name_prefix   = "name"
  image_id      = data.aws_ami.al2023_latest.id
  instance_type = "t4g.small"
  user_data = base64encode(<<EOF
#!/bin/bash

sudo yum upgrade -y
sudo yum install -y httpd
echo "Hello world!" > /var/www/html/index.html
sudo systemctl start httpd
EOF 
  )
  tags = {
    Name = "main"
  }
   network_interfaces {
    associate_public_ip_address = true
    security_groups = [ aws_security_group.main.id ]
  }
}

resource "aws_autoscaling_group" "main" {
  vpc_zone_identifier = module.vpc.public_subnets
  desired_capacity   = 1
  max_size           = 3
  min_size           = 1


  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}