output "listener_arns" {
  description = "Map of listener keys to ARNs."

  value = {
    for key, listener in aws_lb_listener.this :
    key => listener.arn
  }
}

output "listener_ids" {
  description = "Map of listener keys to IDs."

  value = {
    for key, listener in aws_lb_listener.this :
    key => listener.id
  }
}
