# Wariyo 🌍

Application communautaire de partage de bons et mauvais plans sur les prix.

## Configuration Firebase
- Project ID: wariyo-billops-b5e13
- Package Android: com.wariyo.app

## Structure du projet
```
lib/
  main.dart              - Point d'entrée
  firebase_options.dart  - Config Firebase
  models/
    plan.dart            - Modèle Plan
  services/
    auth_service.dart    - Authentification SMS
    plan_service.dart    - Gestion des plans
  screens/
    login_screen.dart    - Connexion par téléphone
    verify_code_screen.dart - Vérification SMS
    username_screen.dart - Choix du pseudo
    home_screen.dart     - Navigation principale
    decouvrir_screen.dart - Fil d'actualité
    publier_screen.dart  - Publier un plan
    profil_screen.dart   - Profil utilisateur
```

## Fonctionnalités
- ✅ Login par SMS (Firebase Phone Auth)
- ✅ Publier BON PLAN / MAUVAIS PLAN
- ✅ Fil d'actualité avec filtres et tri
- ✅ Votes 👍👎 avec points (+10 par upvote)
- ✅ Masquage automatique à -5
- ✅ Profil utilisateur
- ✅ Multi-pays et multi-devises

## Pour compiler
1. Uploader ce code sur GitHub
2. Connecter à Codemagic (codemagic.io)
3. Générer l'APK Android
