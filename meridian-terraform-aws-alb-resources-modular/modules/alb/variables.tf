variable "albs" {
  description = "Map of load balancers to create."

  type = map(object({
    name                       = string
    internal                   = bool
    load_balancer_type         = optional(string, "application")
    security_groups            = optional(list(string), [])
    subnets                    = list(string)
    enable_deletion_protection = optional(bool, true)
    drop_invalid_header_fields = optional(bool, true)
    idle_timeout               = optional(number, 60)
    ip_address_type            = optional(string, "ipv4")
    tags                       = optional(map(string), {})
  }))

  validation {
    condition = alltrue([
      for alb in var.albs :
      contains(["application", "network", "gateway"], alb.load_balancer_type)
    ])
    error_message = "load_balancer_type must be application, network, or gateway."
  }
}
