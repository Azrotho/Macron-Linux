# Configuration de Base

## Objectif
Configurer une image ISO basée sur Arch Linux avec les paquets nécessaires pour KDE, les outils de personnalisation, et Mistral Vibe.

## Étapes
1. **Création de l'image ISO**
   - Utiliser `archiso` pour créer une image ISO personnalisée.
   - Configurer le fichier `packages.x86_64` pour inclure les paquets nécessaires :
     - `plasma` (environnement KDE)
     - `kde-applications` (applications KDE)
     - `sddm` (gestionnaire de connexion)
     - `neofetch` (pour le branding)
     - `ffmpeg` (pour la gestion des sons)
     - `curl` (pour l'installation de Mistral Vibe)

2. **Configuration du système**
   - Modifier le fichier `airootfs/etc/hostname` pour définir le nom de la distribution.
   - Configurer le fichier `airootfs/etc/locale.gen` pour le français.
   - Ajouter un utilisateur par défaut avec les droits nécessaires.

3. **Scripts de personnalisation**
   - Créer des scripts pour automatiser l'installation des assets et du thème.
   - Configurer les permissions pour les fichiers de sons et d'images.
   - Ajouter un script pour installer Mistral Vibe : `curl -LsSf https://mistral.ai/vibe/install.sh | bash`.

## Fichiers à Modifier
- `packages.x86_64`
- `airootfs/etc/hostname`
- `airootfs/etc/locale.gen`
- Scripts d'installation personnalisés.
- Script d'installation de Mistral Vibe.
