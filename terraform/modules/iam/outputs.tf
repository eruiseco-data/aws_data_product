output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_role_name" {
  value = aws_iam_role.ecs_task_role.name
}

output "databricks_role_arn" {
  value = aws_iam_role.databricks_role.arn
}

output "databricks_instance_profile_arn" {
  value = aws_iam_instance_profile.databricks.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}