# MacronLinux — En mARCH! 🇫🇷

> Une distribution Linux **parodique** basée sur Arch Linux, dédiée à la France et à Emmanuel Macron,  
> créée par Mistral pour la grandeur de la France.  
> ⚠️ Ce projet est une parodie et n'est pas affilié au gouvernement français ou à Emmanuel Macron ou Mistral AI.

---

## 🎉 Fonctionnalités

- **Cinnamon Desktop** avec personnalisation MacronLinux
- **Fond d'écran et sons intégrés** :
  - `Emmanuel_Macron_dark.jpg` — Fond d'écran par défaut du bureau
  - `boot_sound.mp3` — Son de démarrage (connexion)
  - `error_sound.mp3` — Son pour les erreurs système
  - `hey-hey-hey-macron.mp3` — Son pour les notifications
- **Fond d'écran aléatoire au démarrage** (Option A) — Sélection dynamique d'un fond d'écran au boot (extensible).
- **Mistral Vibe** — Installation manuelle via la commande `install-mistral-vibe`.
- **Commandes parodiques intégrées** : `49.3` (passage en force root), `en-marche` (wrapper pacman Start-up Nation), et retours d'erreurs interactifs (citations cultes).
- **Autocomplétion (Tab-completion)** complète pour toutes les commandes personnalisées.
- **Branding MacronLinux** — `os-release`, hostname, MOTD, neofetch remplacé par `fastfetch`.
- **Trois versions** : standard (tous GPU), NVIDIA (pilotes open-source `nvidia-open`, à compiler soi-même) et **Server Edition** (headless, ultra-légère avec serveur SSH actif).
- **Clavier AZERTY** et **locale française** préconfigurés.
- **Fuseau horaire** Europe/Paris par défaut.

---

## 🚀 Installation

### 1. Télécharger l'ISO

Récupérez la dernière release depuis [GitHub Releases](https://github.com/azrotho/Macron-Linux/releases).

> [!IMPORTANT]
> Seules les versions **Standard** et **Server** sont proposées en téléchargement direct. La version **NVIDIA** doit être compilée par vos soins (voir section Build local), car l'optimisation pour des puces conçues par des multinationales américaines n'est pas souveraine et ne représente pas la grandeur de la France 🇫🇷.

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

Démarrez sur la clé USB. Le système démarrera directement sur le bureau Cinnamon. Pour installer **Mistral Vibe**, ouvrez un terminal et lancez la commande : `install-mistral-vibe`.

---

## 🛠️ Construction de l'ISO (build local)

Prérequis : **Arch Linux** avec `archiso` installé.

```bash
# Installer les dépendances
sudo pacman -S archiso

# Construire l'ISO standard
make build-standard

# Construire l'ISO NVIDIA (à compiler vous-même, non fournie pré-compilée)
make build-nvidia

# Construire l'ISO Server (sans environnement graphique, avec SSH)
make build-server

# Tester la version standard avec QEMU (KVM requis)
make test-standard

# Tester la version serveur dans le terminal (QEMU nographic)
make test-server
```

---

## 🌐 Démarrage par le réseau (Netboot / iPXE) local

MacronLinux intègre un système de démarrage par le réseau (Netboot/iPXE) entièrement local pour les versions **standard** et **serveur**.

Les fichiers compilés pour le netboot sont générés dans le sous-dossier `output/netboot/` qui est configuré dans le `.gitignore` et ne sera pas poussé sur votre dépôt distant.

### 1. Compiler et démarrer le serveur local en une commande

Pour compiler les fichiers nécessaires et démarrer le serveur HTTP de distribution local, lancez simplement :

```bash
make netboot
```

Cette commande va :
1. Compiler la version Standard en mode netboot (génère `output/netboot/standard/`).
2. Compiler la version Serveur en mode netboot (génère `output/netboot/server/`).
3. Démarrer un serveur HTTP Python local sur le port `8000` servant ces répertoires.

### 2. Démarrer une machine cliente

#### Méthode 1 : Démarrage direct (Interactif)
1. Au démarrage de votre client PXE ou de **netboot.xyz**, ouvrez la console iPXE (touche **`Ctrl+B`**).
2. Activez la configuration réseau et chargez le script d'installation interactif depuis notre dépôt GitHub :
   ```ipxe
   dhcp
   
   # Pour la version Standard (Cinnamon)
   chain https://raw.githubusercontent.com/azrotho/Macron-Linux/main/netboot/macronlinux-standard.ipxe
   
   # Pour la version Serveur (Headless)
   chain https://raw.githubusercontent.com/azrotho/Macron-Linux/main/netboot/macronlinux-server.ipxe
   ```
3. Le script interactif vous demandera de saisir l'adresse IP de votre machine locale (le serveur HTTP lancé à l'étape 1) et lancera le téléchargement du système.

#### Méthode 2 : Chainloading local direct (Automatique)
Si vous ne voulez pas saisir l'adresse IP manuellement, vous pouvez charger directement le script pré-configuré généré localement dans votre dossier de build :
```ipxe
dhcp
# Pour la version Standard
chain http://<ip-de-votre-machine-locale>:8000/standard/macronlinux-standard.ipxe

# Pour la version Serveur
chain http://<ip-de-votre-machine-locale>:8000/server/macronlinux-server.ipxe
```

---

## ⚙️ Configuration

- **Thème France** — Personnalisable dans les Paramètres système Cinnamon
- **Fond d'écran** — Configurable dans `/usr/share/wallpapers/macronlinux/`
- **Sons** — Configurables dans `/usr/share/sounds/macronlinux/`
- **Mistral Vibe** — Logs disponibles dans `/var/log/mistral-vibe-install.log`

---

## 🛠️ Commandes Parodiques

MacronLinux intègre des outils système repensés pour la grandeur de la République et de la Start-up Nation :

### 1. `49.3` — Le Passage en Force
Exécutez n'importe quelle commande en tant qu'administrateur sans demander l'avis du Parlement (ni de l'utilisateur).
- **Usage** : `49.3 <commande>`
- **Exemple** : `49.3 pacman -Syu`
- **Comportement** : Wrappe la commande avec `sudo` et affiche des messages parodiques de passage en force constitutionnel et de rejet de motion de censure.

### 2. `en-marche` — Gestion d'actifs technologiques (Pacman Wrapper)
Gérez vos paquets avec le vocabulaire de la Start-up Nation et de l'Élysée.
- **Usage** : `en-marche <action> [options]`
- **Actions disponibles** :
  - `installer <paquet>` : Négocie sur le marché des paquets pour installer un actif technologique (`pacman -S`).
  - `supprimer <paquet>` : Déclenche une rupture conventionnelle pour licencier un paquet (`pacman -Rns`).
  - `rechercher <terme>` : Source les innovations technologiques sur le marché (`pacman -Ss`).
  - `moderniser` : Lance la grande réforme structurelle de mise à jour du système (`pacman -Syu`).

### 3. Citations d'erreurs interactives
Chaque fois qu'une commande échoue dans le terminal (code de sortie non nul), le shell intercepte l'erreur pour afficher de manière aléatoire en rouge une citation culte d'Emmanuel Macron :
- *« C'est de la poudre de perlimpinpin ! »*
- *« Parce que c'est notre projeeet !!! »*
- *« Je traverse la rue et je vous en trouve du travail ! »*
- *« C'est un pognon de dingue ! »*

*(Note : L'autocomplétion complète via la touche `Tab` est disponible pour l'ensemble de ces commandes).*

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
├── netboot/                        # Scripts iPXE génériques pour le démarrage réseau
│   ├── macronlinux-standard.ipxe
│   └── macronlinux-server.ipxe
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
