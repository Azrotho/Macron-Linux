# Versions de l'ISO

## Objectif
Créer deux versions de l'ISO pour MacronLinux : une version standard sans pilotes NVIDIA et une version avec les pilotes NVIDIA pour les utilisateurs avec des cartes graphiques NVIDIA.

## Étapes
1. **Version Standard**
   - Créer une image ISO sans les pilotes NVIDIA.
   - Inclure les paquets de base pour KDE et les outils nécessaires.
   - Configurer le système pour une utilisation générale.

2. **Version avec Pilotes NVIDIA**
   - Créer une image ISO avec les pilotes NVIDIA.
   - Ajouter les paquets `nvidia` et `nvidia-utils` dans la liste des paquets.
   - Configurer le système pour charger les pilotes NVIDIA au démarrage.

3. **Configuration des Paquets**
   - Modifier le fichier `packages.x86_64` pour inclure ou exclure les pilotes NVIDIA.
   - Utiliser des variables d'environnement ou des scripts pour générer les deux versions.

4. **Tests des Deux Versions**
   - Tester la version standard avec QEMU.
   - Tester la version avec pilotes NVIDIA sur une machine avec une carte graphique NVIDIA.

## Exemple de Configuration
```bash
# Pour la version standard
packages=("plasma" "kde-applications" "sddm" "neofetch" "ffmpeg" "curl")

# Pour la version avec pilotes NVIDIA
packages_nvidia=("${packages[@]}" "nvidia" "nvidia-utils")
```

## Fichiers à Modifier
- `packages.x86_64`
- Scripts de build pour générer les deux versions.
- Documentation pour expliquer les différences entre les versions.

## Livrables
- Deux images ISO : `macronlinux-standard.iso` et `macronlinux-nvidia.iso`.
- Documentation sur les différences entre les versions.
