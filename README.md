# Vertex AI Workbench - Terraform Module

Déploiement automatisé d'instances **Vertex AI Workbench** sur Google Cloud Platform avec Terraform.

## 📋 Description

Ce module Terraform permet de déployer des instances **Vertex AI Workbench** (environnements JupyterLab managés) avec :

- ✅ **Optimisation des coûts** : Idle timeout (arrêt automatique après inactivité)
- ✅ **Sécurité renforcée** : Shielded VM, pas d'IP publique par défaut
- ✅ **Multi-instances** : Déployez plusieurs instances avec une seule configuration
- ✅ **Reproductible** : Infrastructure as Code pour des déploiements cohérents
- ✅ **Labels** : Suivi automatique des coûts par équipe/projet

## 🚀 Démarrage rapide

### Prérequis

- [Terraform](https://www.terraform.io/downloads) >= 1.0
- Compte Google Cloud Platform avec un projet actif
- APIs activées : Compute Engine, Notebooks

### Installation

1. **Clonez ce repository** :
```bash
git clone <votre-repo>
cd vertex-workbench
```

2. **Configurez vos variables** :
```bash
cp terraform.tfvars.example terraform.tfvars
# Éditez terraform.tfvars avec vos valeurs
```

3. **Déployez** :
```bash
terraform init
terraform plan
terraform apply
```

4. **Accédez à JupyterLab** :
```bash
terraform output jupyterlab_urls
```

## 📁 Structure du projet

```
vertex-workbench/
├── main.tf                    # Configuration principale
├── variables.tf               # Variables d'entrée
├── outputs.tf                 # Sorties (URLs, détails instances)
├── terraform.tfvars.example   # Exemple de configuration
├── .gitignore                 # Fichiers à ignorer
├── README.md                  # Ce fichier
└── modules/
    └── workbench/             # Module Workbench réutilisable
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## 🛠️ Commandes utiles



### Ajouter une instance

1. Éditez `terraform.tfvars`
2. Ajoutez la nouvelle instance dans `notebook_instances`
3. Appliquez :
```bash
terraform apply
```

### Supprimer une instance

1. Retirez l'instance de `terraform.tfvars`
2. Appliquez :
```bash
terraform apply
```

### Tout supprimer

```bash
terraform destroy
```

## 📚 Documentation

- [Vertex AI Workbench](https://cloud.google.com/vertex-ai/docs/workbench)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [google_workbench_instance](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/workbench_instance)
