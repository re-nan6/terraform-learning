provider "aws" {
  region = "us-east-2"
}

resource "aws_vpc" "main" {
  cidr_block = "0.0.0.0/0"
  
}
resource "aws_instance" "example" {
  ami = "ami-0fb653ca2d3203ac1"
  instance_type = "t2.micro"
  vpc_security_group_ids = [ aws_security_group.instance.id ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF
  
  user_data_replace_on_change = true

  tags = {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "example" {
  name        = "terraform-example-instance"
  description = "example"
  vpc_id      = aws_vpc.main.id
  tags = {
    Name = "example"
  }
}

resource "aws_vpc_security_group_ingress_rule" "instance" { 
  security_group_id =  aws_security_group.example.id
  from_port = 8080
  to_port = 8080
  ip_protocol = "tcp"
  cidr_ipv4 = "0.0.0.0/0"

}