output "raw_bucket_arn" {
  value = aws_s3_bucket.raw.arn
}

output "raw_bucket_id" {
  value = aws_s3_bucket.raw.id
}
output "state_bucket_id" {
  value = aws_s3_bucket.raw.bucket
}