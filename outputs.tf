# Outputs - Vertex AI Workbench

output "enabled_apis" {
  description = "APIs activées par le module foundation"
  value       = module.foundation.enabled_apis
}

output "instance_names" {
  description = "Noms des instances Workbench créées"
  value       = { for k, v in module.workbench : k => v.instance_name }
}

output "jupyterlab_urls" {
  description = "URLs JupyterLab pour accéder aux instances"
  value       = { for k, v in module.workbench : k => v.jupyterlab_url }
}

output "instance_details" {
  description = "Détails complets des instances"
  value = {
    for k, v in module.workbench : k => {
      name        = v.instance_name
      state       = v.state
      create_time = v.create_time
      proxy_uri   = v.proxy_uri
    }
  }
}

output "console_urls" {
  description = "URLs de la console GCP pour gérer les instances"
  value       = { for k, v in module.workbench : k => v.console_url }
}
