
# Activation des APIs nécessaires
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

# Déploiement des instances Workbench
resource "google_workbench_instance" "instances" {
  for_each = var.notebook_instances

  project  = var.project_id
  name     = each.key
  location = coalesce(try(each.value.zone, null), var.default_zone, "europe-west1-b")

  gce_setup {
    machine_type = try(each.value.machine_type, var.default_machine_type)

    # Configuration des disques
    boot_disk {
      disk_size_gb = try(each.value.boot_disk_size_gb, var.default_boot_disk_size_gb)
      disk_type    = "PD_SSD"
    }

    data_disks {
      disk_size_gb = try(each.value.data_disk_size_gb, var.default_data_disk_size_gb)
      disk_type    = "PD_SSD"
    }

    # Configuration réseau
    network_interfaces {
      network = "projects/${var.project_id}/global/networks/${var.network_name}"
      subnet  = "projects/${var.project_id}/regions/${regex("^([a-z]+-[a-z]+[0-9]+)", coalesce(try(each.value.zone, null), var.default_zone, "europe-west1-b"))[0]}/subnetworks/${var.subnet_name}"
    }

    # OPTIMISATION SÉCURITÉ : Pas d'IP publique
    disable_public_ip = try(each.value.disable_public_ip, var.default_disable_public_ip)

    # OPTIMISATION SÉCURITÉ : Shielded VM
    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_vtpm                 = var.enable_vtpm
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }

    # OPTIMISATION COÛTS : Arrêt automatique après inactivité
    metadata = {
      terraform-managed    = "true"
      idle-timeout-seconds = try(each.value.idle_timeout_seconds, var.default_idle_timeout_seconds)
      instance-owners      = try(each.value.owner, "")
      report-system-health = "true"
    }

    # Service Account (optionnel - utilise le service account par défaut si null)
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
    tags                 = try(each.value.network_tags, var.default_network_tags)
  }

  # Labels pour attribution des coûts
  labels = merge(
    var.common_labels,
    try(each.value.labels, {}),
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
