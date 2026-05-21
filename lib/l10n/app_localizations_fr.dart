// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Récupération d\'AVC';

  @override
  String get appSubtitle => 'Assistant de Récupération du Patient';

  @override
  String get welcome => 'Bienvenue';

  @override
  String get login => 'Connexion';

  @override
  String get logout => 'Déconnexion';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get email => 'E-mail';

  @override
  String get patientId => 'ID Patient';

  @override
  String get patientName => 'Nom du Patient';

  @override
  String get age => 'Âge';

  @override
  String get gender => 'Sexe';

  @override
  String get male => 'Masculin';

  @override
  String get female => 'Féminin';

  @override
  String get other => 'Autre';

  @override
  String get date => 'Date';

  @override
  String get time => 'Heure';

  @override
  String get selectLanguage => 'Sélectionner la Langue';

  @override
  String get language => 'Langue';

  @override
  String get settings => 'Paramètres';

  @override
  String get help => 'Aide';

  @override
  String get about => 'À propos';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get home => 'Accueil';

  @override
  String get dashboard => 'Tableau de Bord';

  @override
  String get profile => 'Profil';

  @override
  String get assessment => 'Évaluation';

  @override
  String get exercises => 'Exercices';

  @override
  String get progress => 'Progrès';

  @override
  String get results => 'Résultats';

  @override
  String get feedback => 'Retour d\'Information';

  @override
  String get submit => 'Soumettre';

  @override
  String get search => 'Rechercher';

  @override
  String get filter => 'Filtrer';

  @override
  String get sort => 'Trier';

  @override
  String get view => 'Voir';

  @override
  String get download => 'Télécharger';

  @override
  String get share => 'Partager';

  @override
  String get print => 'Imprimer';

  @override
  String get more => 'Plus';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get success => 'Succès';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Information';

  @override
  String get noData => 'Aucune donnée disponible';

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get areYouSure => 'Êtes-vous sûr?';

  @override
  String get deleted => 'Supprimé avec succès';

  @override
  String get saved => 'Enregistré avec succès';

  @override
  String get updated => 'Mis à jour avec succès';

  @override
  String get created => 'Créé avec succès';

  @override
  String get failed => 'Échoué';

  @override
  String get loading_please_wait => 'Chargement, veuillez patienter...';

  @override
  String get connection_error => 'Erreur de connexion';

  @override
  String get invalid_input => 'Entrée invalide';

  @override
  String get required_field => 'Ce champ est obligatoire';

  @override
  String get password_mismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get invalid_email => 'Adresse e-mail invalide';

  @override
  String get weak_password => 'Le mot de passe est trop faible';

  @override
  String get user_not_found => 'Utilisateur non trouvé';

  @override
  String get user_already_exists => 'L\'utilisateur existe déjà';

  @override
  String get session_expired => 'Session expirée';

  @override
  String get unauthorized => 'Accès non autorisé';

  @override
  String get server_error => 'Erreur serveur';

  @override
  String get something_went_wrong => 'Quelque chose s\'est mal passé';

  @override
  String get please_check_connection => 'Veuillez vérifier votre connexion';

  @override
  String get empty_field => 'Ce champ ne peut pas être vide';

  @override
  String get confirm_action => 'Confirmer cette action';

  @override
  String get are_you_sure_delete => 'Êtes-vous sûr de vouloir supprimer ceci?';

  @override
  String get deleted_successfully => 'Supprimé avec succès';

  @override
  String get updated_successfully => 'Mis à jour avec succès';

  @override
  String get saved_successfully => 'Enregistré avec succès';

  @override
  String get thank_you => 'Merci';

  @override
  String get welcome_back => 'Bienvenue';

  @override
  String get goodbye => 'Au revoir';

  @override
  String get see_you_soon => 'À bientôt';

  @override
  String get assessmentQuestions => 'Questions d\'Évaluation';

  @override
  String get startAssessment => 'Commencer l\'Évaluation';

  @override
  String get completeAssessment => 'Terminer l\'Évaluation';

  @override
  String get assessmentScore => 'Score d\'Évaluation';

  @override
  String get totalScore => 'Score Total';

  @override
  String get percentage => 'Pourcentage';

  @override
  String get scoreBreakdown => 'Répartition des Points';

  @override
  String questionNumber(int number) {
    return 'Question $number';
  }

  @override
  String exerciseTitle(String name) {
    return 'Exercice $name';
  }

  @override
  String get exerciseDescription => 'Description';

  @override
  String get exerciseDuration => 'Durée';

  @override
  String get exerciseReps => 'Répétitions';

  @override
  String get exerciseSets => 'Séries';

  @override
  String get exerciseLevel => 'Niveau';

  @override
  String get beginner => 'Débutant';

  @override
  String get intermediate => 'Intermédiaire';

  @override
  String get advanced => 'Avancé';

  @override
  String get startExercise => 'Commencer l\'Exercice';

  @override
  String get completeExercise => 'Terminer l\'Exercice';

  @override
  String get pauseExercise => 'Pause';

  @override
  String get resumeExercise => 'Reprendre';

  @override
  String get exerciseCompleted => 'Exercice Terminé';

  @override
  String get exerciseProgress => 'Progrès de l\'Exercice';

  @override
  String get progressChart => 'Graphique de Progrès';

  @override
  String get weeklyProgress => 'Progrès Hebdomadaires';

  @override
  String get monthlyProgress => 'Progrès Mensuels';

  @override
  String get yearlyProgress => 'Progrès Annuels';

  @override
  String get lastUpdated => 'Dernière Mise à Jour';

  @override
  String get totalExercises => 'Total Exercices';

  @override
  String get completedExercises => 'Exercices Complétés';

  @override
  String get remainingExercises => 'Exercices Restants';

  @override
  String get exerciseStats => 'Statistiques d\'Exercices';

  @override
  String get medicationReminder => 'Rappel de Médicament';

  @override
  String get appointmentReminder => 'Rappel de Rendez-vous';

  @override
  String get appointmentSchedule => 'Calendrier des Rendez-vous';

  @override
  String get upcomingAppointments => 'Rendez-vous à Venir';

  @override
  String get pastAppointments => 'Rendez-vous Passés';

  @override
  String get appointmentDate => 'Date';

  @override
  String get appointmentTime => 'Heure';

  @override
  String get appointmentLocation => 'Lieu';

  @override
  String get appointmentDoctor => 'Médecin';

  @override
  String get appointmentNotes => 'Notes';

  @override
  String get bookAppointment => 'Réserver un Rendez-vous';

  @override
  String get cancelAppointment => 'Annuler le Rendez-vous';

  @override
  String get rescheduleAppointment => 'Reporter le Rendez-vous';

  @override
  String get appointmentConfirmed => 'Rendez-vous Confirmé';

  @override
  String get appointmentCancelled => 'Rendez-vous Annulé';

  @override
  String get appointmentRescheduled => 'Rendez-vous Reporté';

  @override
  String get doctorName => 'Nom du Médecin';

  @override
  String get specialization => 'Spécialité';

  @override
  String get contactDoctor => 'Contacter le Médecin';

  @override
  String get callDoctor => 'Appeler le Médecin';

  @override
  String get messageDoctor => 'Message au Médecin';

  @override
  String get emailDoctor => 'Email au Médecin';

  @override
  String get patientHistory => 'Historique du Patient';

  @override
  String get medicalHistory => 'Historique Médical';

  @override
  String get medications => 'Médicaments';

  @override
  String get allergies => 'Allergies';

  @override
  String get surgeries => 'Chirurgies';

  @override
  String get familyHistory => 'Antécédents Familiaux';

  @override
  String get lifestyleHabits => 'Habitudes de Vie';

  @override
  String get smoker => 'Fumeur';

  @override
  String get drinker => 'Buveur';

  @override
  String get exerciseFrequency => 'Fréquence d\'Exercice';

  @override
  String get diet => 'Régime Alimentaire';

  @override
  String get sleepPattern => 'Motif de Sommeil';

  @override
  String get stressLevel => 'Niveau de Stress';

  @override
  String get bloodPressure => 'Pression Artérielle';

  @override
  String get cholesterol => 'Cholestérol';

  @override
  String get bloodSugar => 'Sucre dans le Sang';

  @override
  String get heartRate => 'Fréquence Cardiaque';

  @override
  String get weight => 'Poids';

  @override
  String get height => 'Hauteur';

  @override
  String get bmi => 'IMC';

  @override
  String get vitalSigns => 'Signes Vitaux';

  @override
  String get recentVitals => 'Signes Vitaux Récents';

  @override
  String get vitalsHistory => 'Historique des Signes Vitaux';

  @override
  String get addVitals => 'Ajouter des Signes Vitaux';

  @override
  String get editVitals => 'Modifier les Signes Vitaux';

  @override
  String get deleteVitals => 'Supprimer les Signes Vitaux';

  @override
  String get vitalsUpdated => 'Signes Vitaux Mis à Jour';

  @override
  String get normal => 'Normal';

  @override
  String get abnormal => 'Anormal';

  @override
  String get critical => 'Critique';

  @override
  String get warning_message => 'Avertissement: Vos signes vitaux sont anormaux';

  @override
  String get contact_doctor_message => 'Veuillez contacter votre médecin immédiatement';

  @override
  String get recovery_tips => 'Conseils de Récupération';

  @override
  String get daily_tips => 'Conseils Quotidiens';

  @override
  String get weekly_tips => 'Conseils Hebdomadaires';

  @override
  String get tip_of_the_day => 'Conseil du Jour';

  @override
  String get recovery_milestone => 'Étape de Récupération';

  @override
  String get achieved_milestone => 'Vous avez atteint une nouvelle étape!';

  @override
  String get share_achievement => 'Partager la Réussite';

  @override
  String get badges => 'Badges';

  @override
  String get achievements => 'Réalisations';

  @override
  String get notifications => 'Notifications';

  @override
  String get enable_notifications => 'Activer les Notifications';

  @override
  String get notification_settings => 'Paramètres de Notification';

  @override
  String get sound => 'Son';

  @override
  String get vibration => 'Vibration';

  @override
  String get push_notifications => 'Notifications Push';

  @override
  String get email_notifications => 'Notifications par E-mail';

  @override
  String get sms_notifications => 'Notifications SMS';

  @override
  String get reminder_frequency => 'Fréquence de Rappel';

  @override
  String get daily => 'Quotidien';

  @override
  String get weekly => 'Hebdomadaire';

  @override
  String get monthly => 'Mensuel';

  @override
  String get theme => 'Thème';

  @override
  String get dark_mode => 'Mode Sombre';

  @override
  String get light_mode => 'Mode Clair';

  @override
  String get font_size => 'Taille de Police';

  @override
  String get small => 'Petit';

  @override
  String get medium => 'Moyen';

  @override
  String get large => 'Grand';

  @override
  String get extra_large => 'Très Grand';

  @override
  String get accessibility => 'Accessibilité';

  @override
  String get text_to_speech => 'Synthèse Vocale';

  @override
  String get screen_reader => 'Lecteur d\'Écran';

  @override
  String get high_contrast => 'Contraste Élevé';

  @override
  String get privacy_policy => 'Politique de Confidentialité';

  @override
  String get terms_of_service => 'Conditions d\'Utilisation';

  @override
  String get contact_us => 'Nous Contacter';

  @override
  String get version => 'Version';

  @override
  String get build_number => 'Numéro de Build';

  @override
  String get last_sync => 'Dernière Synchronisation';

  @override
  String get account_settings => 'Paramètres du Compte';

  @override
  String get change_password => 'Changer le Mot de Passe';

  @override
  String get change_email => 'Changer l\'E-mail';

  @override
  String get two_factor_authentication => 'Authentification à Deux Facteurs';

  @override
  String get enable_2fa => 'Activer 2FA';

  @override
  String get disable_2fa => 'Désactiver 2FA';

  @override
  String get backup_codes => 'Codes de Sauvegarde';

  @override
  String get export_data => 'Exporter les Données';

  @override
  String get import_data => 'Importer les Données';

  @override
  String get delete_account => 'Supprimer le Compte';

  @override
  String get confirm_delete_account => 'Êtes-vous sûr de vouloir supprimer votre compte? Cette action ne peut pas être annulée.';

  @override
  String get account_deleted => 'Compte Supprimé avec Succès';

  @override
  String get export_successful => 'Export Réussi';

  @override
  String get import_successful => 'Import Réussi';

  @override
  String get sync_in_progress => 'Synchronisation en Cours';

  @override
  String get sync_complete => 'Synchronisation Terminée';

  @override
  String get sync_failed => 'Synchronisation Échouée';

  @override
  String get retry_sync => 'Recommencer la Synchronisation';

  @override
  String get offline_mode => 'Mode Hors Ligne';

  @override
  String get online_mode => 'Mode En Ligne';

  @override
  String get synchronize => 'Synchroniser';

  @override
  String get clear_cache => 'Effacer le Cache';

  @override
  String get cache_cleared => 'Cache Effacé';

  @override
  String get storage_info => 'Informations de Stockage';

  @override
  String get storage_used => 'Stockage Utilisé';

  @override
  String get storage_available => 'Stockage Disponible';

  @override
  String get consent => 'J\'accepte les conditions d\'utilisation';

  @override
  String get medical_disclaimer => 'Clause de Non-Responsabilité Médicale';

  @override
  String get emergency_contact => 'Contact d\'Urgence';

  @override
  String get emergency_number => 'Numéro d\'Urgence';

  @override
  String get call_emergency => 'Appeler l\'Urgence';

  @override
  String get sos => 'SOS';
}
