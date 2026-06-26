#!/bin/bash
# customize_airootfs.sh — Personnalisation de MacronLinux
# Exécuté par mkarchiso dans le chroot pendant le build.
# NE PAS faire de requêtes réseau ici (pas de réseau en chroot).

set -euo pipefail

echo "=== MacronLinux — En mARCH! — Début de la personnalisation ==="

# ---------------------------------------------------------------
# 1. Locale & langue
# ---------------------------------------------------------------
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "LC_ALL=fr_FR.UTF-8" >> /etc/locale.conf
locale-gen

# ---------------------------------------------------------------
# 2. Clavier par défaut
# ---------------------------------------------------------------
mkdir -p /etc/X11/xorg.conf.d
cat > /etc/X11/xorg.conf.d/00-keyboard.conf << 'EOF'
Section "InputClass"
    Identifier "system-keyboard"
    MatchIsKeyboard "on"
    Option "XkbLayout" "fr"
    Option "XkbVariant" "azerty"
EndSection
EOF

# Console en AZERTY
echo "KEYMAP=fr" > /etc/vconsole.conf
echo "FONT=eurlatgr" >> /etc/vconsole.conf

# ---------------------------------------------------------------
# 3. Fuseau horaire
# ---------------------------------------------------------------
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

# ---------------------------------------------------------------
# 3b. Mot de passe root par défaut (pour console d'urgence)
# ---------------------------------------------------------------
echo "root:macron" | chpasswd


# ---------------------------------------------------------------
# 4. Activer les services systemd
# ---------------------------------------------------------------
systemctl enable NetworkManager.service
systemctl enable sshd.service

# ---------------------------------------------------------------
# 7. Configuration fastfetch (remplace neofetch)
# ---------------------------------------------------------------
mkdir -p /etc/fastfetch
cat > /etc/fastfetch/config.jsonc << 'EOF'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
  "logo": {
    "source": "/etc/fastfetch/macronlinux.txt",
    "color": {
      "1": "34",
      "2": "97",
      "3": "31"
    },
    "padding": {
      "right": 2
    }
  },
  "display": {
    "separator": " → ",
    "color": {
      "keys": "blue",
      "title": "blue"
    }
  },
  "modules": [
    "title",
    "separator",
    {"type": "os",       "key": "OS"},
    {"type": "kernel",   "key": "Kernel"},
    {"type": "uptime",   "key": "Uptime"},
    {"type": "packages", "key": "Paquets"},
    {"type": "shell",    "key": "Shell"},
    {"type": "de",       "key": "DE"},
    {"type": "wm",       "key": "WM"},
    {"type": "cpu",      "key": "CPU"},
    {"type": "gpu",      "key": "GPU"},
    {"type": "memory",   "key": "RAM"},
    "separator"
  ]
}
EOF

# ---------------------------------------------------------------
# 9. Message MOTD
# ---------------------------------------------------------------
cat > /etc/motd << 'EOF'

  🇫🇷  Bienvenue sur MacronLinux Server Edition — En mARCH!  🇫🇷
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Distribution parodique basée sur Arch Linux
  Créée par Mistral pour la grandeur de la France.

  • Serveur SSH actif (Accès : root/macron ou macron/macron)
  • Lancez la commande 'install-mistral-vibe' pour installer Mistral Vibe
  • Édition Serveur (Headless, ultra-légère)
  • https://github.com/azrotho/Macron-Linux

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Vive la France ! 🥖🧀🍷

EOF

echo "=== MacronLinux — Personnalisation terminée ! ==="
