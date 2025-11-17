# Variables - Vertex AI Workbench

variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}

variable "region" {
  description = "Région GCP par défaut"
  type        = string
  default     = "europe-west1"
}

variable "default_zone" {
  description = "Zone GCP par défaut pour les instances Workbench"
  type        = string
  default     = "europe-west1-b"
}

variable "network_name" {
  description = "Nom du réseau VPC"
  type        = string
  default     = "default"
}

variable "subnet_name" {
  description = "Nom du sous-réseau"
  type        = string
  default     = "default"
}

variable "service_account_email" {
  description = "Email du service account (null = service account par défaut de Compute Engine)"
  type        = string
  default     = null
}

variable "notebook_instances" {
  description = "Map des instances Workbench à créer"
  type = map(object({
    zone                 = optional(string)
    machine_type         = optional(string)
    boot_disk_size_gb    = optional(number)
    data_disk_size_gb    = optional(number)
    disable_public_ip    = optional(bool)
    idle_timeout_seconds = optional(number)
    owner                = optional(string)
    labels               = optional(map(string))
  }))

  default = {
    "data-scientist-1" = {
      owner = "user@company.com"
    }
  }
}

variable "common_labels" {
  description = "Labels communs appliqués à toutes les instances"
  type        = map(string)
  default = {
    managed_by  = "terraform"
    environment = "dev"
  }
}
