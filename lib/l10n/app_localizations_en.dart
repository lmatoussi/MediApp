// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Stroke Recovery';

  @override
  String get appSubtitle => 'Patient Recovery Assistant';

  @override
  String get welcome => 'Welcome';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get email => 'Email';

  @override
  String get patientId => 'Patient ID';

  @override
  String get patientName => 'Patient Name';

  @override
  String get age => 'Age';

  @override
  String get gender => 'Gender';

  @override
  String get male => 'Male';

  @override
  String get female => 'Female';

  @override
  String get other => 'Other';

  @override
  String get date => 'Date';

  @override
  String get time => 'Time';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get back => 'Back';

  @override
  String get next => 'Next';

  @override
  String get previous => 'Previous';

  @override
  String get home => 'Home';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get profile => 'Profile';

  @override
  String get assessment => 'Assessment';

  @override
  String get exercises => 'Exercises';

  @override
  String get progress => 'Progress';

  @override
  String get results => 'Results';

  @override
  String get feedback => 'Feedback';

  @override
  String get submit => 'Submit';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get view => 'View';

  @override
  String get download => 'Download';

  @override
  String get share => 'Share';

  @override
  String get print => 'Print';

  @override
  String get more => 'More';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get warning => 'Warning';

  @override
  String get info => 'Information';

  @override
  String get noData => 'No data available';

  @override
  String get tryAgain => 'Try Again';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get deleted => 'Deleted successfully';

  @override
  String get saved => 'Saved successfully';

  @override
  String get updated => 'Updated successfully';

  @override
  String get created => 'Created successfully';

  @override
  String get failed => 'Failed';

  @override
  String get loading_please_wait => 'Loading, please wait...';

  @override
  String get connection_error => 'Connection error';

  @override
  String get invalid_input => 'Invalid input';

  @override
  String get required_field => 'This field is required';

  @override
  String get password_mismatch => 'Passwords do not match';

  @override
  String get invalid_email => 'Invalid email address';

  @override
  String get weak_password => 'Password is too weak';

  @override
  String get user_not_found => 'User not found';

  @override
  String get user_already_exists => 'User already exists';

  @override
  String get session_expired => 'Session expired';

  @override
  String get unauthorized => 'Unauthorized access';

  @override
  String get server_error => 'Server error';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get please_check_connection => 'Please check your connection';

  @override
  String get empty_field => 'This field cannot be empty';

  @override
  String get confirm_action => 'Confirm this action';

  @override
  String get are_you_sure_delete => 'Are you sure you want to delete this?';

  @override
  String get deleted_successfully => 'Deleted successfully';

  @override
  String get updated_successfully => 'Updated successfully';

  @override
  String get saved_successfully => 'Saved successfully';

  @override
  String get thank_you => 'Thank you';

  @override
  String get welcome_back => 'Welcome back';

  @override
  String get goodbye => 'Goodbye';

  @override
  String get see_you_soon => 'See you soon';

  @override
  String get assessmentQuestions => 'Assessment Questions';

  @override
  String get startAssessment => 'Start Assessment';

  @override
  String get completeAssessment => 'Complete Assessment';

  @override
  String get assessmentScore => 'Assessment Score';

  @override
  String get totalScore => 'Total Score';

  @override
  String get percentage => 'Percentage';

  @override
  String get scoreBreakdown => 'Score Breakdown';

  @override
  String questionNumber(int number) {
    return 'Question $number';
  }

  @override
  String exerciseTitle(String name) {
    return 'Exercise $name';
  }

  @override
  String get exerciseDescription => 'Description';

  @override
  String get exerciseDuration => 'Duration';

  @override
  String get exerciseReps => 'Repetitions';

  @override
  String get exerciseSets => 'Sets';

  @override
  String get exerciseLevel => 'Level';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get startExercise => 'Start Exercise';

  @override
  String get completeExercise => 'Complete Exercise';

  @override
  String get pauseExercise => 'Pause Exercise';

  @override
  String get resumeExercise => 'Resume Exercise';

  @override
  String get exerciseCompleted => 'Exercise Completed';

  @override
  String get exerciseProgress => 'Exercise Progress';

  @override
  String get progressChart => 'Progress Chart';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String get monthlyProgress => 'Monthly Progress';

  @override
  String get yearlyProgress => 'Yearly Progress';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get totalExercises => 'Total Exercises';

  @override
  String get completedExercises => 'Completed Exercises';

  @override
  String get remainingExercises => 'Remaining Exercises';

  @override
  String get exerciseStats => 'Exercise Statistics';

  @override
  String get medicationReminder => 'Medication Reminder';

  @override
  String get appointmentReminder => 'Appointment Reminder';

  @override
  String get appointmentSchedule => 'Appointment Schedule';

  @override
  String get upcomingAppointments => 'Upcoming Appointments';

  @override
  String get pastAppointments => 'Past Appointments';

  @override
  String get appointmentDate => 'Date';

  @override
  String get appointmentTime => 'Time';

  @override
  String get appointmentLocation => 'Location';

  @override
  String get appointmentDoctor => 'Doctor';

  @override
  String get appointmentNotes => 'Notes';

  @override
  String get bookAppointment => 'Book Appointment';

  @override
  String get cancelAppointment => 'Cancel Appointment';

  @override
  String get rescheduleAppointment => 'Reschedule Appointment';

  @override
  String get appointmentConfirmed => 'Appointment Confirmed';

  @override
  String get appointmentCancelled => 'Appointment Cancelled';

  @override
  String get appointmentRescheduled => 'Appointment Rescheduled';

  @override
  String get doctorName => 'Doctor Name';

  @override
  String get specialization => 'Specialization';

  @override
  String get contactDoctor => 'Contact Doctor';

  @override
  String get callDoctor => 'Call Doctor';

  @override
  String get messageDoctor => 'Message Doctor';

  @override
  String get emailDoctor => 'Email Doctor';

  @override
  String get patientHistory => 'Patient History';

  @override
  String get medicalHistory => 'Medical History';

  @override
  String get medications => 'Medications';

  @override
  String get allergies => 'Allergies';

  @override
  String get surgeries => 'Surgeries';

  @override
  String get familyHistory => 'Family History';

  @override
  String get lifestyleHabits => 'Lifestyle Habits';

  @override
  String get smoker => 'Smoker';

  @override
  String get drinker => 'Drinker';

  @override
  String get exerciseFrequency => 'Exercise Frequency';

  @override
  String get diet => 'Diet';

  @override
  String get sleepPattern => 'Sleep Pattern';

  @override
  String get stressLevel => 'Stress Level';

  @override
  String get bloodPressure => 'Blood Pressure';

  @override
  String get cholesterol => 'Cholesterol';

  @override
  String get bloodSugar => 'Blood Sugar';

  @override
  String get heartRate => 'Heart Rate';

  @override
  String get weight => 'Weight';

  @override
  String get height => 'Height';

  @override
  String get bmi => 'BMI';

  @override
  String get vitalSigns => 'Vital Signs';

  @override
  String get recentVitals => 'Recent Vitals';

  @override
  String get vitalsHistory => 'Vitals History';

  @override
  String get addVitals => 'Add Vitals';

  @override
  String get editVitals => 'Edit Vitals';

  @override
  String get deleteVitals => 'Delete Vitals';

  @override
  String get vitalsUpdated => 'Vitals Updated';

  @override
  String get normal => 'Normal';

  @override
  String get abnormal => 'Abnormal';

  @override
  String get critical => 'Critical';

  @override
  String get warning_message => 'Warning: Your vitals are abnormal';

  @override
  String get contact_doctor_message => 'Please contact your doctor immediately';

  @override
  String get recovery_tips => 'Recovery Tips';

  @override
  String get daily_tips => 'Daily Tips';

  @override
  String get weekly_tips => 'Weekly Tips';

  @override
  String get tip_of_the_day => 'Tip of the Day';

  @override
  String get recovery_milestone => 'Recovery Milestone';

  @override
  String get achieved_milestone => 'You achieved a new milestone!';

  @override
  String get share_achievement => 'Share Achievement';

  @override
  String get badges => 'Badges';

  @override
  String get achievements => 'Achievements';

  @override
  String get notifications => 'Notifications';

  @override
  String get enable_notifications => 'Enable Notifications';

  @override
  String get notification_settings => 'Notification Settings';

  @override
  String get sound => 'Sound';

  @override
  String get vibration => 'Vibration';

  @override
  String get push_notifications => 'Push Notifications';

  @override
  String get email_notifications => 'Email Notifications';

  @override
  String get sms_notifications => 'SMS Notifications';

  @override
  String get reminder_frequency => 'Reminder Frequency';

  @override
  String get daily => 'Daily';

  @override
  String get weekly => 'Weekly';

  @override
  String get monthly => 'Monthly';

  @override
  String get theme => 'Theme';

  @override
  String get dark_mode => 'Dark Mode';

  @override
  String get light_mode => 'Light Mode';

  @override
  String get font_size => 'Font Size';

  @override
  String get small => 'Small';

  @override
  String get medium => 'Medium';

  @override
  String get large => 'Large';

  @override
  String get extra_large => 'Extra Large';

  @override
  String get accessibility => 'Accessibility';

  @override
  String get text_to_speech => 'Text to Speech';

  @override
  String get screen_reader => 'Screen Reader';

  @override
  String get high_contrast => 'High Contrast';

  @override
  String get privacy_policy => 'Privacy Policy';

  @override
  String get terms_of_service => 'Terms of Service';

  @override
  String get contact_us => 'Contact Us';

  @override
  String get version => 'Version';

  @override
  String get build_number => 'Build Number';

  @override
  String get last_sync => 'Last Sync';

  @override
  String get account_settings => 'Account Settings';

  @override
  String get change_password => 'Change Password';

  @override
  String get change_email => 'Change Email';

  @override
  String get two_factor_authentication => 'Two Factor Authentication';

  @override
  String get enable_2fa => 'Enable 2FA';

  @override
  String get disable_2fa => 'Disable 2FA';

  @override
  String get backup_codes => 'Backup Codes';

  @override
  String get export_data => 'Export Data';

  @override
  String get import_data => 'Import Data';

  @override
  String get delete_account => 'Delete Account';

  @override
  String get confirm_delete_account => 'Are you sure you want to delete your account? This action cannot be undone.';

  @override
  String get account_deleted => 'Account Deleted Successfully';

  @override
  String get export_successful => 'Export Successful';

  @override
  String get import_successful => 'Import Successful';

  @override
  String get sync_in_progress => 'Sync in Progress';

  @override
  String get sync_complete => 'Sync Complete';

  @override
  String get sync_failed => 'Sync Failed';

  @override
  String get retry_sync => 'Retry Sync';

  @override
  String get offline_mode => 'Offline Mode';

  @override
  String get online_mode => 'Online Mode';

  @override
  String get synchronize => 'Synchronize';

  @override
  String get clear_cache => 'Clear Cache';

  @override
  String get cache_cleared => 'Cache Cleared';

  @override
  String get storage_info => 'Storage Information';

  @override
  String get storage_used => 'Storage Used';

  @override
  String get storage_available => 'Storage Available';

  @override
  String get consent => 'I agree to the terms and conditions';

  @override
  String get medical_disclaimer => 'Medical Disclaimer';

  @override
  String get emergency_contact => 'Emergency Contact';

  @override
  String get emergency_number => 'Emergency Number';

  @override
  String get call_emergency => 'Call Emergency';

  @override
  String get sos => 'SOS';
}
