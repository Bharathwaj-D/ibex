data "aws_ami" "web_ami"{
  most_recent = true
  owners = ["amazon"]

  filter{
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
locals {
  ingress_rules = [{
    port = 443
    description = "ingress rules for 443"
  },
  {
    port = 80
    description = "ingress rules for 443"
  },
  {
    port = 22
    description = "ingress rules for 22"
  }]
}

resource "aws_instance" "web" {
    ami           =  data.aws_ami.web_ami.id 
    instance_type =  var.instance_type 
    subnet_id = var.public_subnet
    vpc_security_group_ids = [aws_security_group.bharathsecurity.id]
    tags = {
           Name = var.enviroment_name
    }
} 
 

resource "aws_security_group" "bharathsecurity" {
  name        = "terraform-security-new"
  description = "Allow Inbound Traffic on Port 80"
  vpc_id      = var.vpcid

  dynamic "ingress" {
    for_each = local.ingress_rules

    content {
      description      = ingress.value.description
      from_port        = ingress.value.port 
      to_port          = ingress.value.port 
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
    }
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
   
  }
}




