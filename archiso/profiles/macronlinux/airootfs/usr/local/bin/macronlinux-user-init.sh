#!/bin/bash
# macronlinux-user-init.sh — Initialisation de l'utilisateur live "macron"
# En mARCH! 🇫🇷

set -euo pipefail

# 1. Création du groupe et de l'utilisateur macron
if ! getent group macron >/dev/null; then
    groupadd -g 1000 macron
fi

if ! getent passwd macron >/dev/null; then
    useradd -u 1000 -g macron -G wheel,audio,video,storage,power -m -s /bin/bash -p '$6$ZhMa/lZ1y5aGgLaD$d35t8ufUQzF4L7ZnzAYqqPyd3YT96g4K5vctD31rfSHyUdE89EkUrAjM8h7GKMo4m8WEGhBaafHtY6CfXQxdg1' macron
fi

# 2. Copie propre des configurations skel vers home
cp -rT /etc/skel /home/macron
chown -R macron:macron /home/macron

# 3. Configuration de sudo sans mot de passe pour le groupe wheel
echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/90-macronlinux
chmod 440 /etc/sudoers.d/90-macronlinux

# 4. Sélection d'un fond d'écran aléatoire au boot
WALLPAPER_DIR="/usr/share/wallpapers/macronlinux"
if [ -d "$WALLPAPER_DIR" ]; then
    # Trouver toutes les images réelles (exclure le lien symbolique current_wallpaper.jpg)
    RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f -not -name "current_wallpaper.jpg" | shuf -n 1)
    if [ -n "$RANDOM_WALLPAPER" ]; then
        ln -sf "$RANDOM_WALLPAPER" "$WALLPAPER_DIR/current_wallpaper.jpg"
    fi
fi


