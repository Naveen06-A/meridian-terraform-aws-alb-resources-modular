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

variable "target_attachments" {
  description = "Target registrations passed to the reusable target attachment module."
  type = list(object({
    name              = string
    target_group_arn  = string
    target_id         = string
    port              = optional(number)
    availability_zone = optional(string)
  }))
}

module "target_attachment" {
  source = "../modules/target-attachment"

  target_attachments = var.target_attachments
}

output "target_attachment_ids" {
  value = module.target_attachment.target_attachment_ids
}
