variable "environment_variables" {
  type = "list"

  default = [{
    name  = "NO_ADDITIONAL_BUILD_VARS"
    value = "This is a default value - no additional build vars"
  }]

  description = "A list of maps, that contain both the key 'name' and the key 'value' to be used as additional environment variables for the build."
}

variable "build_image" {
  default     = "aws/codebuild/docker:1.12.1"
  description = "Docker image for build environment, e.g. 'aws/codebuild/docker:1.12.1' or 'aws/codebuild/eb-nodejs-6.10.0-amazonlinux-64:4.0.0'. For more info: http://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html"
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
  default = "CODEPIPELINE"
}

variable "source_type" {
  description = "string | either CODECOMMIT, CODEPIPELINE, GITHUB, GITHUB_ENTERPRISE, BITBUCKET, S3 or NO_SOURCE"
  default = "CODEPIPELINE"
}

variable "pipeline_bucket_arn" {
  description = "string | bucket arn for the pipeline bucket where source is kept"
}

variable "cache_type" {
  description = "cache type"
  default = "NOCACHE"
}

variable "environment_compute_type" {
  description = "Build instance type"
  default = "BUILD_GENERAL1_SMALL"
}

variable "environment_image" {
  default = "aws/codebuild/standard:1.0"
}

variable "environment_type" {
  default = "LINUX_CONTAINER"
}

variable "environment_image_pull_credentials_type" {
  default = "CODEBUILD"
}