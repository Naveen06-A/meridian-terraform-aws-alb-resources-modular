output "rule_arns" {
  description = "Map of rule keys to rule ARNs."

  value = {
    for key, rule in aws_lb_listener_rule.this :
    key => rule.arn
  }
}

output "rule_ids" {
  description = "Map of rule keys to rule IDs."

  value = {
    for key, rule in aws_lb_listener_rule.this :
    key => rule.id
  }
}
