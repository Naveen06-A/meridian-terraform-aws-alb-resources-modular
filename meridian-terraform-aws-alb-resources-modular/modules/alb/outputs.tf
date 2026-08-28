output "alb_arns" {
  description = "Map of load balancer keys to ARNs."

  value = {
    for key, alb in aws_lb.this :
    key => alb.arn
  }
}

output "alb_dns_names" {
  description = "Map of load balancer keys to DNS names."

  value = {
    for key, alb in aws_lb.this :
    key => alb.dns_name
  }
}

output "alb_zone_ids" {
  description = "Map of load balancer keys to Route 53 zone IDs."

  value = {
    for key, alb in aws_lb.this :
    key => alb.zone_id
  }
}
