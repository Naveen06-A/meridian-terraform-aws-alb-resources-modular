variable "listeners" {
  description = "Listener configurations. The ALB is referenced by ARN and is not created by this module."

  type = map(object({
    load_balancer_arn = string
    port              = number
    protocol          = string

    ssl_policy      = optional(string)
    certificate_arn = optional(string)

    default_action_type = optional(string, "fixed-response")
    target_group_arn    = optional(string)

    fixed_response_content_type = optional(string, "text/plain")
    fixed_response_message_body = optional(string, "No matching rule")
    fixed_response_status_code  = optional(string, "404")

    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for listener in var.listeners :
      contains(["HTTP", "HTTPS"], listener.protocol)
    ])
    error_message = "protocol must be HTTP or HTTPS."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners :
      listener.protocol == "HTTP" || (
        listener.certificate_arn != null &&
        listener.ssl_policy != null
      )
    ])
    error_message = "HTTPS listeners require certificate_arn and ssl_policy."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners :
      contains(["forward", "fixed-response"], listener.default_action_type)
    ])
    error_message = "default_action_type must be forward or fixed-response."
  }

  validation {
    condition = alltrue([
      for listener in var.listeners :
      listener.default_action_type == "fixed-response" ||
      listener.target_group_arn != null
    ])
    error_message = "A forward listener requires target_group_arn."
  }
}
