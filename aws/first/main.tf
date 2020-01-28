variable "profile" {
}

provider "aws" {
  region = "eu-central-1"
  profile = var.profile
}

data "aws_caller_identity" "current" {}

output "profile" {
  value = var.profile != "" ? var.profile : "default"
}

output "account_id" {
  value = "${data.aws_caller_identity.current.account_id}"
}

output "caller_arn" {
  value = "${data.aws_caller_identity.current.arn}"
}

output "caller_user" {
  value = "${data.aws_caller_identity.current.user_id}"
}