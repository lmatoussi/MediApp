// lib/core/constants/app_strings.dart

/// All app strings in French (Partie française)
class AppStrings {
  AppStrings._(); // Private constructor

  // App
  static const String appTitle = 'MediLevel';
  static const String appSubtitle = 'Évaluation de mobilité post-AVC';

  // General
  static const String next = 'Suivant';
  static const String back = 'Retour';
  static const String submit = 'Valider';
  static const String cancel = 'Annuler';
  static const String loading = 'Chargement...';
  static const String error = 'Erreur';
  static const String success = 'Succès';

  // Login Screen
  static const String loginTitle = 'Connexion';
  static const String email = 'Email';
  static const String password = 'Mot de passe';
  static const String emailHint = 'Entrez votre email';
  static const String passwordHint = 'Entrez votre mot de passe';
  static const String login = 'Se connecter';
  static const String emailInvalid = 'Email invalide';
  static const String passwordTooShort = 'Le mot de passe doit contenir au moins 6 caractères';

  // Patient Identification Screen
  static const String patientIdTitle = 'Identification du patient';
  static const String patientName = 'Nom / Prénom';
  static const String patientNameHint = 'Ex: Jean Dupont';
  static const String sex = 'Sexe';
  static const String sexMale = 'Homme';
  static const String sexFemale = 'Femme';
  static const String age = 'Âge';
  static const String ageHint = 'Ex: 65';
  static const String avcDate = "Date d'AVC";
  static const String avcDateHint = 'JJ/MM/YYYY';
  static const String nameRequired = 'Le nom est requis';
  static const String ageRequired = 'L\'âge est requis';
  static const String ageInvalid = 'L\'âge doit être un nombre valide';
  static const String avcDateRequired = 'La date d\'AVC est requise';
  static const String avcDateInvalid = 'Format invalide. Utilisez JJ/MM/YYYY';

  // Assessment Screen
  static const String assessmentTitle = 'État fonctionnel du patient';

  // Mobilité Section
  static const String mobilitySection = 'Mobilité';
  static const String canStand = 'Pouvez-vous vous mettre en position debout';
  static const String canWalk = 'Pouvez-vous marcher';
  static const String withoutAid = 'Sans aide';
  static const String withAid = 'Avec aide';
  static const String impossible = 'Impossible';

  // Équilibre Section
  static const String balanceSection = 'Équilibre';
  static const String hasDizziness = 'Ressentez-vous des vertiges aujourd\'hui';
  static const String balanceLevel = 'Comment évaluez-vous votre équilibre aujourd\'hui';
  static const String stable = 'Stable';
  static const String moderate = 'Moyen';
  static const String unstable = 'Instable';
  static const String yes = 'Oui';
  static const String no = 'Non';

  // État Général Section
  static const String generalStateSection = 'État général';
  static const String hasFatigue = 'Présentez-vous de la fatigue aujourd\'hui';
  static const String painPresent = 'Présentez-vous des douleurs aujourd\'hui';
  static const String painScore = 'Quelle est l\'intensité de la douleur (0 à 10)';
  static const String noPain = 'Pas de douleur';

  // Result Screen
  static const String resultTitle = 'Résultat';
  static const String levelLabel = 'Niveau';
  static const String level1 = 'Niveau 1';
  static const String level2 = 'Niveau 2';
  static const String level3 = 'Niveau 3';
  static const String statusCritical = 'CRITIQUE';
  static const String statusModerate = 'MODÉRÉ';
  static const String statusGood = 'BON';

  // Level Descriptions (French medical context)
  static const String level1Description =
      'Risque élevé de chute. Patient à haut risque. Recommandé: supervision constante et aide à la mobilité.';
  static const String level2Description =
      'Risque modéré. Patient nécessite une aide ou a des limitations fonctionnelles. Recommandé: supervision et aide disponible.';
  static const String level3Description =
      'Bon fonctionnel. Patient indépendant dans ses déplacements. Recommandé: suivi régulier.';

  // Assessment Summary
  static const String assessmentSummary = 'Résumé de l\'évaluation';
  static const String backToHome = 'Retour à l\'accueil';
  static const String newAssessment = 'Nouvelle évaluation';
}
