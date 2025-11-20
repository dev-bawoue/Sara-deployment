# Module Foundation - Activation des APIs GCP
# Ce module active les APIs nécessaires une seule fois par projet

resource "google_project_service" "required_apis" {
  for_each = toset(var.apis_to_enable)

  project            = var.project_id
  service            = each.value
  disable_on_destroy = false

  timeouts {
    create = "10m"
    update = "10m"
  }
}
