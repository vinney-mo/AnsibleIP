# Creating a Variable for ami of type map


variable "ec2_ami" {
  type = map

  default = {
    us-east-2 = "ami-016b30666f212275a"
  }
}

# Creating a Variable for region

variable "region" {
  default = "us-east-2"
}


# Creating a Variable for instance_type
variable "instance_type" {
  type = string
}


# Creating a Variable for access_key
variable "access_key" {
  type = string
}

# Creating a Variable for secret_key
variable "secret_key" {
  type = string
}