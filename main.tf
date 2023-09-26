data "aws_ami" "web_ami"{
  most_recent = true
  owners = ["amazon"]

  filter{
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_instance" "web1" {
  ami           =  data.aws_ami.web_ami.id 
  instance_type =  var.instance_type 
}
