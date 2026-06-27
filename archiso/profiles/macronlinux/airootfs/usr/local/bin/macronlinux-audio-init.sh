#!/bin/bash
# macronlinux-audio-init.sh — Initialise le son et joue le son de démarrage
# En mARCH! 🇫🇷

# Attendre que PipeWire-Pulse soit opérationnel (max 10 secondes)
for i in {1..20}; do
    if pactl info >/dev/null 2>&1; then
        break
    fi
    sleep 0.5
done

# Désactiver le mode muet (unmute) et régler le volume à 80%
pactl set-sink-mute @DEFAULT_SINK@ false || true
pactl set-sink-volume @DEFAULT_SINK@ 80% || true

# Jouer le son de démarrage (Emmanuel Macron "Hey hey hey")
if [ -f "/usr/share/sounds/macronlinux/stereo/desktop-login.ogg" ]; then
    gst-play-1.0 /usr/share/sounds/macronlinux/stereo/desktop-login.ogg >/dev/null 2>&1 &
fi
