# Makefile pour Tester avec QEMU

## Objectif
Créer un Makefile pour automatiser les tests de la distribution MacronLinux avec QEMU. Cela permettra de tester rapidement l'installation et la configuration sans avoir besoin de matériel physique.

## Étapes
1. **Installation de QEMU**
   - S'assurer que QEMU est installé sur la machine hôte.
   - Installer les dépendances nécessaires pour QEMU.

2. **Création du Makefile**
   - Créer un fichier `Makefile` à la racine du projet.
   - Définir des cibles pour :
     - `build` : Construire l'image ISO.
     - `test` : Lancer l'image ISO dans QEMU.
     - `clean` : Nettoyer les fichiers temporaires.

3. **Configuration de QEMU**
   - Configurer QEMU pour utiliser l'image ISO générée.
   - Allouer suffisamment de mémoire et de CPU pour une expérience fluide.
   - Activer l'accélération KVM pour de meilleures performances.

4. **Automatisation des Tests**
   - Ajouter des scripts pour automatiser les tests d'installation.
   - Vérifier que les assets et le thème sont correctement intégrés.

## Exemple de Makefile
```makefile
# Makefile pour MacronLinux

ISO_NAME = macronlinux.iso
QEMU_OPTS = -m 4G -smp 4 -enable-kvm

build:
	./build-iso.sh

test:
	qemu-system-x86_64 $(QEMU_OPTS) -cdrom $(ISO_NAME)

clean:
	rm -f $(ISO_NAME)
```

## Utilisation
- Pour construire l'image ISO : `make build`
- Pour tester avec QEMU : `make test`
- Pour nettoyer : `make clean`

## Fichiers à Créer
- `Makefile` à la racine du projet.
- Scripts d'automatisation pour les tests (`build-iso.sh`).
