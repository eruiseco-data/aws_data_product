output "bronze_bucket" {
    value = aws_s3_bucket.bronze.id
}

output "silver_bucket" {
    value = aws_s3_bucket.silver.id
}

output "gold_bucket" {
    value = aws_s3_bucket.gold.id
}