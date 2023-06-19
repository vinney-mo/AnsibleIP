resource "aws_key_pair" "key_pair" {
  key_name   = "host-4-key"
  public_key = var.public_key  # Update the key in the.tfvars file
}

# Create a security group
resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Security group for web access"

  ingress {
    from_port   = 22  # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 80  # HTTP
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow HTTP access from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Launch an EC2 instance
resource "aws_instance" "the_instance" {
  ami           = "ami-016b30666f212275a"  # Change this to your desired AMI ID
  instance_type = "t3.micro"  # Change this to your desired instance type

  key_name      = aws_key_pair.key_pair.key_name

  security_group_names = [aws_security_group.web_sg.name]

  tags = {
    Name = "Ansible-Host-3"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "host_3 ansible_host=${aws_instance.the_instance.public_dns}" >> /etc/ansible/hosts
    EOT
  }

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }
}
