#!/bin/bash
# 🧪 TESTS COMPLETS - GUIDE D'EXÉCUTION

echo "=========================================="
echo "🧪 TESTS DE L'APPLICATION MÉDICALE"
echo "=========================================="
echo ""

# ✅ TEST 1: Vérifier les dépendances
echo "TEST 1: Vérifier les dépendances..."
flutter pub get
if [ $? -eq 0 ]; then
  echo "✅ Dépendances OK"
else
  echo "❌ Erreur dépendances"
  exit 1
fi
echo ""

# ✅ TEST 2: Vérifier la syntaxe Dart
echo "TEST 2: Analyser le code..."
flutter analyze
if [ $? -eq 0 ]; then
  echo "✅ Syntaxe OK"
else
  echo "⚠️ Avertissements trouvés (peut être OK)"
fi
echo ""

# ✅ TEST 3: Formater le code
echo "TEST 3: Formater le code..."
dart format lib/ --set-exit-if-changed || true
echo "✅ Formatage terminé"
echo ""

# ✅ TEST 4: Lancer l'app en mode debug
echo "TEST 4: Lancer l'application..."
echo "📱 Assurez-vous qu'un émulateur/appareil est connecté"
echo ""
echo "Options:"
echo "1. flutter run"
echo "2. flutter run -v (verbose)"
echo "3. flutter run --release (production)"
echo ""
echo "Exemple:"
echo "  flutter run"
echo ""

# ✅ TEST MANUEL: Vérifier les fonctionnalités
echo "=========================================="
echo "🧪 TESTS MANUELS À EFFECTUER"
echo "=========================================="
echo ""

cat << 'EOF'
✅ TEST DE CONNEXION PATIENT:
  1. Lancer l'app: flutter run
  2. Écran de connexion s'affiche
  3. Mode "Patient" sélectionné
  4. Email: patient1@medical.app
  5. Password: Patient@123
  6. Clic "Se connecter"
  7. ✓ Écran "Mon Espace Patient" s'affiche

✅ TEST DE CONNEXION ADMIN:
  1. Lancer l'app: flutter run
  2. Écran de connexion s'affiche
  3. Mode "Admin" sélectionné
  4. Email: admin@medical.app
  5. Password: Admin@2024
  6. Clic "Se connecter"
  7. ✓ Tableau de bord admin s'affiche

✅ TEST D'INSCRIPTION PATIENT:
  1. Écran de connexion
  2. Mode "Patient" sélectionné
  3. Clic "S'inscrire"
  4. Remplir formulaire (email unique)
  5. Confirmer mot de passe
  6. Clic "S'inscrire"
  7. ✓ Nouveau compte créé et connexion auto

✅ TEST GESTION PATIENTS (Admin):
  1. Connecté en tant qu'admin
  2. Clic "Gestion Patients"
  3. ✓ Liste de tous les patients
  4. Clic sur patient
  5. ✓ Voir détails patient
  6. Clic "Ajouter exercice"
  7. ✓ Exercice assigné avec succès

✅ TEST ASSIGNATION EXERCICE:
  1. Dans détails patient (Admin)
  2. Clic bouton "Ajouter exercice"
  3. Remplir: nom, description, durée
  4. Clic "Ajouter"
  5. ✓ Exercice aparaît dans liste

✅ TEST COMPLETION EXERCICE (Patient):
  1. Patient connecté
  2. Voir exercice dans "À faire"
  3. Clic bouton ✓ (check)
  4. ✓ Exercice passe dans "Complétés"
  5. ✓ Checkbox cochée

✅ TEST PERSISTENCE DONNÉES:
  1. Assigner exercice au patient
  2. Fermer complètement l'app
  3. Relancer l'app
  4. Patient se reconnecte
  5. ✓ Exercice toujours présent

✅ TEST DÉCONNEXION:
  1. Connecté (patient ou admin)
  2. Clic icône logout (coin haut droit)
  3. ✓ Retour à écran connexion

✅ TEST ERREURS:
  1. Email: patient1@medical.app
  2. Password: WrongPassword
  3. ✓ Message d'erreur s'affiche
  4. "Email ou mot de passe incorrect"

✅ TEST MULTIPLATEFORME:
  - Flutter run (Android/iOS par défaut)
  - flutter run -d chrome (Web)
  - flutter run -d windows (Windows)

EOF

echo ""
echo "=========================================="
echo "✅ GUIDE DE TEST COMPLET"
echo "=========================================="
echo ""

cat << 'EOF'
📋 CHECKLIST DE VALIDATION:

Database:
  [ ] Fichier database_helper.dart créé
  [ ] Tables SQLite créées automatiquement
  [ ] 3 patients pré-créés
  [ ] Admin pré-créé
  [ ] Données persévèrent après redémarrage

Authentication:
  [ ] Connexion patient fonctionne
  [ ] Connexion admin fonctionne
  [ ] Inscription patient fonctionne
  [ ] Mots de passe hashés
  [ ] Sessions sauvegardées
  [ ] Déconnexion fonctionne

UI/UX:
  [ ] Écran connexion s'affiche
  [ ] Écran inscription s'affiche
  [ ] Dashboard patient s'affiche
  [ ] Dashboard admin s'affiche
  [ ] Gestion patients s'affiche
  [ ] Tous les boutons fonctionnent

Features:
  [ ] Assignation exercices fonctionne
  [ ] Completion exercices fonctionne
  [ ] Vue détails patient fonctionne
  [ ] Ajout exercice fonctionne
  [ ] Refresh données fonctionne

Sécurité:
  [ ] Seul admin a accès panel admin
  [ ] Patients voient leurs données uniquement
  [ ] Email ne peut pas être dupliqué
  [ ] Mot de passe validé
  [ ] Session expire à déconnexion

Performance:
  [ ] App lance en < 3s
  [ ] Écrans se chargent fluide
  [ ] Pas de lag lors scroll
  [ ] Pas de crash observé

EOF

echo ""
echo "=========================================="
echo "🚀 DÉMARRAGE RAPIDE"
echo "=========================================="
echo ""

cat << 'EOF'
# 1. Installer dépendances
flutter pub get

# 2. Nettoyer build précédent
flutter clean

# 3. Lancer l'app
flutter run

# 4. Tester connexion
   Email: admin@medical.app
   Password: Admin@2024

EOF

echo ""
echo "=========================================="
echo "📊 COMMANDES UTILES"
echo "=========================================="
echo ""

cat << 'EOF'
# Analyser le code
flutter analyze

# Formater le code
dart format lib/

# Lancer avec logs détaillés
flutter run -v

# Mode release (optimisé)
flutter run --release

# Générer build APK (Android)
flutter build apk --release

# Générer build iOS
flutter build ios --release

# Tests unitaires
flutter test test/

# DevTools (débogage)
flutter pub global activate devtools
devtools

EOF

echo ""
echo "✅ Configuration terminée!"
echo ""
