# Outputs - Vertex AI Workbench

output "instance_names" {
  description = "Noms des instances Workbench créées"
  value       = module.workbench.instance_names
}

output "jupyterlab_urls" {
  description = "URLs JupyterLab pour accéder aux instances"
  value       = module.workbench.jupyterlab_urls
}

output "instance_details" {
  description = "Détails complets des instances"
  value       = module.workbench.instance_details
}

output "console_urls" {
  description = "URLs de la console GCP pour gérer les instances"
  value       = module.workbench.instance_urls
}
