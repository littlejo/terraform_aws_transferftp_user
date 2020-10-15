resource "aws_secretsmanager_secret" "ftp_account" {
  name = var.secret_name
  description = "Storage sftp for ${var.bucket_name}"
}

resource "aws_secretsmanager_secret_version" "ftp_account" {
  secret_id     = aws_secretsmanager_secret.ftp_account.id
  secret_string = jsonencode(var.secret)
}

resource "aws_iam_policy" "policy" {
  name        = "S3_policy_for_example"
  path        = "/"
  description = "Allow AWS Transfer to call AWS services on your behalf"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowListingOfUserFolder",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::example-bucket"
            ]
        },
        {
            "Sid": "HomeDirObjectAccess",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObjectVersion",
                "s3:DeleteObject",
                "s3:GetObjectVersion"
            ],
            "Resource": "arn:aws:s3:::example-bucket/*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "sftp_variable_role" {
  name = "sftp_${var.bucket_name}_role"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "transfer.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.sftp_variable_role.name
  policy_arn = aws_iam_policy.policy.arn
}


resource "aws_s3_bucket" "b" {
  bucket = var.bucket_name
  acl    = "private"
}
