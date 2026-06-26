# Makefile pour MacronLinux — En mARCH! 🇫🇷

PROFILE_DIR = archiso/profiles/macronlinux
WORK_DIR    = archiso/work
OUTPUT_DIR  = output

ISO_STANDARD = $(OUTPUT_DIR)/macronlinux-standard.iso
ISO_NVIDIA   = $(OUTPUT_DIR)/macronlinux-nvidia.iso

QEMU_OPTS = -m 4G -smp 4 -enable-kvm -vga virtio

# ── Targets de build ────────────────────────────────────────────

## Construire la version standard
build-standard:
	@echo "==> Building MacronLinux Standard ISO..."
	sudo ./build-iso-minimal.sh standard

## Construire la version NVIDIA
build-nvidia:
	@echo "==> Building MacronLinux NVIDIA ISO..."
	sudo ./build-iso-minimal.sh nvidia

## Construire les deux versions
build: build-standard build-nvidia

# ── Targets de test ─────────────────────────────────────────────

## Tester la version standard avec QEMU
test-standard: $(ISO_STANDARD)
	@echo "==> Launching MacronLinux Standard in QEMU..."
	qemu-system-x86_64 $(QEMU_OPTS) -cdrom $(ISO_STANDARD)

## Tester la version NVIDIA avec QEMU
test-nvidia: $(ISO_NVIDIA)
	@echo "==> Launching MacronLinux NVIDIA in QEMU..."
	qemu-system-x86_64 $(QEMU_OPTS) -cdrom $(ISO_NVIDIA)

# ── Nettoyage ───────────────────────────────────────────────────

## Nettoyer les ISOs générées et le répertoire de travail
clean:
	@echo "==> Cleaning build artifacts..."
	rm -f $(ISO_STANDARD) $(ISO_NVIDIA)
	rm -rf $(WORK_DIR)/
	@echo "==> Done."

## Nettoyer tout (inclut le dossier output/)
clean-all: clean
	rm -rf $(OUTPUT_DIR)/

# ── Défaut ──────────────────────────────────────────────────────
all: build

.PHONY: build build-standard build-nvidia \
        test-standard test-nvidia \
        clean clean-all all
