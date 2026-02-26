# resource "aws_security_group" "main" {
#   name        = "main"
#   description = "Allow http inbound traffic and all outbound traffic"
#   vpc_id      = module.vpc.vpc_id

#   ingress {
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1" 
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name = "main"
#   }
# }

//As a module
module "web_server_sg" {
  name        = "main"
  vpc_id = module.vpc.vpc_id
  source = "terraform-aws-modules/security-group/aws"
  description = "Allow http inbound traffic and all outbound traffic"

//Ingress rules control what traffic is allowed to the instances
ingress_cidr_blocks = ["0.0.0.0/0"]
ingress_rules = ["http-80-tcp"]


//Egress rules control the traffic that instances are able to send out. 
egress_rules = ["all-all"]

tags = {
    Name = "main"
  }
}