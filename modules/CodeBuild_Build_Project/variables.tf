variable "environment_variables" {
  type = "list"

  default = [{
    "name"  = "NO_ADDITIONAL_BUILD_VARS"
    "value" = "TRUE"
  }]

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build."
}

variable "build_image" {
  default     = "aws/codebuild/docker:1.12.1"
  description = "Docker image for build environment, e.g. 'aws/codebuild/docker:1.12.1' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
}

variable "build_compute_type" {
  default = "BUILD_GENERAL1_SMALL"
}

variable "buildspec" {
  description = "string | Supply a project relative path to a buildspec file"
}

variable "project_name" {
  description = "string | name for your codebuild project"
}

variable "project_description" {
  description = "string | Description for your project"
  default = "My CodeBuild project"
}

variable "build_timeout" {
  description = "string, but must be an integer number | timeout for your build"
  default = "5"
}

variable "artifact_type" {
  description = "string | either S3, CODEPIPELINE, or NO_ARTIFACTS"
  default = "NO_ARTIFACTS"
}