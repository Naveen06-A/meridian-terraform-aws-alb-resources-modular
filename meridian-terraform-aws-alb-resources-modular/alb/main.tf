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

variable "albs" {
  description = "Load balancers passed to the reusable ALB module."
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
}

module "alb" {
  source = "../modules/alb"

  albs = var.albs
}

output "alb_arns" {
  value = module.alb.alb_arns
}

output "alb_dns_names" {
  value = module.alb.alb_dns_names
}

output "alb_zone_ids" {
  value = module.alb.alb_zone_ids
}
