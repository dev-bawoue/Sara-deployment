# Module APIs - Activation des APIs Google Cloud
# REMARQUE : Ce module doit être appelé UNE SEULE FOIS par projet
# car les APIs sont activées au niveau projet, pas au niveau ressource

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

resource "google_project_service" "iam" {
  project            = var.project_id
  service            = "iam.googleapis.com"
  disable_on_destroy = false
}