# Outputs du module Foundation

output "enabled_apis" {
  description = "Liste des APIs activées"
  value       = [for api in google_project_service.required_apis : api.service]
}

output "project_id" {
  description = "ID du projet"
  value       = var.project_id
}
