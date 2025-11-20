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

# ==============================================================================
# CONFIGURATION YAML
# ==============================================================================
locals {
  # Lecture du fichier de configuration YAML
  config = yamldecode(file("${path.module}/config.yaml"))
}

provider "google" {
  project = local.config.project_id
  region  = local.config.region
}

# ==============================================================================
# MODULE FOUNDATION - Activation des APIs (une seule fois)
# ==============================================================================
module "foundation" {
  source = "./modules/foundation"

  project_id = local.config.project_id
}

# ==============================================================================
# MODULE VERTEX AI WORKBENCH - Une instance par appel
# ==============================================================================
module "workbench" {
  for_each = local.config.notebook_instances
  source   = "./modules/workbench"

  # Dépendance sur les APIs
  depends_on = [module.foundation]

  # Configuration de base
  project_id = local.config.project_id
  name       = each.key
  zone       = coalesce(try(each.value.zone, null), local.config.default_zone)

  # Configuration de l'instance
  machine_type         = coalesce(try(each.value.machine_type, null), "e2-standard-2")
  boot_disk_size_gb    = coalesce(try(each.value.boot_disk_size_gb, null), 150)
  data_disk_size_gb    = coalesce(try(each.value.data_disk_size_gb, null), 100)
  disable_public_ip    = coalesce(try(each.value.disable_public_ip, null), true)
  idle_timeout_seconds = coalesce(try(each.value.idle_timeout_seconds, null), 3600)
  owner                = coalesce(try(each.value.owner, null), "")

  # Configuration réseau
  network_name = local.config.network_name
  subnet_name  = local.config.subnet_name

  # Service account (priorité: instance > défaut > null)
  service_account_email = coalesce(
    try(each.value.service_account_email, null),
    try(local.config.default_service_account_email, null)
  )

  # Labels
  labels = merge(local.config.common_labels, try(each.value.labels, {}))
}
