

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
}
variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
}

variable "public_subnet_count" {
  description = "Count of public subnet"
  type = number
}

variable "private_subnet_count" {
  description = "count of private subnet"
  type = number
}

variable "vpc_cidr_block" {
    description = "this is cidr block for vpc"
    type = string
}