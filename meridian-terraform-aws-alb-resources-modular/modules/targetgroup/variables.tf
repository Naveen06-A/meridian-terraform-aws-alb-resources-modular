variable "target_group_config" {
  description = "List of target group configurations."

  type = list(object({
    name        = string
    port        = number
    protocol    = string
    vpc_id      = string
    target_type = optional(string, "instance")

    deregistration_delay = optional(number, 300)
    slow_start           = optional(number, 0)

    health_check = optional(object({
      enabled             = optional(bool, true)
      protocol            = optional(string, "HTTP")
      port                = optional(string, "traffic-port")
      path                = optional(string, "/")
      matcher             = optional(string, "200")
      interval            = optional(number, 30)
      timeout             = optional(number, 5)
      healthy_threshold   = optional(number, 3)
      unhealthy_threshold = optional(number, 3)
    }), {})

    stickiness = optional(object({
      enabled         = optional(bool, false)
      type            = optional(string, "lb_cookie")
      cookie_duration = optional(number, 86400)
    }), {})

    tags = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for tg in var.target_group_config :
      contains(["instance", "ip", "lambda", "alb"], tg.target_type)
    ])
    error_message = "target_type must be instance, ip, lambda, or alb."
  }
}
