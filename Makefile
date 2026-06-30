# Makefile pour MacronLinux — En mARCH! 🇫🇷

PROFILE_DIR = archiso/profiles/macronlinux
WORK_DIR    = archiso/work
OUTPUT_DIR  = output

ISO_STANDARD = $(OUTPUT_DIR)/macronlinux-standard.iso
ISO_NVIDIA   = $(OUTPUT_DIR)/macronlinux-nvidia.iso
ISO_SERVER   = $(OUTPUT_DIR)/macronlinux-server.iso

QEMU_OPTS = -m 4G -smp 4 -enable-kvm -vga virtio
QEMU_SERVER_OPTS = -m 2G -smp 2 -enable-kvm -nographic

OVMF_CODE = /usr/share/edk2/x64/OVMF_CODE.4m.fd
OVMF_VARS = /usr/share/edk2/x64/OVMF_VARS.4m.fd
LOG_DIR   = logs
HTTP_PORT = 8000

NETBOOT_STANDARD_KERNEL = $(OUTPUT_DIR)/netboot/standard/arch/boot/x86_64/vmlinuz-linux
NETBOOT_STANDARD_INITRD = $(OUTPUT_DIR)/netboot/standard/arch/boot/x86_64/initramfs-linux.img
NETBOOT_SERVER_KERNEL   = $(OUTPUT_DIR)/netboot/server/arch/boot/x86_64/vmlinuz-linux
NETBOOT_SERVER_INITRD   = $(OUTPUT_DIR)/netboot/server/arch/boot/x86_64/initramfs-linux.img

# ── Targets de build ────────────────────────────────────────────

## Construire la version standard
build-standard:
	@echo "==> Building MacronLinux Standard ISO..."
	sudo ./build-iso-minimal.sh standard

## Construire la version standard via Docker (pour non-Arch Linux)
build-docker-standard:
	@echo "==> Building MacronLinux Standard ISO inside Docker..."
	docker run --privileged --rm -v $(CURDIR):/workspace -w /workspace archlinux:latest bash -c 'pacman -Syu --noconfirm archiso && (./build-iso-minimal.sh standard; status=$$?; rm -rf archiso/work/standard-iso; exit $$status)'

## Construire la version NVIDIA
build-nvidia:
	@echo "==> Building MacronLinux NVIDIA ISO..."
	sudo ./build-iso-minimal.sh nvidia

## Construire la version NVIDIA via Docker (pour non-Arch Linux)
build-docker-nvidia:
	@echo "==> Building MacronLinux NVIDIA ISO inside Docker..."
	docker run --privileged --rm -v $(CURDIR):/workspace -w /workspace archlinux:latest bash -c 'pacman -Syu --noconfirm archiso && (./build-iso-minimal.sh nvidia; status=$$?; rm -rf archiso/work/nvidia-iso; exit $$status)'

## Construire la version serveur
build-server:
	@echo "==> Building MacronLinux Server ISO..."
	sudo ./build-iso-minimal.sh server

## Construire la version serveur via Docker (pour non-Arch Linux)
build-docker-server:
	@echo "==> Building MacronLinux Server ISO inside Docker..."
	docker run --privileged --rm -v $(CURDIR):/workspace -w /workspace archlinux:latest bash -c 'pacman -Syu --noconfirm archiso && (./build-iso-minimal.sh server; status=$$?; rm -rf archiso/work/server-iso; exit $$status)'

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

## Démarrer le serveur HTTP local pour servir spécifiquement la version serveur Netboot/iPXE
netboot-server: build-netboot-server
	@echo "==> Démarrage du serveur HTTP local sur le port 8000..."
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

## Tester le netboot standard dans QEMU (UEFI, GUI, logs dans logs/)
test-netboot-standard: $(NETBOOT_STANDARD_KERNEL)
	@mkdir -p $(LOG_DIR)
	@echo "==> [1/3] Démarrage du serveur HTTP sur le port $(HTTP_PORT)..."
	@python3 -m http.server --directory $(OUTPUT_DIR)/netboot $(HTTP_PORT) \
		> $(LOG_DIR)/http-standard.log 2>&1 & echo $$! > $(LOG_DIR)/http-standard.pid
	@cp $(OVMF_VARS) /tmp/ovmf-vars-standard.fd
	@echo "==> [2/3] Lancement QEMU — netboot standard (UEFI + virtio-net)"
	@echo "    Logs kernel : $(LOG_DIR)/netboot-standard.log"
	@echo "    Logs QEMU   : $(LOG_DIR)/qemu-standard.log"
	@echo "    (Fermer la fenêtre QEMU pour terminer)"
	-qemu-system-x86_64 \
		-m 4G -smp 4 -enable-kvm \
		-drive if=pflash,format=raw,readonly=on,file=$(OVMF_CODE) \
		-drive if=pflash,format=raw,file=/tmp/ovmf-vars-standard.fd \
		-kernel $(NETBOOT_STANDARD_KERNEL) \
		-initrd $(NETBOOT_STANDARD_INITRD) \
		-append "initrd=initrd archisobasedir=arch archiso_http_srv=http://10.0.2.2:$(HTTP_PORT)/standard/ ip=:::::eth0:dhcp net.ifnames=0" \
		-netdev user,id=net0 \
		-device virtio-net-pci,netdev=net0,romfile=/usr/share/qemu/pxe-virtio.rom \
		-serial file:$(LOG_DIR)/netboot-standard.log \
		-serial mon:stdio \
		-vga virtio \
		2>$(LOG_DIR)/qemu-standard.log
	@echo "==> [3/3] Arrêt du serveur HTTP..."
	@-kill $$(cat $(LOG_DIR)/http-standard.pid 2>/dev/null) 2>/dev/null || true
	@rm -f /tmp/ovmf-vars-standard.fd $(LOG_DIR)/http-standard.pid
	@echo "==> Logs disponibles dans $(LOG_DIR)/"
	@echo "    tail -f $(LOG_DIR)/netboot-standard.log"

## Tester le netboot serveur dans QEMU — headless, logs kernel en direct
test-netboot-server: $(NETBOOT_SERVER_KERNEL)
	@mkdir -p $(LOG_DIR)
	@echo "==> [1/3] Démarrage du serveur HTTP sur le port $(HTTP_PORT)..."
	@python3 -m http.server --directory $(OUTPUT_DIR)/netboot $(HTTP_PORT) \
		> $(LOG_DIR)/http-server.log 2>&1 & echo $$! > $(LOG_DIR)/http-server.pid
	@echo "==> [2/3] Lancement QEMU — netboot serveur (headless, logs en direct)"
	@echo "    Logs kernel : $(LOG_DIR)/netboot-server.log"
	@echo "    Ctrl+A puis X pour quitter QEMU"
	-qemu-system-x86_64 \
		-m 2G -smp 2 -enable-kvm \
		-kernel $(NETBOOT_SERVER_KERNEL) \
		-initrd $(NETBOOT_SERVER_INITRD) \
		-append "initrd=initrd archisobasedir=arch archiso_http_srv=http://10.0.2.2:$(HTTP_PORT)/server/ ip=:::::eth0:dhcp net.ifnames=0 console=tty0 console=ttyS0,115200" \
		-netdev user,id=net0 \
		-device virtio-net-pci,netdev=net0,romfile=/usr/share/qemu/pxe-virtio.rom \
		-serial file:$(LOG_DIR)/netboot-server.log \
		-serial mon:stdio \
		-display none \
		-nographic \
		2>$(LOG_DIR)/qemu-server.log
	@echo "==> [3/3] Arrêt du serveur HTTP..."
	@-kill $$(cat $(LOG_DIR)/http-server.pid 2>/dev/null) 2>/dev/null || true
	@rm -f $(LOG_DIR)/http-server.pid
	@echo "==> Logs disponibles dans $(LOG_DIR)/"
	@echo "    cat $(LOG_DIR)/netboot-server.log"

# Règles de dépendance — build automatique si les fichiers netboot sont absents
$(NETBOOT_STANDARD_KERNEL):
	@echo "==> Fichiers netboot standard introuvables, build en cours..."
	$(MAKE) build-netboot-standard

$(NETBOOT_SERVER_KERNEL):
	@echo "==> Fichiers netboot serveur introuvables, build en cours..."
	$(MAKE) build-netboot-server

# ── Nettoyage ───────────────────────────────────────────────────

## Nettoyer les ISOs générées et le répertoire de travail
clean:
	@echo "==> [1/5] Arrêt des processus de build orphelins..."
	-pkill -f "mksquashfs.*$(WORK_DIR)" 2>/dev/null || true
	-pkill -f "mkarchiso.*$(WORK_DIR)" 2>/dev/null || true
	@sleep 1
	@echo "==> [2/5] Démontage des bind mounts (3 passes, profondeur décroissante)..."
	@for i in 1 2 3; do \
		grep "$(WORK_DIR)" /proc/mounts \
			| awk '{print $$2}' \
			| awk '{print length, $$0}' \
			| sort -rn \
			| awk '{print $$2}' \
			| xargs -r umount -l 2>/dev/null || true; \
	done
	@echo "==> [3/5] Détachement des loop devices orphelins..."
	-losetup -a 2>/dev/null | grep "$(WORK_DIR)" | cut -d: -f1 | xargs -r losetup -d 2>/dev/null || true
	@echo "==> [4/5] Suppression des ISOs..."
	rm -f $(ISO_STANDARD) $(ISO_NVIDIA) $(ISO_SERVER)
	@echo "==> [5/5] Suppression du répertoire de travail..."
	sudo rm -rf $(WORK_DIR)/
	@echo "==> Done."

## Nettoyer tout (inclut le dossier output/)
clean-all: clean
	rm -rf $(OUTPUT_DIR)/

# ── Défaut ──────────────────────────────────────────────────────
all: build

.PHONY: build build-standard build-nvidia build-server \
        build-docker-standard build-docker-nvidia build-docker-server \
        build-netboot build-netboot-standard build-netboot-server netboot netboot-server \
        test-standard test-nvidia test-server \
        test-netboot-standard test-netboot-server \
        clean clean-all all
