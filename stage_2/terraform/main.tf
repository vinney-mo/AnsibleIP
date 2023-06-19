resource "aws_key_pair" "example" {
  key_name   = "host-3-key"
  public_key = var.public_key  # Update the key in the.tfvars file
}

resource "aws_security_group" "example" {
  name_prefix = "example"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example" {
  ami           = "ami-016b30666f212275a"  # Change this to your desired AMI ID
  instance_type = "t3.micro"  # Change this to your desired instance type

  key_name      = aws_key_pair.example.key_name

  vpc_security_group_ids = ["sg-09eaf661a7652ac3a"] # Change this to your desired group ID. Default to allow ssh

  tags = {
    Name = "Ansible-Host-3"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "host_3 ansible_host=${aws_instance.example.public_dns}" >> /etc/ansible/hosts
    EOT
  }

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }
}
