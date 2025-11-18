# Module Workbench - Déploiement d'UNE SEULE instance Vertex AI Workbench
# IMPORTANT : Ce module déploie une instance unique. Pour plusieurs instances,
# appelez ce module plusieurs fois depuis le fichier main.tf racine.

# Activation des APIs nécessaires
# REMARQUE : Ces ressources devraient être dans un module séparé "apis" 
# car elles doivent être activées une seule fois par projet
resource "google_project_service" "notebooks" {
  project            = var.project_id
  service            = "notebooks.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "compute" {
  project            = var.project_id
  service            = "compute.googleapis.com"
  disable_on_destroy = false
}

# Déploiement d'UNE instance Workbench
# REMARQUE : Pas de for_each ici - le module est conçu pour déployer UNE instance
resource "google_workbench_instance" "instance" {
  project  = var.project_id
  name     = var.instance_name
  location = var.zone

  gce_setup {
    machine_type = var.machine_type

    # Configuration des disques
    boot_disk {
      disk_size_gb = var.boot_disk_size_gb
      disk_type    = "PD_SSD"
    }

    data_disks {
      disk_size_gb = var.data_disk_size_gb
      disk_type    = "PD_SSD"
    }

    # Configuration réseau
    network_interfaces {
      network = "projects/${var.project_id}/global/networks/${var.network_name}"
      subnet  = "projects/${var.project_id}/regions/${regex("^([a-z]+-[a-z]+[0-9]+)", var.zone)[0]}/subnetworks/${var.subnet_name}"
    }

    # OPTIMISATION SÉCURITÉ : Pas d'IP publique
    disable_public_ip = var.disable_public_ip

    # OPTIMISATION SÉCURITÉ : Shielded VM
    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_vtpm                 = var.enable_vtpm
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }

    # OPTIMISATION COÛTS : Arrêt automatique après inactivité
    metadata = {
      terraform-managed    = "true"
      idle-timeout-seconds = var.idle_timeout_seconds
      instance-owners      = var.owner
      report-system-health = "true"
    }

    # Service Account dédié (spécifique à cette instance)
    dynamic "service_accounts" {
      for_each = var.service_account_email != null ? [1] : []
      content {
        email = var.service_account_email
      }
    }

    # Note : Le support GPU pour google_workbench_instance nécessite
    # l'utilisation de machine types avec GPU intégrés (ex: n1-standard-4-gpu)
    # ou configuration post-création via gcloud/console

    enable_ip_forwarding = false
    tags                 = var.network_tags
  }

  # Labels pour attribution des coûts
  labels = merge(
    var.common_labels,
    var.instance_labels,
    {
      managed_by = "terraform"
      # Note: owner est dans metadata, pas dans labels (labels GCP n'autorisent pas '@')
    }
  )

  depends_on = [
    google_project_service.notebooks,
    google_project_service.compute
  ]
}