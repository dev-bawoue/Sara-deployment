# Variables du module Workbench optimisé

variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}

variable "notebook_instances" {
  description = "Map des instances Workbench à créer. Clé = nom de l'instance"
  type = map(object({
    zone                 = optional(string)
    machine_type         = optional(string)
    boot_disk_size_gb    = optional(number)
    data_disk_size_gb    = optional(number)
    disable_public_ip    = optional(bool)
    idle_timeout_seconds = optional(number)
    owner                = optional(string)
    gpu_type             = optional(string)
    gpu_count            = optional(number)
    network_tags         = optional(list(string))
    labels               = optional(map(string))
  }))

  # Exemple de configuration :
  # {
  #   "data-scientist-alice" = {
  #     machine_type         = "n1-standard-4"
  #     owner                = "alice@company.com"
  #     idle_timeout_seconds = 3600
  #   }
  #   "ml-engineer-bob" = {
  #     machine_type         = "n1-highmem-8"
  #     gpu_type             = "NVIDIA_TESLA_T4"
  #     gpu_count            = 1
  #     owner                = "bob@company.com"
  #     idle_timeout_seconds = 7200
  #   }
  # }
}

# Configuration par défaut
variable "default_zone" {
  description = "Zone par défaut pour les instances"
  type        = string
  default     = "europe-west1-b"
}

variable "default_machine_type" {
  description = "Type de machine par défaut"
  type        = string
  default     = "e2-standard-2"
}

variable "default_boot_disk_size_gb" {
  description = "Taille du disque de démarrage par défaut (GB)"
  type        = number
  default     = 150
}

variable "default_data_disk_size_gb" {
  description = "Taille du disque de données par défaut (GB)"
  type        = number
  default     = 150
}

variable "default_disable_public_ip" {
  description = "Désactiver l'IP publique par défaut (recommandé pour sécurité)"
  type        = bool
  default     = true
}

variable "default_idle_timeout_seconds" {
  description = "Délai d'inactivité avant arrêt automatique (secondes). 3600 = 1h, 7200 = 2h"
  type        = number
  default     = 3600

  validation {
    condition     = var.default_idle_timeout_seconds >= 600
    error_message = "Le délai d'inactivité doit être d'au moins 600 secondes (10 minutes)."
  }
}

variable "default_network_tags" {
  description = "Tags réseau par défaut"
  type        = list(string)
  default     = []
}

# Configuration réseau
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

# Sécurité : Shielded VM
variable "enable_secure_boot" {
  description = "Activer Secure Boot (Shielded VM)"
  type        = bool
  default     = true
}

variable "enable_vtpm" {
  description = "Activer vTPM (Shielded VM)"
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Activer le monitoring d'intégrité (Shielded VM)"
  type        = bool
  default     = true
}

# Service Account
variable "service_account_email" {
  description = "Email du service account à utiliser pour les instances (null = service account par défaut de Compute Engine)"
  type        = string
  default     = null
}

# Labels
variable "common_labels" {
  description = "Labels communs à appliquer à toutes les instances"
  type        = map(string)
  default = {
    managed_by = "terraform"
    component  = "workbench"
  }
}
