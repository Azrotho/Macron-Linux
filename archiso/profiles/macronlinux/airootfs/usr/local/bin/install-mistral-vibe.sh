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

# Installer Mistral Vibe
if curl -LsSf https://mistral.ai/vibe/install.sh | bash >> "$LOG_FILE" 2>&1; then
    log "✅ Mistral Vibe installé avec succès !"

    # Désactiver le service pour ne pas réexécuter au prochain boot
    systemctl disable mistral-vibe-install.service || true
    log "Service mistral-vibe-install désactivé."
else
    log "ERREUR : L'installation de Mistral Vibe a échoué. Voir $LOG_FILE"
    exit 1
fi
