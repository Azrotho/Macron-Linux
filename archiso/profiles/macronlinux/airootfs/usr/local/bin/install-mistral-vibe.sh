#!/bin/bash
# install-mistral-vibe.sh — Installation de Mistral Vibe au premier démarrage
# MacronLinux — En mARCH! 🇫🇷

set -euo pipefail

LOG_FILE="/var/log/mistral-vibe-install.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "=== MacronLinux — Installation de Mistral Vibe ==="
log "Pour la grandeur de la France 🇫🇷"

# Vérifier la connexion réseau
if ! ping -c 1 -W 5 mistral.ai &>/dev/null; then
    log "ERREUR : Pas de connexion réseau. Mistral Vibe sera installé au prochain démarrage."
    exit 1
fi

log "Connexion réseau OK. Téléchargement de Mistral Vibe..."

# Installer Mistral Vibe en tant qu'utilisateur macron
log "Exécution de l'installateur sous l'utilisateur macron..."
if sudo -u macron -i curl -LsSf https://mistral.ai/vibe/install.sh | sudo -u macron -i bash >> "$LOG_FILE" 2>&1; then
    log "Création des liens symboliques pour l'accès global à la commande vibe..."
    ln -sf /home/macron/.local/bin/vibe /usr/local/bin/vibe
    ln -sf /home/macron/.local/bin/vibe-acp /usr/local/bin/vibe-acp
    log "✅ Mistral Vibe installé avec succès !"

    # Désactiver le service pour ne pas réexécuter au prochain boot
    systemctl disable mistral-vibe-install.service || true
    log "Service mistral-vibe-install désactivé."
else
    log "ERREUR : L'installation de Mistral Vibe a échoué. Voir $LOG_FILE"
    exit 1
fi

