# Terraform Configuration - Vertex AI Workbench
# Déploiement automatisé d'instances Vertex AI Workbench avec optimisations

terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

# ==============================================================================
# MODULE VERTEX AI WORKBENCH
# ==============================================================================
module "workbench" {
  source = "./modules/workbench"

  project_id = var.project_id

  # Service account : utilise le service account par défaut de Compute Engine
  # Pour utiliser un service account dédié, créez-le d'abord et passez son email ici
  service_account_email = var.service_account_email

  # Configuration réseau
  network_name = var.network_name
  subnet_name  = var.subnet_name

  # Zone par défaut
  default_zone = var.default_zone

  # Instances à créer
  notebook_instances = var.notebook_instances

  # Labels communs
  common_labels = var.common_labels
}
