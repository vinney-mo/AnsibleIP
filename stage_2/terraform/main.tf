resource "aws_key_pair" "my-key" {
  key_name   = "host-4-key"
  public_key = var.public_key  # Update the key in the.tfvars file
}

resource "aws_security_group" "security_group" {
  name        = "My Security Group"
  description = "Allow SSH, HTTP, and HTTP traffic"

  #Allow SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow HTTP
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-016b30666f212275a"  # Change this to your desired AMI ID
  instance_type = "t3.micro"  # Change this to your desired instance type

  key_name      = aws_key_pair.my-key.key_name

  vpc_security_group_ids = aws_security_group.security_group

  tags = {
    Name = "Ansible-Host-3"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "host_4 ansible_host=${aws_instance.example.public_dns}" >> /etc/ansible/hosts
    EOT
  }

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }
}
