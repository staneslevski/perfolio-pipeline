module "backend_codebuild_project" {
  source = "./modules/CodeBuild_Build_Project"
  buildspec = "aws_codebuild_config/production-buildspec.yml"
  project_name = "backend_codebuild_project"
  pipeline_bucket_arn = aws_s3_bucket.perfolio-pipeline-bucket.arn
}