# Projet Terraform AWS

Ce projet contient les modules Terraform necessaires pour déployer une application WordPress fonctionelle sur AWS en utilisant RDS comme base de données 

## Structure du projet

Le projet est organisé en plusieurs modules Terraform, chacun responsable d'une partie spécifique de l'infrastructure :

- `compute` : Ce module gère le déploiement des instances EC2 pour faire tourner WordPress, afin d'assurer la haute disponibilité un autoscaling a été mis en place.
- `networking` : Ce module configure le réseau VPC,  les sous-réseaux, les équilibreurs de charge.
- `rds` : Ce module déploie une instance RDS pour la base de données WordPress avec une read replica de linstance.
- `security` : Ce module gère les groupes de sécurité pour les différentes ressources.

## Utilisation

Pour utiliser ce projet, vous devez avoir Terraform installé. Ensuite, vous pouvez cloner ce dépôt et exécuter `terraform init` pour initialiser votre environnement Terraform.

## Variables

Les variables pour chaque module sont définies dans les fichiers `variables.tf` correspondants. V

Afin de déployer cette finfrastructure il est imperatif de fournir vos Credentials pour AWS : 

Soit via un export de la variable d'environement :


## Credentials AWS


Par default Terraform va utiliser votre configuration locale si elle est déjà configurée

géneralement stocké ici : ~/.aws/credentials 

si vous navez pas de configuration vous pouvez exporter vos cretenti!als temporairement de cette maniere

export AWS_ACCESS_KEY_ID="votre_access_key_id"
export AWS_SECRET_ACCESS_KEY="votre_secret_access_key"

si vous avez plusieurs configurations, alors le choix dois se faire dans le provider qui se trouve dans le main.tf

## Variables BDD

Vous devez fournir les variables pour pouvoir vous connecter, il n y'a pas de variable prefeinies, vous choissisez vos propres variables qui serons transmises a wordpress par le script  

Vous pouvez le faire de cette maniére dans la console en cli

export TF_VAR_db_name="votre_nom_de_db"
export TF_VAR_db_user="votre_utilisateur_db"
export TF_VAR_db_password="votre_mot_de_passe_db"

Pour créer l'infrastructure, exécutez `terraform apply` et confirmez que vous voulez procéder lorsque vous y êtes invité.

## Nettoyage

Pour détruire l'infrastructure lorsque vous avez terminé, exécutez `terraform destroy`.
