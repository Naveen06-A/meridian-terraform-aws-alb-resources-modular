variable "target_attachments" {
  description = "EC2 instance IDs or IP addresses registered against existing target groups."

  type = list(object({
    name              = string
    target_group_arn  = string
    target_id         = string
    port              = optional(number)
    availability_zone = optional(string)
  }))
}
