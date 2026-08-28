output "tg_arns" {
  description = "Map of target group names to ARNs."

  value = {
    for key, tg in aws_lb_target_group.this :
    key => tg.arn
  }
}

output "tg_names" {
  description = "Map of target group names to names."

  value = {
    for key, tg in aws_lb_target_group.this :
    key => tg.name
  }
}

output "tg_arn_suffixes" {
  description = "Map of target group names to ARN suffixes."

  value = {
    for key, tg in aws_lb_target_group.this :
    key => tg.arn_suffix
  }
}
