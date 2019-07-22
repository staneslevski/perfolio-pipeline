terraform {
  backend "s3" {
    bucket = "perfolio-terraform-state"
    key    = "pipeline_state.tfstate"
    region = "ap-northeast-1"
    profile = "918166357173_AdministratorAccess"
  }
}

provider "aws" {
  profile = "918166357173_AdministratorAccess"
  region = "ap-northeast-1"
}

resource "aws_s3_bucket" "perfolio-pipeline-bucket" {
  bucket = "perfolio-pipeline-bucket"
  acl = "private"
}

resource "aws_iam_role" "perfolio_pipeline_role" {
  name = "perfolio-pipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "perfolio_pipeline_policy" {
  name = "perfolio_pipeline_policy"
  role = "${aws_iam_role.perfolio_pipeline_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject",
        "s3:DeleteObject"
      ],
      "Resource": [
        "${aws_s3_bucket.perfolio-pipeline-bucket.arn}",
        "${aws_s3_bucket.perfolio-pipeline-bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_codepipeline" "perfolio-codepipeline" {
  name = "perfolio-pipeline"
  role_arn = "${aws_iam_role.perfolio_pipeline_role.arn}"
  artifact_store {
    location = "${aws_s3_bucket.perfolio-pipeline-bucket.bucket}"
    type = "S3"
  }

  stage {
    name = "Backend Source"
    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner = "staneslevski"
        Repo = "perfect-portfolio"
        Branch = "master"
      }
    }
  }

  stage {
    name = "Backend_Build_And_Deploy"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }
}

resource "aws_codebuild_project" "Backend_Build_And_Deploy" {
  name = "Backend_Build_And_Deploy"
  service_role = ""
  artifacts {
    type = ""
  }
  environment {
    compute_type = ""
    image = ""
    type = ""
  }
  source {
    type = ""
  }
}