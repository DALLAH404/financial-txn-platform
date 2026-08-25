resource "aws_s3_bucket" "raw" {
  bucket = "fintxn-dev-raw-78738"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}
resource "aws_s3_bucket_versioning" "versioning_raw" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket" "curated" {
  bucket = "fintxn-dev-curated-78738"

}
resource "aws_s3_bucket_versioning" "versioning_curated" {
  bucket = aws_s3_bucket.curated.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "processed" {
  bucket = "fintxn-dev-processed-78738"
}
resource "aws_s3_bucket_versioning" "versioning_processed" {
  bucket = aws_s3_bucket.processed.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket" "athena" {
  bucket = "fintxn-dev-athena-query-results-78738"
}
resource "aws_s3_bucket_versioning" "versioning_athena" {
  bucket = aws_s3_bucket.athena.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket" "tfstate" {
  bucket = "fintxn-dev-terraform-state-78738"
}
resource "aws_s3_bucket_versioning" "versioning_tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}
