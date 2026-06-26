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


