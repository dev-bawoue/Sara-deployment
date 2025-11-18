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

# REMARQUE : Map d'instances - le for_each est dans main.tf, pas dans le module
variable "notebook_instances" {
  description = "Map des instances Workbench à créer. Clé = nom de l'instance"
  type = map(object({
    zone                  = optional(string)
    machine_type          = optional(string)
    boot_disk_size_gb     = optional(number)
    data_disk_size_gb     = optional(number)
    disable_public_ip     = optional(bool)
    idle_timeout_seconds  = optional(number)
    owner                 = optional(string)
    network_tags          = optional(list(string))
    labels                = optional(map(string))
    service_account_email = optional(string) # Service account dédié à cette instance
  }))

  default = {
    "data-scientist-1" = {
      owner = "user@company.com"
    }
  }
}

# Valeurs par défaut
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
  description = "Délai d'inactivité avant arrêt automatique (secondes)"
  type        = number
  default     = 3600
}

variable "default_network_tags" {
  description = "Tags réseau par défaut"
  type        = list(string)
  default     = []
}

# Sécurité
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

# Labels
variable "common_labels" {
  description = "Labels communs appliqués à toutes les instances"
  type        = map(string)
  default = {
    managed_by  = "terraform"
    environment = "dev"
  }
}