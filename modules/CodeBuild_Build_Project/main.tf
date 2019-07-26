resource "aws_iam_role" "build_project_service_role" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "permissions" {
  statement {
    sid = "logs"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "*",
    ]
  }
  statement {
    sid = "s3"
    actions = [
      "s3:*"
    ]
    effect = "Allow"
    resources = [
      var.pipeline_bucket_arn,
      "${var.pipeline_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_service_role_policy" {
  role = aws_iam_role.build_project_service_role.name

  policy = data.aws_iam_policy_document.permissions.json
}

resource "aws_codebuild_project" "module_project" {
  name          = var.project_name
  description   = var.project_description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.build_project_service_role.arn

  artifacts {
    type = var.artifact_type
  }

  cache {
    type = var.cache_type
  }

  environment {
    compute_type                = var.environment_compute_type
    image                       = var.environment_compute_type
    type                        = var.environment_type
    image_pull_credentials_type = var.environment_image_pull_credentials_type
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
      group_name = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type = var.source_type
    buildspec = var.buildspec
  }
}