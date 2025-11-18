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
# MODULE APIS - À APPELER UNE SEULE FOIS
# ==============================================================================
# REMARQUE : Ce module active les APIs nécessaires au niveau du projet
module "apis" {
  source = "./modules/apis"

  project_id = var.project_id
}

# ==============================================================================
# MODULES VERTEX AI WORKBENCH - UN APPEL PAR INSTANCE
# ==============================================================================
# REMARQUE : Chaque appel de module déploie UNE instance unique
# Pour plusieurs instances, utilisez for_each ICI, pas dans le module

module "workbench_instances" {
  source   = "./modules/workbench"
  for_each = var.notebook_instances

  project_id = var.project_id

  # Configuration de l'instance
  instance_name        = each.key
  zone                 = coalesce(each.value.zone, var.default_zone)
  machine_type         = coalesce(each.value.machine_type, var.default_machine_type)
  boot_disk_size_gb    = coalesce(each.value.boot_disk_size_gb, var.default_boot_disk_size_gb)
  data_disk_size_gb    = coalesce(each.value.data_disk_size_gb, var.default_data_disk_size_gb)
  disable_public_ip    = coalesce(each.value.disable_public_ip, var.default_disable_public_ip)
  idle_timeout_seconds = coalesce(each.value.idle_timeout_seconds, var.default_idle_timeout_seconds)
  owner                = coalesce(each.value.owner, "")
  network_tags         = coalesce(each.value.network_tags, var.default_network_tags)
  instance_labels      = coalesce(each.value.labels, {})

  # Service Account dédié à cette instance (optionnel)
  # REMARQUE : Chaque instance peut avoir son propre service account
  service_account_email = each.value.service_account_email

  # Configuration réseau
  network_name = var.network_name
  subnet_name  = var.subnet_name

  # Sécurité
  enable_secure_boot          = var.enable_secure_boot
  enable_vtpm                 = var.enable_vtpm
  enable_integrity_monitoring = var.enable_integrity_monitoring

  # Labels communs
  common_labels = var.common_labels

  depends_on = [module.apis]
}