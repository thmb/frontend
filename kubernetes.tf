terraform {
  required_version = ">= 1.14.0"

  backend "s3" {
    bucket  = "thmb-state"
    key     = "frontend/terraform.tfstate"
    region  = "sa-east-1"
    encrypt = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.28.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "3.0.1"
    }
  }
}


provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "frontend"
      ManagedBy = "terraform"
    }
  }
}


provider "kubernetes" {
  host                   = var.kubernetes_host
  token                  = var.kubernetes_token
  insecure               = contains(["localhost", "127.0.0.1"], var.kubernetes_host)
  cluster_ca_certificate = var.kubernetes_certificate != "" ? base64decode(var.kubernetes_certificate) : null
}


data "aws_caller_identity" "current" {}

# =============================================================================
# VARIABLES
# =============================================================================

variable "aws_region" {
  description = "AWS region for resources."
  default     = "sa-east-1"
  type        = string
}


variable "deploy_mode" {
  description = "Deployment mode."
  default     = "sandbox"
  type        = string

  validation {
    condition     = contains(["sandbox", "release"], var.deploy_mode)
    error_message = "deploy_mode must be one of: sandbox, release"
  }
}


variable "kubernetes_host" {
  description = "Kubernetes host."
  default     = "https://127.0.0.1:6443"
  type        = string
}


variable "kubernetes_token" {
  description = "Kubernetes token."
  sensitive   = true
  type        = string
}


variable "kubernetes_certificate" {
  description = "Kubernetes certificate (optional for insecure mode)."
  default     = ""
  sensitive   = true
  type        = string
}


variable "kubernetes_namespace" {
  description = "Kubernetes namespace."
  default     = "frontend"
  type        = string
}


variable "image_repository" {
  description = "Frontend image."
  default     = "localhost:5000/frontend"
  type        = string
}


variable "image_tag" {
  description = "Frontend tag."
  default     = "latest"
  type        = string
}


variable "api_url" {
  description = "Backend API URL."
  default     = "https://api.example.com"
  type        = string
}

# =============================================================================
# SANDBOX
# =============================================================================

locals {
  deploy_sandbox = var.deploy_mode == "sandbox" ? 1 : 0
  sandbox_folder = "/opt/github/thmb/frontend"
}


resource "kubernetes_namespace_v1" "frontend_sandbox" {
  count = local.deploy_sandbox

  metadata { name = var.kubernetes_namespace }
}


resource "kubernetes_pod_v1" "frontend_sandbox" {
  count = local.deploy_sandbox

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.frontend_sandbox[0].metadata[0].name
    labels    = { app = "frontend" }
  }

  spec {
    container {
      name  = "frontend"
      image = "${var.image_repository}:${var.image_tag}"

      command = ["/bin/bash", "-c"]
      args    = ["npm run dev"]

      resources {
        limits = {
          cpu    = "250m"
          memory = "256Mi"
        }
      }

      env {
        name  = "API_URL"
        value = var.api_url
      }

      port {
        name           = "http"
        container_port = 3000
        protocol       = "TCP"
      }

      volume_mount {
        name       = "src"
        mount_path = "/opt/frontend/src"
        read_only  = true
      }
    }

    volume {
      name = "src"
      host_path {
        path = "${local.sandbox_folder}/src"
        type = "Directory"
      }
    }

    restart_policy = "Always"
  }
}


resource "kubernetes_service_v1" "frontend_sandbox" {
  count = local.deploy_sandbox

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.frontend_sandbox[0].metadata[0].name
    labels    = { app = "frontend" }
  }

  spec {
    type = "ClusterIP" # internal

    selector = { app = "frontend" }

    port {
      name        = "http"
      port        = 80   # service
      target_port = 3000 # container
      protocol    = "TCP"
    }
  }
}


resource "kubernetes_ingress_v1" "frontend_sandbox" {
  count = local.deploy_sandbox

  metadata {
    name        = "frontend"
    namespace   = kubernetes_namespace_v1.frontend_sandbox[0].metadata[0].name
    labels      = { app = "frontend" }
    annotations = { "kubernetes.io/ingress.class" = "traefik" }
  }

  spec {
    rule {

      host = "frontend.localhost"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.frontend_sandbox[0].metadata[0].name
              port { name = "http" }
            }
          }
        }
      }
    }
  }
}

# =============================================================================
# RELEASE
# =============================================================================

locals {
  deploy_release = var.deploy_mode == "release" ? 1 : 0

  aws_account  = data.aws_caller_identity.current.account_id
  ecr_registry = "${local.aws_account}.dkr.ecr.${var.aws_region}.amazonaws.com"

  image_repository = "raio-storage-frontend"
  image_tag_latest = data.aws_ecr_image.frontend_release.image_tags[0]
}


data "aws_ecr_image" "frontend_release" {
  registry_id     = local.aws_account
  repository_name = local.image_repository
  most_recent     = true
}


data "aws_ecr_authorization_token" "frontend_release" {
  registry_id = local.aws_account
}


resource "kubernetes_namespace_v1" "frontend_release" {
  count = local.deploy_release

  metadata { name = var.kubernetes_namespace }
}


resource "kubernetes_secret_v1" "frontend_release" {
  count = local.deploy_release

  metadata {
    name      = "registry"
    namespace = kubernetes_namespace_v1.frontend_release[0].metadata[0].name
  }

  type = "kubernetes.io/dockerconfigjson"

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${local.ecr_registry}" = {
          auth = data.aws_ecr_authorization_token.frontend_release.authorization_token
        }
      }
    })
  }
}


resource "kubernetes_deployment_v1" "frontend_release" {
  count = local.deploy_release

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.frontend_release[0].metadata[0].name
    labels    = { app = "frontend" }
  }

  spec {
    replicas = 1

    selector {
      match_labels = { app = "frontend" }
    }

    template {
      metadata {
        labels = { app = "frontend" }
      }

      spec {
        image_pull_secrets { name = kubernetes_secret_v1.frontend_release[0].metadata[0].name }

        container {
          name  = "frontend"
          image = "${local.ecr_registry}/${local.image_repository}:${local.image_tag_latest}"

          port {
            name           = "http"
            protocol       = "TCP"
            container_port = 80
          }

          env {
            name  = "API_URL"
            value = "https://api.example.com" # placeholder
          }

          resources {
            limits = {
              cpu    = "250m"
              memory = "256Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }

          liveness_probe { # checks periodically if pod is responding
            http_get {
              path   = "/"
              port   = 80
              scheme = "HTTP"
            }
            initial_delay_seconds = 30
            period_seconds        = 10
            timeout_seconds       = 5
            failure_threshold     = 3
          }

          readiness_probe { # determines when pod is ready to receive traffic
            http_get {
              path   = "/"
              port   = 80
              scheme = "HTTP"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
            timeout_seconds       = 3
            failure_threshold     = 3
          }
        }
      }
    }
  }
}


resource "kubernetes_service_v1" "frontend_release" {
  count = local.deploy_release

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.frontend_release[0].metadata[0].name
    labels    = { app = "frontend" }
  }

  spec {
    type = "ClusterIP" # internal

    selector = { app = "frontend" }

    port {
      name        = "http"
      port        = 80 # service
      target_port = 80 # container
      protocol    = "TCP"
    }
  }
}


resource "kubernetes_ingress_v1" "frontend_release" {
  count = local.deploy_release

  metadata {
    name      = "frontend"
    namespace = kubernetes_namespace_v1.frontend_release[0].metadata[0].name
    labels    = { app = "frontend" }

    annotations = {
      "cert-manager.io/cluster-issuer"                   = "raio-platform-cluster-issuer"
      "traefik.ingress.kubernetes.io/router.entrypoints" = "websecure" # enable https
    }
  }

  spec {
    ingress_class_name = "traefik"

    tls {
      hosts       = ["app.raioenergia.com.br"]
      secret_name = "app-raioenergia-com-br-tls"
    }

    rule {
      host = "app.raioenergia.com.br"

      http {
        path {
          path      = "/"
          path_type = "Prefix"

          backend {
            service {
              name = kubernetes_service_v1.frontend_release[0].metadata[0].name
              port { name = "http" }
            }
          }
        }
      }
    }
  }
}
