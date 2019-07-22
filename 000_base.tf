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
