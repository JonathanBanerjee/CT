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



# resource "aws_instance" "web" {
#   ami                         = data.aws_ami.al2023_latest.id
#   instance_type               = "t4g.small"
#   associate_public_ip_address = true
#   subnet_id                   = aws_subnet.main.id
#   vpc_security_group_ids      = [ aws_security_group.main.id ]
#   user_data = <<EOF
# #!/bin/bash

# sudo yum upgrade -y
# sudo yum install -y httpd
# echo "Hello world!" > /var/www/html/index.html
# sudo systemctl start httpd
# EOF

#   tags = {
#     Name = "main"
#   }
# }

resource "aws_launch_template" "main" {
  name_prefix   = "name"
  image_id      = data.aws_ami.al2023_latest.id
  instance_type = "t4g.small"
  vpc_security_group_ids      = [ aws_security_group.main.id ]
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
  
}

resource "aws_autoscaling_group" "main" {
  vpc_zone_identifier = [aws_subnet.main.id]
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1

  launch_template {
    id      = aws_launch_template.main.id
    version = "$Latest"
  }
}