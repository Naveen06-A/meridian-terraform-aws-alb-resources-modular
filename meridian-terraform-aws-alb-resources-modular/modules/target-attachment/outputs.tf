output "target_attachment_ids" {
  description = "Map of attachment names to IDs."

  value = {
    for key, attachment in aws_lb_target_group_attachment.this :
    key => attachment.id
  }
}
