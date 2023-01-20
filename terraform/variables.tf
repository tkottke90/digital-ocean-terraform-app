variable "do_token" {}

variable "app_details" {
  type = object({
    name   = string
    region = string
  })
}

variable "backend_project_github" {
  type = object({
    branch         = string
    source_dir     = string
    repo           = string
    deploy_on_push = bool
  })
}

variable "frontend_project_github" {
  type = object({
    branch         = string
    source_dir     = string
    repo           = string
    deploy_on_push = bool
  })
}

variable "database_name" {
  type = string
}