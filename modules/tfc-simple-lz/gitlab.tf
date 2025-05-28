# Reference existing group in Gitlab
data "gitlab_group" "instruqt_group" {
  full_path = "instruqt-learners"
}

# Creates a new project under the Instruqt Group.0
resource "gitlab_project" "app_repo" {
  name                   = "${var.app_name}-repo"
  namespace_id           = data.gitlab_group.instruqt_group.id
  visibility_level       = "public"
  default_branch         = "main"
  initialize_with_readme = true
}

# Add an initial file to the project
resource "gitlab_repository_file" "main" {
  project        = gitlab_project.app_repo.id
  file_path      = "main.tf"
  branch         = "main"
  content        = base64encode("# Insert your Terrfaorm code here")
  commit_message = "Initial onboard commit"
}

resource "gitlab_repository_file" "providers" {
  project        = gitlab_project.app_repo.id
  file_path      = "providers.tf"
  branch         = "main"
  content        = base64encode("# Insert your Terrfaorm code here")
  commit_message = "Initial onboard commit"
}

# Add variables file to the project
resource "gitlab_repository_file" "variables" {
  project   = gitlab_project.app_repo.id
  file_path = "variables.tf"
  branch    = "main"
  content   = base64encode(<<EOF
variable "aws_s3_bucket_arn" {
  type = string
  description = "The ARN of the S3 bucket to use for the application."
}

variable "aws_public_subnet_id" {
  type = string
  description = "The ID of the public subnet to use for the application."
}

variable "aws_private_subnet_id" {
  type = string
  description = "The ID of the private subnet to use for the application."
}

variable "aws_vpc_id" {
  type = string
  description = "The ID of the VPC to use for the application."
}
EOF
  )
  commit_message = "Initial onboard commit"
}
