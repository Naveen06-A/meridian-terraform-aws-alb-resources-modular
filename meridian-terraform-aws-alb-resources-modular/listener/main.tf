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

variable "listeners" {
  description = "Listeners passed to the reusable listener module."
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
}

module "listener" {
  source = "../modules/listener"

  listeners = var.listeners
}

output "listener_arns" {
  value = module.listener.listener_arns
}

output "listener_ids" {
  value = module.listener.listener_ids
}
