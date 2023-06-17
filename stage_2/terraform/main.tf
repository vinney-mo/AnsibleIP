resource "aws_key_pair" "example" {
  key_name   = "host-key"
  public_key = var.public_key  # Update the key in the.tfvars file
}

resource "aws_instance" "example" {
  ami           = "ami-016b30666f212275a"  # Change this to your desired AMI ID
  instance_type = "t3.micro"  # Change this to your desired instance type

  key_name      = aws_key_pair.example.key_name

  vpc_security_group_ids = ["sg-09e9f35f02c3890e1"] # Change this to your desired group ID. Default to allow ssh

  tags = {
    Name = "Ansible-Host-1"
  }

  provisioner "local-exec" {
    command = <<-EOT
      echo "${aws_instance.example.public_dns}" >> hosts
    EOT
  }

  lifecycle {
    ignore_changes = [
      key_name,
    ]
  }

  sensitive = true
}
