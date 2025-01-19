variable "cluster_name" {
    description = "eks cluster name"
    type = string

} 
variable "cluster_version"{
    description = "eks cluster version"
    type = string

}

variable "vpc_id" {
    description = "vpc id"
    type = string
}
variable "private_subnet_id" {
  description = "List of private subnet IDs for the EKS cluster"
  type        = list(string)
}
variable "public_subnet_id" {
  description = "List of public subnet IDs for the load balancer"
  type        = list(string)
}

variable "instance_types" {
  description = "instance types"
  type = list(string)
}

variable "ami_type" {
    description = "ami type"
    type = string
  
}
variable "min_size" {
    description = "minimum number of nodes"
    type = number
  
}
variable "max_size" {
    description = "maximum number of nodes"
    type = number
  
}
variable "desired_size" {
    description = "desired number of nodes"
    type = number
  
}