# Create a project in Terraform Cloud
resource "tfe_project" "app" {
  name         = "Project-${var.app_name}"
  #organization = var.tfc_org
}

# Create a workspace in the project
resource "tfe_workspace" "app_ws" {
  name           = "${var.app_name}-ws"
  #organization   = var.tfc_org
  project_id     = tfe_project.app.id
  queue_all_runs = false
  depends_on     = [gitlab_project.app_repo]
  vcs_repo {
    identifier     = "instruqt-learners/${var.app_name}-repo"
    oauth_token_id = data.tfe_oauth_client.client.oauth_token_id
    branch         = "main"
  }
}

# Initiate the first run of the workspace
resource "tfe_workspace_run" "initial_run" {
  workspace_id = tfe_workspace.app_ws.id

  apply {
    manual_confirm = false
    wait_for_run   = false
  }
  depends_on = [ 
    tfe_variable.aws_vpc_id,
    tfe_variable.aws_public_subnet_id,
    tfe_variable.aws_private_subnet_id,
    tfe_variable.aws_s3_bucket_arn,
    tfe_variable.aws_access_key_id,
    tfe_variable.aws_secret_access_key
   ]
}

# Create a team in Terraform Cloud
resource "tfe_team" "app_admins" {
  name         = "${var.app_name}-admins"
  #organization = var.tfc_org
}

# Create a Terraform variable in the workspace
resource "tfe_variable" "aws_vpc_id" {
  key          = "aws_vpc_id"
  value        = var.aws_vpc_id
  category     = "terraform"
  workspace_id = tfe_workspace.app_ws.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_public_subnet_id" {
  key          = "aws_public_subnet_id"
  value        = var.aws_public_subnet_id
  category     = "terraform"
  workspace_id = tfe_workspace.app_ws.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_private_subnet_id" {
  key          = "aws_private_subnet_id"
  value        = var.aws_private_subnet_id
  category     = "terraform"
  workspace_id = tfe_workspace.app_ws.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_s3_bucket_arn" {
  key          = "aws_s3_bucket_arn"
  value        = var.aws_s3_bucket_arn
  category     = "terraform"
  workspace_id = tfe_workspace.app_ws.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_access_key_id" {
  key          = "AWS_ACCESS_KEY_ID"
  value        = var.aws_access_key_id
  category     = "env"
  workspace_id = tfe_workspace.app_ws.id
}

# Create another Terraform variable in the workspace
resource "tfe_variable" "aws_secret_access_key" {
  key          = "AWS_SECRET_ACCESS_KEY"
  value        = var.aws_secret_access_key
  category     = "env"
  workspace_id = tfe_workspace.app_ws.id
  sensitive    = true
}

resource "tfe_variable" "app_name" {
  key          = "app_name"
  value        = var.app_name
  category     = "terraform"
  workspace_id = tfe_workspace.app_ws.id
}

# Assign team access to the project
resource "tfe_team_project_access" "app_admins" {
  access     = "write"
  team_id    = tfe_team.app_admins.id
  project_id = tfe_project.app.id
}

# Get VCS OAuth Connection
data "tfe_oauth_client" "client" {
  oauth_client_id = var.oauth_client_id
}
