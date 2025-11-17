# Outputs du module Workbench

output "instance_names" {
  description = "Noms des instances Workbench créées"
  value       = { for k, v in google_workbench_instance.instances : k => v.name }
}

output "instance_ids" {
  description = "IDs des instances Workbench créées"
  value       = { for k, v in google_workbench_instance.instances : k => v.id }
}

output "instance_urls" {
  description = "URLs de la console pour accéder aux instances"
  value = {
    for k, v in google_workbench_instance.instances :
    k => "https://console.cloud.google.com/vertex-ai/workbench/instances/${v.location}/${v.name}?project=${var.project_id}"
  }
}

output "instance_details" {
  description = "Détails complets des instances créées"
  value = {
    for k, v in google_workbench_instance.instances : k => {
      name          = v.name
      location      = v.location
      machine_type  = v.gce_setup[0].machine_type
      state         = v.state
      create_time   = v.create_time
      proxy_uri     = v.proxy_uri
    }
  }
}

output "jupyterlab_urls" {
  description = "URLs JupyterLab pour se connecter directement aux notebooks"
  value       = { for k, v in google_workbench_instance.instances : k => v.proxy_uri }
}
