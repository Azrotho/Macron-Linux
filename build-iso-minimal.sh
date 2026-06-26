#!/bin/bash
# build-iso-minimal.sh — Script de build MacronLinux
# Usage: sudo ./build-iso-minimal.sh [standard|nvidia]
# En mARCH! 🇫🇷

set -euo pipefail

# ── Paramètres ──────────────────────────────────────────────────

if [ "$#" -ne 1 ] || [[ "$1" != "standard" && "$1" != "nvidia" && "$1" != "server" ]]; then
    echo "Usage: $0 [standard|nvidia|server]"
    exit 1
fi

TYPE="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$TYPE" = "server" ]; then
    PROFILE_DIR="$SCRIPT_DIR/archiso/profiles/macronlinux-server"
else
    PROFILE_DIR="$SCRIPT_DIR/archiso/profiles/macronlinux"
fi
WORK_DIR="$SCRIPT_DIR/archiso/work/$TYPE"
OUTPUT_DIR="$SCRIPT_DIR/output"

# ── Préparation ─────────────────────────────────────────────────

mkdir -p "$WORK_DIR" "$OUTPUT_DIR"

# Pour la version NVIDIA, substituer le fichier packages
PACKAGES_ORIG="$PROFILE_DIR/packages.x86_64"
PACKAGES_BACKUP="$PROFILE_DIR/packages.x86_64.standard"

if [ "$TYPE" = "nvidia" ]; then
    echo "==> Activation des packages NVIDIA..."
    cp "$PACKAGES_ORIG" "$PACKAGES_BACKUP"
    cp "$PROFILE_DIR/packages-nvidia.x86_64" "$PACKAGES_ORIG"
fi

# Nettoyage des packages au signal d'interruption
cleanup() {
    if [ "$TYPE" = "nvidia" ] && [ -f "$PACKAGES_BACKUP" ]; then
        mv "$PACKAGES_BACKUP" "$PACKAGES_ORIG"
        echo "==> Packages restaurés."
    fi
}
trap cleanup EXIT INT TERM

# ── Build ────────────────────────────────────────────────────────

echo "==> MacronLinux — Build ISO ($TYPE)"
echo "    Profil   : $PROFILE_DIR"
echo "    Workdir  : $WORK_DIR"
echo "    Output   : $OUTPUT_DIR"
echo ""

mkarchiso -v -w "$WORK_DIR" -o "$OUTPUT_DIR" "$PROFILE_DIR"

# ── Renommage ────────────────────────────────────────────────────

ISO_NAME="macronlinux-${TYPE}.iso"

# mkarchiso génère : macronlinux-YYYY.MM.DD-x86_64.iso
BUILT_ISO=$(ls -t "$OUTPUT_DIR"/macronlinux-*.iso 2>/dev/null | grep -v "macronlinux-standard\|macronlinux-nvidia" | head -1 || true)

if [ -n "$BUILT_ISO" ]; then
    mv "$BUILT_ISO" "$OUTPUT_DIR/$ISO_NAME"
fi

# ── Vérification ─────────────────────────────────────────────────

if [ -f "$OUTPUT_DIR/$ISO_NAME" ]; then
    echo ""
    echo "==> ✅ ISO construite avec succès !"
    ls -lh "$OUTPUT_DIR/$ISO_NAME"
else
    echo ""
    echo "==> ❌ Échec de la construction. Contenu de $OUTPUT_DIR :"
    ls -la "$OUTPUT_DIR/" || true
    exit 1
fi
