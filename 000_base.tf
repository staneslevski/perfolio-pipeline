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

  /**
  1.    Pull backend project source
  2.    Bundle and deploy backend source code to lambda & API gatway
  3.    Export any necessary configuration to (private) S3 bucket
          (if high security is required, you can use AWS Sectrets Manager)
  4.    Pull Frontend Source
  5.    Bundle and deploy frontend packages to S3
  */

  stage {
    name = "Backend_Source"
    action {
      name = "Source"
      category = "Source"
      owner = "ThirdParty"
      provider = "GitHub"
      version = "1"
      output_artifacts = ["frontend_source_output"]

      configuration = {
        Owner = "staneslevski"
        Repo = "perfolio-backend"
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
      input_artifacts  = ["frontend_source_output"]
      output_artifacts = ["frontend_build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${module.backend_codebuild_project.project_name}"
      }
    }
  }
}