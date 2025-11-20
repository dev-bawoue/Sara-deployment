# Module Workbench - Déploie UNE instance Vertex AI Workbench
# Utiliser for_each au niveau de l'appel du module pour plusieurs instances

resource "google_workbench_instance" "instance" {
  project  = var.project_id
  name     = var.name
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

    # Sécurité : Pas d'IP publique
    disable_public_ip = var.disable_public_ip

    # Sécurité : Shielded VM
    shielded_instance_config {
      enable_secure_boot          = var.enable_secure_boot
      enable_vtpm                 = var.enable_vtpm
      enable_integrity_monitoring = var.enable_integrity_monitoring
    }

    # Métadonnées incluant l'idle timeout pour économies de coûts
    metadata = {
      terraform-managed    = "true"
      idle-timeout-seconds = var.idle_timeout_seconds
      instance-owners      = var.owner
      report-system-health = "true"
    }

    # Service Account (optionnel)
    dynamic "service_accounts" {
      for_each = var.service_account_email != null ? [1] : []
      content {
        email = var.service_account_email
      }
    }

    enable_ip_forwarding = false
    tags                 = var.network_tags
  }

  # Labels pour attribution des coûts
  labels = merge(var.labels, {
    managed_by = "terraform"
  })
}
