# Outputs du module Workbench
# Sorties pour UNE instance

output "instance_name" {
  description = "Nom de l'instance Workbench créée"
  value       = google_workbench_instance.instance.name
}

output "instance_id" {
  description = "ID de l'instance Workbench créée"
  value       = google_workbench_instance.instance.id
}

output "instance_url" {
  description = "URL de la console pour accéder à l'instance"
  value       = "https://console.cloud.google.com/vertex-ai/workbench/instances/${google_workbench_instance.instance.location}/${google_workbench_instance.instance.name}?project=${var.project_id}"
}

output "instance_details" {
  description = "Détails complets de l'instance créée"
  value = {
    name         = google_workbench_instance.instance.name
    location     = google_workbench_instance.instance.location
    machine_type = google_workbench_instance.instance.gce_setup[0].machine_type
    state        = google_workbench_instance.instance.state
    create_time  = google_workbench_instance.instance.create_time
    proxy_uri    = google_workbench_instance.instance.proxy_uri
  }
}

output "jupyterlab_url" {
  description = "URL JupyterLab pour se connecter directement au notebook"
  value       = google_workbench_instance.instance.proxy_uri
}