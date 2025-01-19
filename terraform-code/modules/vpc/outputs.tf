output "vpc_id" {
    description = "this is a vpc id"
    value = aws_vpc.this.id
}

output "public_subnet_id" {
    description = "this is public subnet id"
    value = aws_subnet.public[*].id
}

output "private_subnet_id" {
    description = "this a private subnet id"
    value = aws_subnet.private[*].id  
}