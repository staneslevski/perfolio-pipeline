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
    sid = ""

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
    ]

    effect = "Allow"

    resources = [
      "*",
    ]
  }
}

resource "aws_iam_role_policy" "example" {
  role = "${aws_iam_role.build_project_service_role.name}"

  policy = "${data.aws_iam_policy_document.permissions}"
}

resource "aws_codebuild_project" "${var.project_name}" {
  name          = var.project_name
  description   = var.project_description
  build_timeout = var.build_timeout
  service_role  = aws_iam_role.build_project_service_role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type = "NO_CACHE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      status = "ENABLED"
      group_name = "log-group"
      stream_name = "log-stream"
    }
  }

  source {
    type            = "CODEPIPELINE"
  }
}