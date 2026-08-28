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

variable "rules" {
  description = "Listener rules passed to the reusable listener-rule module."
  type = map(object({
    listener_arn     = string
    priority         = number
    target_group_arn = string

    path_patterns = optional(list(string))
    host_headers  = optional(list(string))
    source_ips    = optional(list(string))

    tags = optional(map(string), {})
  }))
}

module "listener_rule" {
  source = "../modules/listener-rule"

  rules = var.rules
}

output "rule_arns" {
  value = module.listener_rule.rule_arns
}

output "rule_ids" {
  value = module.listener_rule.rule_ids
}
