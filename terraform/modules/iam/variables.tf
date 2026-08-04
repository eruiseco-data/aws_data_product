variable "project_name" {
    type = string
    description = "dataproduct"
}

variable "github_repo" {
    type = string
    description = "GitHub repo (eruiseco-data/aws_data_product/)"
}

variable "bronze_bucket_arn" {
    type = string
    description = "ARN del bucket bronze"
}

variable "silver_bucket_arn" {
    type = string
    description = "ARN del bucket silver"
}

variable "gold_bucket_arn" {
    type = string
    description = "ARN del bucket gold"
}