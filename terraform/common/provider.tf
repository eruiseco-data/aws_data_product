#Terraform blocks defines terraform dependencies
terraform {
    required_version = ">=1.6"
    required_providers {
        aws = {
            source = "hasicorp/aws"
            version = "~> 5.0"
        }
        databricks = {
            source = "databricks/databricks"
            version = "~> 1.3"
        }
    }
}

#Provider block defines default region and tags
#This will be added for everything that terraform will create in this project
provider = "aws" {
    region = var.aws_region

    default_tags {
        tags = {
            Environment = var.environment
            Project = "data-hub"
            ManagedBy = "terraform"
            CreatedBy = "github-actions"
        }
    }
}

#It defines the databricks workspace URL
#It also defines the databricks token (PAT)
#that will be used by github actions to manage databricks
provider "databricks" {
    host = aws_databricks_workspace.data_hub.workspace_url
    token = databricks_pat_token.github_token.token_value
}