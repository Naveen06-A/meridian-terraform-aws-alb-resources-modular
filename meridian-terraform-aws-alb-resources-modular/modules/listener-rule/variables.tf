variable "rules" {
  description = "Listener rule configurations. Listener and target group are referenced by ARN."

  type = map(object({
    listener_arn     = string
    priority         = number
    target_group_arn = string

    path_patterns = optional(list(string))
    host_headers  = optional(list(string))
    source_ips    = optional(list(string))

    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.path_patterns != null ||
      rule.host_headers != null ||
      rule.source_ips != null
    ])
    error_message = "Every rule must have at least one condition."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      (rule.path_patterns == null || length(rule.path_patterns) > 0) &&
      (rule.host_headers == null || length(rule.host_headers) > 0) &&
      (rule.source_ips == null || length(rule.source_ips) > 0)
    ])
    error_message = "Condition lists cannot be empty."
  }

  validation {
    condition = alltrue([
      for rule in var.rules :
      rule.priority >= 1 && rule.priority <= 50000
    ])
    error_message = "Listener rule priority must be between 1 and 50000."
  }
}
