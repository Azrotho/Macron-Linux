# Personnalisation de KDE

## Objectif
Créer un thème France personnalisé pour KDE et intégrer les assets fournis (fond d'écran, sons). Les sons sont utilisés pour les notifications, le démarrage, et les erreurs.

## Étapes
1. **Création du thème France**
   - Créer un dossier pour le thème dans `~/.config/kdeglobals`.
   - Définir les couleurs du thème (bleu, blanc, rouge pour représenter le drapeau français).
   - Configurer les polices et les icônes pour un style élégant.

2. **Intégration des assets**
   - **Fond d'écran** : Copier `Emmanuel_Macron_dark.jpg` dans `/usr/share/wallpapers/` et le configurer comme fond d'écran par défaut.
   - **Sons** :
     - `boot_sound.mp3` : Son de démarrage du système.
     - `error_sound.mp3` : Son pour les erreurs système.
     - `hey-hey-hey-macron.mp3` : Son pour les notifications.
   - Copier les sons dans `/usr/share/sounds/` et les configurer dans les paramètres système.

3. **Configuration de SDDM**
   - Personnaliser l'écran de connexion avec le thème France.
   - Ajouter le fond d'écran et les couleurs du drapeau français.

4. **Contributions Communautaires**
   - Documenter comment ajouter de nouveaux fonds d'écran et sons.
   - Encourager les contributions via des pull requests.

## Fichiers à Modifier
- `~/.config/kdeglobals`
- `/usr/share/wallpapers/`
- `/usr/share/sounds/`
- Configuration de SDDM.
- Documentation pour les contributions.
