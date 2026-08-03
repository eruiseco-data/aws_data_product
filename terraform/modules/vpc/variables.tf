variable "project_name" {
    type = string
    description = "dataproduct"
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
    description = "CIDR block de la VPC"
}