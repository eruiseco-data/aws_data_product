terraform {
    backend "s3" {
        bucket = "data-product-tfstate-tambote"
        key = "dataproduct/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "data-product-tambote-tf-locks"
        encrypt = true
    }

    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider "aws" {
    region = "us-east-1"
}

module "vpc" {
    source = "./modules/vpc"

    project_name = "dataproduct"
    vpc_cidr = "10.0.0.0/16"
}
output "vpc_id" {
    value = module.vpc.vpc_id
}

output "private_subnet_id" {
    value = module.vpc.private_subnet_id
}

module "s3" {
    source = "./modules/s3"

    project_name = "dataproduct"
}

output "bronze_bucket" {
    value = module.s3.bronze_bucket
}

output "silver_bucket" {
    value = module.s3.silver_bucket
}

output "gold_bucket" {
    value = module.s3.gold_bucket
}