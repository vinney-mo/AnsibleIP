resource "aws_key_pair" "key_pair" {
  key_name   = "host-1-key_pair"
  public_key = var.public_key  # Update the key in the .tfvars file
}

# Create security group
# Refactor to have a these match your configurations on aws
resource "aws_security_group" "aws_web_sg" {
  name        = "aws_web_sg"
  description = "Security group for access"

  ingress {
    from_port   = 22  # SSH
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow SSH access from anywhere
  }

  ingress {
    from_port   = 3000  # HTTP
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Frontend App access from anywhere
  }

  ingress {
    from_port   = 5000  # HTTP
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Backend App access from anywhere
  }

  ingress {
    from_port   = 27017  # HTTP
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allow Database access from anywhere
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

  vpc_security_group_ids = [aws_security_group.aws_web_sg.name] #you can replace with an already created security group on aws

  tags = {
    Name = "Ansible-Host-1"
  }

  #Adds the newly created host to the list of hosts on the control node
  provisioner "local-exec" {
    command = <<-EOT
      echo "host_1 ansible_host=${aws_instance.the_instance.public_dns}" >> /etc/ansible/hosts
    EOT
  }

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }
}
