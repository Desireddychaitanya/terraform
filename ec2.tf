resource "aws_instance" "web" {
  ami             = "ami-0a3277ffce9146b74"
  instance_type   = "t3.micro"
  count           = 2
  security_groups = [aws_security_group.TF_SG.name]
  key_name = "TF-key"
  user_data = file("script.sh")
  tags = {
    Name = "HelloWorld1"
  }
}
resource "aws_key_pair" "TF_key" {
  key_name   = "TF-key"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "local_file" "terraformpenfile" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "pemfile"
}

resource "aws_security_group" "TF_SG" {
  name        = "TF_SG"
  description = "Allow TLS inbound traffic"
  vpc_id      = "vpc-024cd235aac191a85"

  ingress {
    description      = "HTTPS"
    from_port        = 443
    to_port          = 443
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]


  }
  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]


  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}
