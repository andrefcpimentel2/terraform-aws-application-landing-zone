## General Variables
variable "app_name" {
  type = string
  default = "my-app"
  description = "The name of the application."
}

## TFC Variables
variable "oauth_client_id" {
  type = string
}

## AWS Variables
variable "aws_vpc_id" {
  type = string
}

variable "aws_public_subnet_id" {
  type = string
}

variable "aws_private_subnet_id" {
  type = string
}

variable "aws_s3_bucket_arn" {
  type = string
}

variable "aws_access_key_id" {
  type = string
}

variable "aws_secret_access_key" {
  type = string
  sensitive = true
}

## GitLab Variables
# variable "gitlab_token" {
#   type = string
# }

# variable "gitlab_base_url" {
#   type = string
# }

# variable "tfe_oauth_client_name" {
#   type = string
#   default = "instruqt-learners-gitlab"
# }