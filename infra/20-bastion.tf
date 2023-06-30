resource "aws_eip" "bastion" {
  vpc = true
  instance = aws_instance.bastion.id
  associate_with_private_ip = aws_instance.bastion.private_ip
}

resource "aws_security_group" "bastion" {
  name = "ansible-bastion-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "22"
    to_port = "22"
  }

  egress {
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port = "0"
  }
}

resource "aws_iam_role" "bastion" {
  name = "ansible-role-bastion"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}

resource "aws_iam_instance_profile" "bastion" {
  name = "ansible-profile-bastion"
  role = aws_iam_role.bastion.name
}

resource "aws_instance" "bastion" {
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_a.id
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.bastion.id]
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  key_name = aws_key_pair.keypair.key_name
  
  ami = "ami-035da6a0773842f64"

  tags = {
    Name = "ansible-bastion"
    Ansible = "bastion"
  }

  user_data = <<-EOF
    #!/bin/bash
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    ./aws/install

    yum install -y jq curl python3-pip git boto3 botocore
    pip3 install ansible
  EOF
}
