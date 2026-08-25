resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "${var.project_name}-${var.environment}-kinesis-stream"
  retention_period = 24

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
  ]

  stream_mode_details {
    stream_mode = "ON_DEMAND"
  }

}


data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "firehose_role" {
  name               = "${var.project_name}-${var.environment}-firehose-role"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

data "aws_iam_policy_document" "firehose_s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]
    resources = [
      var.raw_bucket_arn,
      "${var.raw_bucket_arn}/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_role_policy" "firehose_s3_policy" {
  name   = "${var.project_name}-${var.environment}-firehose-s3-policy"
  role   = aws_iam_role.firehose_role.id
  policy = data.aws_iam_policy_document.firehose_s3_access.json
}



resource "aws_kinesis_firehose_delivery_stream" "extended_s3_stream" {
  name        = "${var.project_name}-${var.environment}-raw-stream"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = var.raw_bucket_arn

    buffering_size = 64

    dynamic_partitioning_configuration {
      enabled = "true"
    }

    processing_configuration {
      enabled = "true"

      processors {
        type = "AppendDelimiterToRecord"
      }
    }
  }
}