#!/bin/bash
# .automated_script.sh — Script exécuté au démarrage du live (TTY1, autologin root)
# MacronLinux — En mARCH! 🇫🇷

# Clavier AZERTY français
loadkeys fr 2>/dev/null || true

# Afficher le MOTD
cat /etc/motd 2>/dev/null || true

# Informations système avec fastfetch
fastfetch 2>/dev/null || true

echo ""
echo "  KDE Plasma démarre via SDDM — bonne session ! 🇫🇷"
echo "  (Mistral Vibe s'installera automatiquement avec le réseau)"
echo ""
