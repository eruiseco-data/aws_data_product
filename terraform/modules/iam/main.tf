resource "aws_iam_role" "ecs_task_role" {
    name = "${var.project_name}-ecs_task_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ecs-tasks.amazonaws.com
            }
        }
        ]
    })
}

resource "aws_iam_role_policy" "ecs_s3_policy" {
    name = "${var.project_name}-ecs-s3-policy"
    role = aws_iam_role.ecs_task_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:PutObject"
                ]
                Resource = "${var.bronze_bucket_arn}/bronze/*"
                Effect = "Allow"
            },
            {
                Action = [
                    "s3:GetObject"
                ]
                Resouce = [
                    "${var.silver_bucket_arn}/silver/*",
                    "${var.gold_bucket_arn}/gold/*"
                ]
                Effect = "Allow"
            }
        ]
    })
}

resource "aws_iam_role" "databricks_role" {
    name = "${var.project_name}-databricks-role"

    assume_role_policy = jsonencode ({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "ec2.amazonaws.com"
            }
        }]
    })
}

resource "aws_iam_role_policy" "databricks_s3_policy" {
    name = "${var.project_name}-databricks-s3-policy"
    role = aws_iam_role.databricks_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "s3:GetObject"
                ]
                Resource = "${var.bronze_bucket_arn}/bronze/*"
                Effect = "Allow"
            },
            {
                Action = [
                    "s3:PutObject"
                    "s3:DeleteObject"
                ]
                Resource = [
                    "${var.silver_bucket_arn}/silver/*",
                    "${var.gold_bucket_arn}/gold/*"
                ]
                Effect = "Allow"
            },
            {
                Action = [
                    "s3:ListBucket"
                ]
                Resource = [
                    var.bronze_bucket_arn,
                    var.silver_bucket_arn,
                    var.gold_bucket_arn
                ]
                Effect = "Allow"
            }
        ]
    })
}

resource "aws_iam_instance_profile" "databricks" {
    name = "$[var.project_name]-databricks-profile"
    role = aws_iam_role.databricks_role.name
}

resource "aws_iam_role" "github_actions" {
    name = "${var.project_name}-github_actions_role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRoleWithWebIdentity"
            Effect = "Allow"
            Principal = {
                Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
            }
            Condition = {
                StringLike = {
                    "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
                }
                StringEquals = {
                    "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
                }
            }
        }] 
    })
}

resource "aws_iam_role_policy_attachment" "github_admin" {
    role = aws_iam_role.github_actions.name
    policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_caller_identity" "current" {}