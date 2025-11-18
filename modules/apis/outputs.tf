# Outputs du module APIs

output "enabled_services" {
  description = "Liste des services activés"
  value = [
    google_project_service.notebooks.service,
    google_project_service.compute.service,
    google_project_service.iam.service
  ]
}