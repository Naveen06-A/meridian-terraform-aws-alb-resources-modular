terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region."
  type        = string
}

variable "target_group_config" {
  description = "Target groups passed to the reusable target group module."
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
}

module "targetgroup" {
  source = "../modules/targetgroup"

  target_group_config = var.target_group_config
}

output "tg_arns" {
  value = module.targetgroup.tg_arns
}

output "tg_names" {
  value = module.targetgroup.tg_names
}
