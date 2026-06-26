# MacronLinux — En mARCH! 🇫🇷

> Une distribution Linux **parodique** basée sur Arch Linux, dédiée à la France et à Emmanuel Macron,  
> créée par Mistral pour la grandeur de la France.  
> ⚠️ Ce projet est une parodie et n'est pas affilié au gouvernement français ou à Emmanuel Macron ou Mistral AI.

---

## 🎉 Fonctionnalités

- **KDE Plasma** avec thème France personnalisé (bleu, blanc, rouge)
- **Fond d'écran et sons intégrés** :
  - `Emmanuel_Macron_dark.jpg` — Fond d'écran par défaut du bureau et du SDDM
  - `boot_sound.mp3` — Son de démarrage (connexion)
  - `error_sound.mp3` — Son pour les erreurs système
  - `hey-hey-hey-macron.mp3` — Son pour les notifications KDE
- **Mistral Vibe** — Installation automatique au premier démarrage (avec réseau)
- **Branding MacronLinux** — `os-release`, hostname, MOTD, neofetch remplacé par `fastfetch`
- **Deux versions** : standard (tous GPU) et NVIDIA (pilotes open-source `nvidia-open`)
- **Clavier AZERTY** et **locale française** préconfigurés
- **Fuseau horaire** Europe/Paris par défaut

---

## 🚀 Installation

### 1. Télécharger l'ISO

Récupérez la dernière release depuis [GitHub Releases](https://github.com/azrotho/Macron-Linux/releases).

Vérifiez l'intégrité :
```bash
sha256sum -c macronlinux-standard.iso.sha256
```

### 2. Créer une clé USB bootable

```bash
# Linux
sudo dd if=macronlinux-standard.iso of=/dev/sdX bs=4M status=progress conv=fsync

# Ou avec Rufus (Windows) / Balena Etcher (multiplateforme)
```

### 3. Démarrer et installer

Démarrez sur la clé USB. **Mistral Vibe** s'installera automatiquement au premier démarrage dès qu'une connexion réseau est disponible.

---

## 🛠️ Construction de l'ISO (build local)

Prérequis : **Arch Linux** avec `archiso` installé.

```bash
# Installer les dépendances
sudo pacman -S archiso

# Construire l'ISO standard
make build-standard

# Construire l'ISO NVIDIA
make build-nvidia

# Tester avec QEMU (KVM requis)
make test-standard
```

---

## ⚙️ Configuration

- **Thème France** — Personnalisable dans Paramètres système KDE → Couleurs
- **Fond d'écran** — Configurable dans `/usr/share/wallpapers/macronlinux/`
- **Sons** — Configurables dans `/usr/share/sounds/macronlinux/`
- **Mistral Vibe** — Logs disponibles dans `/var/log/mistral-vibe-install.log`

---

## 🤝 Contribution

Les contributions sont les bienvenues ! 🇫🇷

### Comment contribuer

1. **Fork** le dépôt
2. Créez une branche : `git checkout -b feature/mon-ajout`
3. Committez : `git commit -m "Ajoute un nouveau fond d'écran"`
4. Push et ouvrez une **Pull Request**

### Que peut-on contribuer ?

- 🖼️ Nouveaux fonds d'écran (dans `airootfs/usr/share/wallpapers/macronlinux/`)
- 🔊 Nouveaux sons (dans `airootfs/usr/share/sounds/macronlinux/`)
- 🐛 Corrections de bugs (ouvrez une [issue](https://github.com/azrotho/Macron-Linux/issues))
- ✨ Nouvelles fonctionnalités ou améliorations

---

## 🏗️ Structure du projet

```
Macron-Linux/
├── archiso/
│   └── profiles/macronlinux/
│       ├── profiledef.sh           # Définition du profil mkarchiso
│       ├── packages.x86_64         # Paquets version standard
│       ├── packages-nvidia.x86_64  # Paquets version NVIDIA
│       ├── pacman.conf             # Configuration pacman
│       └── airootfs/               # Système de fichiers du live
│           ├── etc/                # Configuration système
│           ├── root/               # Scripts de build (customize_airootfs.sh)
│           └── usr/share/          # Assets (wallpapers, sons, thème Plasma)
├── .github/workflows/build.yml     # CI/CD GitHub Actions
├── build-iso-minimal.sh            # Script de build principal
├── Makefile                        # Cibles make build/test/clean
└── plan/                           # Documentation de conception
```

---

## 📜 Licence

Ce projet est sous licence MIT. Voir [LICENSE](LICENSE) pour plus de détails.

---

## ⚠️ Avertissement

Ce projet est une **parodie** à but éducatif et humoristique.  
Il n'est pas affilié au gouvernement français, à Emmanuel Macron, ni à Mistral AI.

**Vive la France ! En mARCH! 🥖🧀🍷🚀**
