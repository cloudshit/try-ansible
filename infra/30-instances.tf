resource "aws_security_group" "ansible" {
  name = "ansible-instance-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "22"
    to_port = "22"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "2222"
    to_port = "2222"
  }

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "80"
    to_port = "80"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }
}

resource "aws_instance" "instance_a" {
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_a.id
  associate_public_ip_address = false
  vpc_security_group_ids = [aws_security_group.ansible.id]
  key_name = aws_key_pair.keypair.key_name
  
  ami = "ami-035da6a0773842f64"

  tags = {
    Name = "ansible-instance-a"
    Ansible = "instance"
  }
}

resource "aws_instance" "instance_b" {
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.ansible.id]
  associate_public_ip_address = false
  key_name = aws_key_pair.keypair.key_name
  
  ami = "ami-035da6a0773842f64"

  tags = {
    Name = "ansible-instance-b"
    Ansible = "instance"
  }
}

resource "aws_instance" "instance_c" {
  instance_type = "t3.micro"
  subnet_id = aws_subnet.private_c.id
  vpc_security_group_ids = [aws_security_group.ansible.id]
  associate_public_ip_address = false
  key_name = aws_key_pair.keypair.key_name
  
  ami = "ami-035da6a0773842f64"

  tags = {
    Name = "ansible-instance-c"
    Ansible = "instance"
  }
}
