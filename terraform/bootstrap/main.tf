terraform {
    backend "s3" {
        bucket = "data-product-tfstate-tambote"
        key = "bootstrap/terraform.tfstate"
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

resource "aws_s3_bucket" "terraform_state" {
    bucket = "data-product-tfstate-tambote"
}

resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
    bucket = aws_s3_bucket.terraform_state.id
    versioning_configuration {
        status = "Enabled"
    }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_crypto" {
    bucket = aws_s3_bucket.terraform_state.id
    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name = "data-product-tambote-tf-locks"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}

resource "aws_iam_openid_connect_provider" "github" {
    url = "https://token.actions.githubusercontent.com"
    client_id_list = ["sts.amazonaws.com"]

    thumbprint_list = [
        "6938fd4d98bab03faadb97b34396831e3780aea1",
        "1c58a3a8518e8759bf075b76b750d4f2df264fcd",
        "1b511abead59c6ce207077c0bf0e0043b1382612"
    ]
}

resource "aws_iam_role" "github_actions_role" {
    name = "data-product-tambote-github-actions-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow"
            Principal = {
                Federated = aws_iam_openid_connect_provider.github.arn
            }
            Action = "sts:AssumeRoleWithWebIdentity"
            Condition = {
                StringLike = {
                    # Esto ignora los IDs numéricos intermedios pero valida que sea estrictamente tu organización y tu repo
                    "token.actions.githubusercontent.com:sub": "repo:eruiseco-data*/aws_data_product*:*"
                }
                StringEquals = {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }]
    })
}

resource "aws_iam_role_policy_attachment" "github_actions_admin" {
    role       = aws_iam_role.github_actions_role.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "github_oidc_provider_arn" {
    value = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
    value = aws_iam_role.github_actions_role.arn
}
