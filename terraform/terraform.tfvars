app_details = {
  name = "demo"
  region = "nyc"
}

frontend_project_github = {
  branch = "main"
  deploy_on_push = false
  repo = "tkottke90/finance"
  source_dir = "/frontend"
}

backend_project_github = {
  branch = "main"
  deploy_on_push = false
  repo = "tkottke90/finance"
  source_dir = "/server"
}

database_name = "demo-db"