# Outputs - Vertex AI Workbench

output "instance_names" {
  description = "Noms des instances Workbench créées"
  value       = { for k, v in module.workbench_instances : k => v.instance_name }
}

output "jupyterlab_urls" {
  description = "URLs JupyterLab pour accéder aux instances"
  value       = { for k, v in module.workbench_instances : k => v.jupyterlab_url }
}

output "instance_details" {
  description = "Détails complets des instances"
  value       = { for k, v in module.workbench_instances : k => v.instance_details }
}

output "console_urls" {
  description = "URLs de la console GCP pour gérer les instances"
  value       = { for k, v in module.workbench_instances : k => v.instance_url }
}

output "enabled_apis" {
  description = "APIs activées dans le projet"
  value       = module.apis.enabled_services
}