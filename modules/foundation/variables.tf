# Variables du module Foundation

variable "project_id" {
  description = "ID du projet Google Cloud"
  type        = string
}

variable "apis_to_enable" {
  description = "Liste des APIs à activer"
  type        = list(string)
  default = [
    "notebooks.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com"
  ]
}
