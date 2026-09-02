data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consumer_role" {
  name               = "${var.project_name}-${var.environment}-consumer-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

data "aws_iam_policy_document" "consumer_s3_access" {
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
    ]
    resources = [
      var.raw_bucket_arn,
      "${var.raw_bucket_arn}/*",
    ]
  }
}
resource "aws_iam_role_policy" "consumer_s3_policy" {
  name   = "${var.project_name}-${var.environment}-consumer-s3-policy"
  role   = aws_iam_role.consumer_role.id
  policy = data.aws_iam_policy_document.consumer_s3_access.json
}

resource "aws_iam_instance_profile" "consumer_profile" {
  name = "${var.project_name}-${var.environment}-consumer-profile"
  role = aws_iam_role.consumer_role.name
}
