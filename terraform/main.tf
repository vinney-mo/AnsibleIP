resource "aws_key_pair" "my_key_pair" {
  key_name   = "my-key-pair"
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key
}

resource "aws_instance" "my_instance" {
  ami           = var.ec2_ami  # Replace with your desired AMI ID
  instance_type = "t3.micro"      # Replace with your desired instance type
  key_name      = aws_key_pair.my_key_pair.key_name

  tags = {
    Name = "my-new-instance"
  }
}

# ansible.tf
resource "null_resource" "configure_ansible" {
  connection {
    type        = "ssh"
    user        = "ec2-user"  # Replace with the appropriate username for your AMI
    private_key = file("~/.ssh/id_rsa")  # Path to your private key
    host        = aws_instance.my_instance.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i '/${aws_instance.my_instance.private_ip}/d' /etc/ansible/hosts",
      "sudo bash -c 'echo ${aws_instance.my_instance.private_ip} ${aws_instance.my_instance.tags.Name} >> /etc/ansible/hosts'",
    ]
  }
}
