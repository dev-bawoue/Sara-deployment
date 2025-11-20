# Variables du module Workbench (instance unique)

variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}

variable "name" {
  description = "Nom de l'instance Workbench"
  type        = string
}

variable "zone" {
  description = "Zone GCP pour l'instance"
  type        = string
}

variable "machine_type" {
  description = "Type de machine"
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
  default     = 100
}

variable "disable_public_ip" {
  description = "Désactiver l'IP publique (recommandé pour sécurité)"
  type        = bool
  default     = true
}

variable "idle_timeout_seconds" {
  description = "Délai d'inactivité avant arrêt automatique (secondes)"
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

variable "network_tags" {
  description = "Tags réseau"
  type        = list(string)
  default     = []
}

# Sécurité : Shielded VM
variable "enable_secure_boot" {
  description = "Activer Secure Boot"
  type        = bool
  default     = true
}

variable "enable_vtpm" {
  description = "Activer vTPM"
  type        = bool
  default     = true
}

variable "enable_integrity_monitoring" {
  description = "Activer le monitoring d'intégrité"
  type        = bool
  default     = true
}

variable "service_account_email" {
  description = "Email du service account (null = service account par défaut)"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels à appliquer à l'instance"
  type        = map(string)
  default     = {}
}
