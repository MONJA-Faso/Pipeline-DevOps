#!/bin/bash

# Obtenir l'adresse IP de la machine
IP=$(hostname -I | awk '{print $1}')  # Utilisation de la première adresse IP disponible

echo "START - Installation de GitLab sur IP: $IP"

# Met à jour les paquets et installe les dépendances nécessaires
echo "Mise à jour des paquets et installation des dépendances..."
sudo apt-get update
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl

# Installer Postfix pour les notifications par e-mail
echo "Installation de Postfix..."
sudo apt-get install -y postfix

# Configure Postfix
echo "Configuration de Postfix..."
# Configuration automatique possible ici, sinon demander à l'utilisateur d'interagir
# En général, les paramètres par défaut conviennent pour une installation simple

# Ajouter le dépôt GitLab
echo "Ajout du dépôt GitLab..."
curl -sS https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

# Installer GitLab
echo "Installation de GitLab..."
# Remplacez `https://gitlab.example.com` par l'URL de votre instance GitLab
EXTERNAL_URL="http://$IP" sudo apt-get install -y gitlab-ee

# Reconfigurer GitLab pour appliquer les changements
echo "Reconfiguration de GitLab..."
sudo gitlab-ctl reconfigure

# Vérifier l'installation et fournir des instructions de connexion
echo "Installation terminée. Veuillez vérifier les logs pour toute erreur."
echo "Le mot de passe initial pour le compte root est stocké dans /etc/gitlab/initial_root_password"
echo "Vous pouvez afficher le mot de passe avec la commande suivante :"
echo "  sudo cat /etc/gitlab/initial_root_password"
echo "Connectez-vous avec le nom d'utilisateur 'root' et le mot de passe affiché."
echo "END - Installation de GitLab"

# Optionnel : reconfigurer les locales si nécessaire
# sudo dpkg-reconfigure locales
