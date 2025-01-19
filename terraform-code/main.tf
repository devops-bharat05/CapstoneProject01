terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"
}

module "vpc" {
    source = "./modules/vpc"
    private_subnet_count = 1
    public_subnet_count = 1
    vpc_cidr_block = var.aws_vpc_cidr
    public_subnet_cidrs = var.aws_public_subnet_cidr
    private_subnet_cidrs = var.aws_private_subnet_cidr
}

module "iam" {
    source = "./modules/iam"  
}

module "eks" {
    source = "./modules/eks"
    cluster_name = var.cluster_name
    cluster_version = var.cluster_version
    vpc_id = module.vpc.vpc_id
    private_subnet_id = module.vpc.private_subnet_id
    public_subnet_id = module.vpc.public_subnet_id
    instance_types = var.instance_types
    min_size = var.min_size
    max_size = var.max_size
    desired_size = var.desired_size
    ami_type = var.ami_type

}