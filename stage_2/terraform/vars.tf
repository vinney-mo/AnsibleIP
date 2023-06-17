# Creating a Variable for access_key
variable "access_key" {
  type = string
  sensitive = true
}

# Creating a Variable for secret_key
variable "secret_key" {
  type = string
  sensitive = true
}

# Creating a Variable for public_key
variable "public_key" {
  type = string
  sensitive = true
}