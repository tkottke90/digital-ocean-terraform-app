resource "digitalocean_app" "app" {
  spec {
    name    = "${var.app_details.name}-app"
    region  = var.app_details.region

    service {
      dockerfile_path    = "dockerfile"
      http_port          = 80
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      name               = "${var.app_details.name}-ui"
      source_dir         = var.frontend_project_github.source_dir

      github {
        branch         = var.frontend_project_github.branch
        deploy_on_push = var.frontend_project_github.deploy_on_push
        repo           = var.frontend_project_github.repo
      }

      routes {
        path                 = "/"
        preserve_path_prefix = false
      }

      health_check {
        http_path = "/v1/healthcheck"
      }
    }

    service {
      dockerfile_path    = "dockerfile"
      http_port          = 5000
      instance_count     = 1
      instance_size_slug = "basic-xxs"
      name               = "${var.app_details.name}-api"
      source_dir         = var.backend_project_github.source_dir

      github {
        branch         = var.backend_project_github.branch
        deploy_on_push = var.backend_project_github.deploy_on_push
        repo           = var.backend_project_github.repo
      }

      routes {
        path                 = "/api"
        preserve_path_prefix = false
      }

      env {
        key = "NODE_TLS_REJECT_UNAUTHORIZED"
        value = "0"
        type = "GENERAL"
      }

      env {
        key = "DATABASE_URL"
        value = ""
        type = "GENERAL"
      }

      health_check {
        http_path = "/v1/healthcheck"
      }
    }

    database {
      name       = var.database_name
      engine     = "PG"
      production = false
    }
  }

}