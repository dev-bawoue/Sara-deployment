# Outputs du module Workbench (instance unique)

output "instance_id" {
  description = "ID de l'instance"
  value       = google_workbench_instance.instance.id
}

output "instance_name" {
  description = "Nom de l'instance"
  value       = google_workbench_instance.instance.name
}

output "proxy_uri" {
  description = "URI du proxy JupyterLab"
  value       = google_workbench_instance.instance.proxy_uri
}

output "state" {
  description = "État de l'instance"
  value       = google_workbench_instance.instance.state
}

output "create_time" {
  description = "Date de création"
  value       = google_workbench_instance.instance.create_time
}

output "jupyterlab_url" {
  description = "URL complète pour accéder à JupyterLab"
  value       = "https://${google_workbench_instance.instance.proxy_uri}"
}

output "console_url" {
  description = "URL de la console GCP"
  value       = "https://console.cloud.google.com/vertex-ai/workbench/instances/${google_workbench_instance.instance.location}/${google_workbench_instance.instance.name}?project=${var.project_id}"
}
