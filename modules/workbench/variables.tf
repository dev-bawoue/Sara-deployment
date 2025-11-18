# Variables du module Workbench
# Ce module déploie UNE SEULE instance - pas de map, pas de for_each

variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}

# REMARQUE : Variables pour UNE instance, pas une map
variable "instance_name" {
  description = "Nom de l'instance Workbench à créer"
  type        = string
}

variable "zone" {
  description = "Zone GCP pour l'instance"
  type        = string
  default     = "europe-west1-b"
}

variable "machine_type" {
  description = "Type de machine pour l'instance"
  type        = string
  default     = "e2-standard-2"
}

variable "boot_disk_size_gb" {
  description = "Taille du disque de démarrage (GB)"
  type        = number
  default     = 150
}

variable "data_disk_size_gb" {
  description = "Taille du disque de données (GB)"
  type        = number
  default     = 150
}

variable "disable_public_ip" {
  description = "Désactiver l'IP publique (recommandé pour sécurité)"
  type        = bool
  default     = true
}

variable "idle_timeout_seconds" {
  description = "Délai d'inactivité avant arrêt automatique (secondes). 3600 = 1h, 7200 = 2h"
  type        = number
  default     = 3600

  validation {
    condition     = var.idle_timeout_seconds >= 600
    error_message = "Le délai d'inactivité doit être d'au moins 600 secondes (10 minutes)."
  }
}

variable "owner" {
  description = "Email du propriétaire de l'instance"
  type        = string
  default     = ""
}

variable "network_tags" {
  description = "Tags réseau pour l'instance"
  type        = list(string)
  default     = []
}

variable "instance_labels" {
  description = "Labels spécifiques à cette instance"
  type        = map(string)
  default     = {}
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

# Service Account dédié à cette instance
variable "service_account_email" {
  description = "Email du service account dédié à cette instance (null = service account par défaut de Compute Engine)"
  type        = string
  default     = null
}

# Labels
variable "common_labels" {
  description = "Labels communs à appliquer à l'instance"
  type        = map(string)
  default = {
    managed_by = "terraform"
    component  = "workbench"
  }
}