#!/bin/bash
# build-iso-minimal.sh — Script de build MacronLinux
# Usage: sudo ./build-iso-minimal.sh [standard|nvidia]
# En mARCH! 🇫🇷

set -euo pipefail

# ── Paramètres ──────────────────────────────────────────────────

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ] || [[ "$1" != "standard" && "$1" != "nvidia" && "$1" != "server" ]] || ( [ "$#" -eq 2 ] && [[ "$2" != "iso" && "$2" != "netboot" ]] ); then
    echo "Usage: $0 [standard|nvidia|server] [iso|netboot]"
    exit 1
fi

TYPE="$1"
MODE="${2:-iso}"

if [ "$MODE" = "netboot" ] && [ "$TYPE" = "nvidia" ]; then
    echo "Error: netboot mode is not supported for NVIDIA version."
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ "$TYPE" = "server" ]; then
    PROFILE_DIR="$SCRIPT_DIR/archiso/profiles/macronlinux-server"
else
    PROFILE_DIR="$SCRIPT_DIR/archiso/profiles/macronlinux"
fi
WORK_DIR="$SCRIPT_DIR/archiso/work/${TYPE}-${MODE}"
if [ "$MODE" = "netboot" ]; then
    OUTPUT_DIR="$SCRIPT_DIR/output/netboot/$TYPE"
else
    OUTPUT_DIR="$SCRIPT_DIR/output"
fi

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

echo "==> MacronLinux — Build ($TYPE — $MODE)"
echo "    Profil   : $PROFILE_DIR"
echo "    Workdir  : $WORK_DIR"
echo "    Output   : $OUTPUT_DIR"
echo ""

mkarchiso -v -w "$WORK_DIR" -o "$OUTPUT_DIR" -m "$MODE" "$PROFILE_DIR"

# ── Post-processing & Vérification ───────────────────────────────

if [ "$MODE" = "iso" ]; then
    ISO_NAME="macronlinux-${TYPE}.iso"

    # mkarchiso génère : macronlinux-YYYY.MM.DD-x86_64.iso
    BUILT_ISO=$(ls -t "$OUTPUT_DIR"/macronlinux-*.iso 2>/dev/null | grep -Ev "macronlinux-(standard|nvidia|server)\.iso" | head -1 || true)

    if [ -n "$BUILT_ISO" ]; then
        mv "$BUILT_ISO" "$OUTPUT_DIR/$ISO_NAME"
    fi

    if [ -f "$OUTPUT_DIR/$ISO_NAME" ]; then
        echo ""
        echo "==> ✅ ISO construite avec succès !"
        ls -lh "$OUTPUT_DIR/$ISO_NAME"
    else
        echo ""
        echo "==> ❌ Échec de la construction ISO. Contenu de $OUTPUT_DIR :"
        ls -la "$OUTPUT_DIR/" || true
        exit 1
    fi
else
    # Mode Netboot
    if [ -f "$OUTPUT_DIR/arch/boot/x86_64/vmlinuz-linux" ] && \
       [ -f "$OUTPUT_DIR/arch/boot/x86_64/initramfs-linux.img" ] && \
       [ -f "$OUTPUT_DIR/arch/x86_64/airootfs.sfs" ]; then
        
        # Détection de l'adresse IP locale
        LOCAL_IP=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $7; exit}' || hostname -I | awk '{print $1}' || echo "192.168.1.100")

        # Génération du script iPXE d'exemple
        echo "==> Génération du script template iPXE (IP locale détectée : $LOCAL_IP)..."
        cat <<EOF > "$OUTPUT_DIR/macronlinux-${TYPE}.ipxe"
#!ipxe

# IP/Port du serveur HTTP hébergeant ce dossier.
# Adaptez ces valeurs à votre configuration réseau.
set server-ip $LOCAL_IP
set server-port 8000
set base-url http://\${server-ip}:\${server-port}/${TYPE}

echo Démarrage de MacronLinux (${TYPE}) via iPXE...
kernel \${base-url}/arch/boot/x86_64/vmlinuz-linux initrd=initramfs-linux.img archisobasedir=arch archiso_http_srv=\${base-url}/ ip=dhcp
initrd \${base-url}/arch/boot/x86_64/initramfs-linux.img
boot
EOF

        echo ""
        echo "==> ✅ Fichiers Netboot construits avec succès !"
        ls -lh "$OUTPUT_DIR/arch/boot/x86_64/vmlinuz-linux"
        ls -lh "$OUTPUT_DIR/arch/boot/x86_64/initramfs-linux.img"
        ls -lh "$OUTPUT_DIR/arch/x86_64/airootfs.sfs"
        ls -lh "$OUTPUT_DIR/macronlinux-${TYPE}.ipxe"
    else
        echo ""
        echo "==> ❌ Échec de la construction Netboot. Contenu de $OUTPUT_DIR :"
        find "$OUTPUT_DIR" || true
        exit 1
    fi
fi
