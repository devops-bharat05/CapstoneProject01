output "vpc_id" {
    description = "vpc id"
    value = module.vpc.vpc_id
  
}

output "private_subnet_id" {
    description = "private subnet id"
    value = module.vpc.private_subnet_id
  
}