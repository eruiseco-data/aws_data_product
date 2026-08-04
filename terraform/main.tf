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

module "s3" {
    source = "./modules/s3"

    project_name = "dataproduct"
}

module "iam" {
    source = "./modules/iam"

    project_name = "dataproduct"
    github_repo = "eruiseco-data/aws_data_product"
    bronze_bucket_arn = "arn:aws:s3:::${module.s3.bronze_bucket}"
    silver_bucket_arn = "arn:aws:s3:::${module.s3.silver_bucket}"
    gold_bucket_arn = "arn:aws:s3:::${module.s3.gold_bucket}"

}

output "vpc_id" {
    value = module.vpc.vpc_id
}

output "private_subnet_id" {
    value = module.vpc.private_subnet_id
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

output "ecs_task_role_arn" {
  value = module.iam.ecs_task_role_arn
}

output "databricks_role_arn" {
  value = module.iam.databricks_role_arn
}

output "github_actions_role_arn" {
  value = module.iam.github_actions_role_arn
}