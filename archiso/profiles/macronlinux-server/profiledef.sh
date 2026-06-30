#!/usr/bin/env bash
# shellcheck disable=SC2034

# === MacronLinux — En mARCH! ===
# profiledef.sh — Format standard mkarchiso (archiso 70+)

iso_name="macronlinux-server"
iso_label="MACRONLINUX_$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y%m)"
iso_publisher="MacronLinux <https://github.com/azrotho/Macron-Linux>"
iso_application="MacronLinux Live/Rescue CD — En mARCH!"
iso_version="$(date --date="@${SOURCE_DATE_EPOCH:-$(date +%s)}" +%Y.%m.%d)"

# Répertoire d'installation sur l'ISO (max 8 chars, [a-z0-9])
install_dir="arch"

# Modes de build : ISO et netboot
buildmodes=('iso' 'netboot')

# Modes de boot : BIOS (syslinux) + UEFI (systemd-boot)
bootmodes=('bios.syslinux'
           'uefi.systemd-boot')

# Configuration pacman
pacman_conf="pacman.conf"

# Image squashfs compressée en xz
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'xz' '-Xbcj' 'x86' '-b' '1M' '-Xdict-size' '1M')

# Permissions des fichiers sensibles
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/customize_airootfs.sh"]="0:0:755"
  ["/usr/local/bin/49.3"]="0:0:755"
  ["/usr/local/bin/en-marche"]="0:0:755"
  ["/usr/local/bin/install-mistral-vibe"]="0:0:755"
  ["/usr/local/bin/macronlinux-user-init.sh"]="0:0:755"
  ["/usr/local/bin/leboncoin"]="0:0:755"
  ["/usr/local/bin/le-slip-francais"]="0:0:755"
  ["/usr/local/bin/mistral-ai"]="0:0:755"
  ["/usr/local/bin/impots-gouv"]="0:0:755"
  ["/usr/local/bin/france-travail"]="0:0:755"
  ["/usr/local/bin/doctolib"]="0:0:755"
  ["/usr/local/bin/sncf-connect"]="0:0:755"
  ["/usr/local/bin/marmiton"]="0:0:755"
  ["/usr/local/bin/lvmh"]="0:0:755"
  ["/usr/local/bin/total-energies"]="0:0:755"
  ["/usr/local/bin/carrefour"]="0:0:755"
  ["/usr/local/bin/deezer"]="0:0:755"
  ["/usr/local/bin/dailymotion"]="0:0:755"
  ["/usr/local/bin/qwant"]="0:0:755"
  ["/usr/local/bin/bonjourlafuite"]="0:0:755"
  ["/usr/local/bin/elysee"]="0:0:755"
  ["/usr/local/bin/gouvernement"]="0:0:755"
  ["/usr/local/bin/assemblee-nationale"]="0:0:755"
  ["/usr/local/bin/senat"]="0:0:755"
  ["/usr/local/bin/conseil-constitutionnel"]="0:0:755"
  ["/usr/local/bin/service-public"]="0:0:755"
  ["/usr/local/bin/monespacesante"]="0:0:755"
  ["/usr/local/bin/caf"]="0:0:755"
  ["/usr/local/bin/ameli"]="0:0:755"
  ["/usr/local/bin/ants"]="0:0:755"
  ["/usr/local/bin/rappel-conso"]="0:0:755"
  ["/usr/local/bin/maprimerenov"]="0:0:755"
  ["/usr/local/bin/parcoursup"]="0:0:755"
  ["/usr/local/bin/sig"]="0:0:755"
  ["/usr/local/bin/cybermalveillance"]="0:0:755"
)
