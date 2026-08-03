resource "aws_s3_bucket" "bronze" {
    bucket = "${var.project_name}-bronze"
}

resource "aws_s3_bucket" "silver" {
    bucket = "${var.project_name}-silver"
}

resource "aws_s3_bucket" "gold" {
    bucket = "${var.project_name}-gold"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "all" {
    for_each = toset([
        aws_s3_bucket.bronze.id,
        aws_s3_bucket.silver.id,
        aws_s3_bucket.gold.id
    ])

    bucket = each.value

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}