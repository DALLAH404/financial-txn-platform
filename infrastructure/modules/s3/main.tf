resource "random_id" "bucket_suffix" {
  byte_length = 2
}
resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-${var.environment}-raw-${random_id.bucket_suffix.hex}"
}
resource "aws_s3_bucket_versioning" "versioning_raw" {
  bucket = aws_s3_bucket.raw.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_raw" {
  bucket = aws_s3_bucket.raw.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "access-raw" {
  bucket = aws_s3_bucket.raw.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "curated" {
  bucket = "${var.project_name}-${var.environment}-curated-${random_id.bucket_suffix.hex}"

}
resource "aws_s3_bucket_versioning" "versioning_curated" {
  bucket = aws_s3_bucket.curated.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_curated"{
  bucket = aws_s3_bucket.curated.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access-curated" {
  bucket = aws_s3_bucket.curated.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


resource "aws_s3_bucket" "processed" {
  bucket = "${var.project_name}-${var.environment}-processed-${random_id.bucket_suffix.hex}"
}
resource "aws_s3_bucket_versioning" "versioning_processed" {
  bucket = aws_s3_bucket.processed.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_processed"{
  bucket = aws_s3_bucket.processed.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access-processed" {
  bucket = aws_s3_bucket.processed.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}




resource "aws_s3_bucket" "athena" {
  bucket = "${var.project_name}-${var.environment}-athena-query-results-${random_id.bucket_suffix.hex}"
}
resource "aws_s3_bucket_versioning" "versioning_athena" {
  bucket = aws_s3_bucket.athena.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_athena"{
  bucket = aws_s3_bucket.athena.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "access-athena" {
  bucket = aws_s3_bucket.athena.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}





resource "aws_s3_bucket" "tfstate" {
  bucket = "${var.project_name}-${var.environment}-terraform-state-${random_id.bucket_suffix.hex}"
}
resource "aws_s3_bucket_versioning" "versioning_tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encrypt_tfstate"{
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "access-tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

