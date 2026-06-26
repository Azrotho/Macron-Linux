# Makefile pour MacronLinux — En mARCH! 🇫🇷

PROFILE_DIR = archiso/profiles/macronlinux
WORK_DIR    = archiso/work
OUTPUT_DIR  = output

ISO_STANDARD = $(OUTPUT_DIR)/macronlinux-standard.iso
ISO_NVIDIA   = $(OUTPUT_DIR)/macronlinux-nvidia.iso
ISO_SERVER   = $(OUTPUT_DIR)/macronlinux-server.iso

QEMU_OPTS = -m 4G -smp 4 -enable-kvm -vga virtio
QEMU_SERVER_OPTS = -m 2G -smp 2 -enable-kvm -nographic

# ── Targets de build ────────────────────────────────────────────

## Construire la version standard
build-standard:
	@echo "==> Building MacronLinux Standard ISO..."
	sudo ./build-iso-minimal.sh standard

## Construire la version NVIDIA
build-nvidia:
	@echo "==> Building MacronLinux NVIDIA ISO..."
	sudo ./build-iso-minimal.sh nvidia

## Construire la version serveur
build-server:
	@echo "==> Building MacronLinux Server ISO..."
	sudo ./build-iso-minimal.sh server

## Construire la version standard netboot/iPXE
build-netboot-standard:
	@echo "==> Building MacronLinux Standard Netboot/iPXE..."
	sudo ./build-iso-minimal.sh standard netboot

## Construire la version serveur netboot/iPXE
build-netboot-server:
	@echo "==> Building MacronLinux Server Netboot/iPXE..."
	sudo ./build-iso-minimal.sh server netboot

## Construire toutes les versions Netboot/iPXE
build-netboot: build-netboot-standard build-netboot-server

## Démarrer le serveur HTTP local pour servir les fichiers Netboot/iPXE
netboot: build-netboot
	@echo "==> Démarrage du serveur HTTP local sur le port 8000..."
	@echo "==> Standard : http://localhost:8000/standard/macronlinux-standard.ipxe"
	@echo "==> Serveur  : http://localhost:8000/server/macronlinux-server.ipxe"
	@echo "==> (Appuyez sur Ctrl+C pour arrêter le serveur)"
	python -m http.server --directory $(OUTPUT_DIR)/netboot 8000

## Construire toutes les versions
build: build-standard build-nvidia build-server build-netboot

# ── Targets de test ─────────────────────────────────────────────

## Tester la version standard avec QEMU
test-standard: $(ISO_STANDARD)
	@echo "==> Launching MacronLinux Standard in QEMU..."
	qemu-system-x86_64 $(QEMU_OPTS) -cdrom $(ISO_STANDARD)

## Tester la version NVIDIA avec QEMU
test-nvidia: $(ISO_NVIDIA)
	@echo "==> Launching MacronLinux NVIDIA in QEMU..."
	qemu-system-x86_64 $(QEMU_OPTS) -cdrom $(ISO_NVIDIA)

## Tester la version serveur avec QEMU (mode console)
test-server: $(ISO_SERVER)
	@echo "==> Launching MacronLinux Server in QEMU..."
	qemu-system-x86_64 $(QEMU_SERVER_OPTS) -cdrom $(ISO_SERVER)

# ── Nettoyage ───────────────────────────────────────────────────

## Nettoyer les ISOs générées et le répertoire de travail
clean:
	@echo "==> Cleaning build artifacts..."
	rm -f $(ISO_STANDARD) $(ISO_NVIDIA) $(ISO_SERVER)
	rm -rf $(WORK_DIR)/
	@echo "==> Done."

## Nettoyer tout (inclut le dossier output/)
clean-all: clean
	rm -rf $(OUTPUT_DIR)/

# ── Défaut ──────────────────────────────────────────────────────
all: build

.PHONY: build build-standard build-nvidia build-server \
        build-netboot build-netboot-standard build-netboot-server netboot \
        test-standard test-nvidia test-server \
        clean clean-all all
