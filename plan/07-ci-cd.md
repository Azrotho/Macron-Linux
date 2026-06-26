# CI/CD pour GitHub

## Objectif
Configurer un workflow GitHub Actions pour automatiser la construction de l'image ISO et la génération des releases.

## Étapes
1. **Création du workflow**
   - Créer un fichier `.github/workflows/build.yml` pour définir le workflow.
   - Configurer les étapes pour builder l'image ISO à chaque push sur la branche `main`.

2. **Configuration du workflow**
   - Utiliser une machine virtuelle Ubuntu pour builder l'image ISO.
   - Installer les dépendances nécessaires (`archiso`, `mkisofs`, etc.).
   - Exécuter le script de build pour générer l'image ISO.

3. **Génération des artefacts**
   - Stocker l'image ISO générée comme artefact dans GitHub Actions.
   - Configurer le workflow pour télécharger les artefacts depuis les releases.

4. **Automatisation des releases**
   - Configurer le workflow pour créer une release à chaque tag Git.
   - Ajouter l'image ISO comme asset à la release.

## Exemple de Workflow
```yaml
name: Build ISO

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Install dependencies
      run: sudo apt-get update && sudo apt-get install -y archiso mkisofs
    - name: Build ISO
      run: ./build-iso.sh
    - name: Upload artifact
      uses: actions/upload-artifact@v2
      with:
        name: macronlinux-iso
        path: output/macronlinux.iso
```

## Fichiers à Créer
- `.github/workflows/build.yml`
- Script de build (`build-iso.sh`) pour automatiser la construction de l'image ISO.
