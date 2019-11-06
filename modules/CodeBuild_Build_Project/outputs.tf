output "project_name" {
  value = aws_codebuild_project.module_project.name
}

output "project_id" {
  value = aws_codebuild_project.module_project.id
}

output "role_arn" {
  value = aws_iam_role.build_project_service_role.arn
}