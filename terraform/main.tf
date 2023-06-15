resource "aws_instance" "my-machine" {
  # Creates two identical EC2 instances
  count = 2

  # All instances will have the same AMI and instance type
  ami           = lookup(var.ec2_ami, var.region)
  instance_type = "t3.micro"  # Instance type with 2 vCPUs and 1GB memory

  root_block_device {
    volume_size = 10  # 10GB disk space
  }

  tags = {
    # The count.index allows you to launch a resource
    # starting with the distinct index number 0 and corresponding to this instance.
    Name = "my-machine-${count.index}"
  }
}
