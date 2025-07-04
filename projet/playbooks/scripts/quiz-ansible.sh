#!/bin/bash
set -euo pipefail

# 1. Mettre à jour et installer git
dnf update -y
dnf install -y git curl

# 2. Installer Node.js 23 via NodeSource
curl -fsSL https://rpm.nodesource.com/setup_23.x | bash -

# 3. Installer nodejs
dnf install -y nodejs

# 4. Cloner / mettre à jour l'app
git clone https://github.com/franklin-tutorials/quiz-ansible.git /opt/quiz-ansible || \
  (cd /opt/quiz-ansible && git pull)

# 5. Installer les dépendances et builder
cd /opt/quiz-ansible
npm install
npm run build

# 6. Installer et lancer le serveur de production
npm install -g serve
# on force l'écoute sur toutes les interfaces en spécifiant le protocole
nohup serve -s dist -l http://0.0.0.0:3000 > /tmp/quiz-ansible.log 2>&1 &
