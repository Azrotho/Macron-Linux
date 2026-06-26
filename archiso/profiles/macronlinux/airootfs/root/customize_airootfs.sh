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
# 4. Activer les services systemd
# ---------------------------------------------------------------
systemctl enable NetworkManager.service
systemctl enable sddm.service
systemctl enable mistral-vibe-install.service

# ---------------------------------------------------------------
# 5. Configuration SDDM (login avec fond Macron)
# ---------------------------------------------------------------
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/macronlinux.conf << 'EOF'
[Theme]
Current=breeze

[Autologin]
# Pas d'autologin en mode live pour la sécurité
User=
Session=

[General]
InputMethod=
EOF

# Configurer le fond d'écran SDDM via KDE settings
mkdir -p /usr/share/sddm/themes/breeze
cat > /usr/share/sddm/themes/breeze/theme.conf.user << 'EOF'
[General]
background=/usr/share/wallpapers/macronlinux/Emmanuel_Macron_dark.jpg
EOF

# ---------------------------------------------------------------
# 6. Configuration KDE pour root (session live)
# ---------------------------------------------------------------
mkdir -p /root/.config

# Copier TOUTES les configs skel vers root (thème, sons, fond d'écran, notifications)
for f in /etc/skel/.config/*; do
    [ -e "$f" ] && cp -r "$f" /root/.config/
done

# Fond d'écran écran de verrouillage
mkdir -p /root/.config/plasma-workspace/env
cat > /root/.config/kscreenlockerrc << 'EOF'
[Greeter][Wallpaper][org.kde.image][General]
Image=file:///usr/share/wallpapers/macronlinux/Emmanuel_Macron_dark.jpg
EOF

# ---------------------------------------------------------------
# 6b. Thème sonore KDE MacronLinux
# ---------------------------------------------------------------
cat > /root/.config/kdeglobals.soundtheme << 'EOF'
[General]
SoundTheme=macronlinux
EOF

# Configurer le thème sonore dans plasma (notifications = hey-hey-hey-macron)
cat >> /root/.config/knotifyrc << 'EOF'

[Notification Messages]
SoundTheme=macronlinux
EOF

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
    {"type": "os",       "key": "🇫🇷 OS     "},
    {"type": "kernel",   "key": "   Kernel"},
    {"type": "uptime",   "key": "   Uptime"},
    {"type": "packages", "key": "   Paquets"},
    {"type": "shell",    "key": "   Shell"},
    {"type": "de",       "key": "   DE"},
    {"type": "wm",       "key": "   WM"},
    {"type": "cpu",      "key": "   CPU"},
    {"type": "gpu",      "key": "   GPU"},
    {"type": "memory",   "key": "   RAM"},
    "separator"
  ]
}
EOF

# ---------------------------------------------------------------
# 8. Thème Plasma — MacronLinux (bleu, blanc, rouge)
# ---------------------------------------------------------------
# Le fichier colors est directement dans le répertoire du thème
# (corrigé dans l'arborescence du profil)

# ---------------------------------------------------------------
# 9. Message MOTD
# ---------------------------------------------------------------
cat > /etc/motd << 'EOF'

  🇫🇷  Bienvenue sur MacronLinux — En mARCH!  🇫🇷
  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Distribution parodique basée sur Arch Linux
  Créée par Mistral pour la grandeur de la France.

  • Mistral Vibe s'installera automatiquement au 1er démarrage
  • KDE Plasma avec thème France (bleu, blanc, rouge)
  • https://github.com/azrotho/Macron-Linux

  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Vive la France ! 🥖🧀🍷

EOF

echo "=== MacronLinux — Personnalisation terminée ! ==="
