import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Stroke Recovery'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Patient Recovery Assistant'**
  String get appSubtitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @patientId.
  ///
  /// In en, this message translates to:
  /// **'Patient ID'**
  String get patientId;

  /// No description provided for @patientName.
  ///
  /// In en, this message translates to:
  /// **'Patient Name'**
  String get patientName;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @male.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get male;

  /// No description provided for @female.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get female;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @assessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get assessment;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get results;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sort;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get info;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noData;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @areYouSure.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleted;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saved;

  /// No description provided for @updated.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updated;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created successfully'**
  String get created;

  /// No description provided for @failed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get failed;

  /// No description provided for @loading_please_wait.
  ///
  /// In en, this message translates to:
  /// **'Loading, please wait...'**
  String get loading_please_wait;

  /// No description provided for @connection_error.
  ///
  /// In en, this message translates to:
  /// **'Connection error'**
  String get connection_error;

  /// No description provided for @invalid_input.
  ///
  /// In en, this message translates to:
  /// **'Invalid input'**
  String get invalid_input;

  /// No description provided for @required_field.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required_field;

  /// No description provided for @password_mismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get password_mismatch;

  /// No description provided for @invalid_email.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalid_email;

  /// No description provided for @weak_password.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weak_password;

  /// No description provided for @user_not_found.
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get user_not_found;

  /// No description provided for @user_already_exists.
  ///
  /// In en, this message translates to:
  /// **'User already exists'**
  String get user_already_exists;

  /// No description provided for @session_expired.
  ///
  /// In en, this message translates to:
  /// **'Session expired'**
  String get session_expired;

  /// No description provided for @unauthorized.
  ///
  /// In en, this message translates to:
  /// **'Unauthorized access'**
  String get unauthorized;

  /// No description provided for @server_error.
  ///
  /// In en, this message translates to:
  /// **'Server error'**
  String get server_error;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @please_check_connection.
  ///
  /// In en, this message translates to:
  /// **'Please check your connection'**
  String get please_check_connection;

  /// No description provided for @empty_field.
  ///
  /// In en, this message translates to:
  /// **'This field cannot be empty'**
  String get empty_field;

  /// No description provided for @confirm_action.
  ///
  /// In en, this message translates to:
  /// **'Confirm this action'**
  String get confirm_action;

  /// No description provided for @are_you_sure_delete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get are_you_sure_delete;

  /// No description provided for @deleted_successfully.
  ///
  /// In en, this message translates to:
  /// **'Deleted successfully'**
  String get deleted_successfully;

  /// No description provided for @updated_successfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updated_successfully;

  /// No description provided for @saved_successfully.
  ///
  /// In en, this message translates to:
  /// **'Saved successfully'**
  String get saved_successfully;

  /// No description provided for @thank_you.
  ///
  /// In en, this message translates to:
  /// **'Thank you'**
  String get thank_you;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcome_back;

  /// No description provided for @goodbye.
  ///
  /// In en, this message translates to:
  /// **'Goodbye'**
  String get goodbye;

  /// No description provided for @see_you_soon.
  ///
  /// In en, this message translates to:
  /// **'See you soon'**
  String get see_you_soon;

  /// No description provided for @assessmentQuestions.
  ///
  /// In en, this message translates to:
  /// **'Assessment Questions'**
  String get assessmentQuestions;

  /// No description provided for @startAssessment.
  ///
  /// In en, this message translates to:
  /// **'Start Assessment'**
  String get startAssessment;

  /// No description provided for @completeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Complete Assessment'**
  String get completeAssessment;

  /// No description provided for @assessmentScore.
  ///
  /// In en, this message translates to:
  /// **'Assessment Score'**
  String get assessmentScore;

  /// No description provided for @totalScore.
  ///
  /// In en, this message translates to:
  /// **'Total Score'**
  String get totalScore;

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @scoreBreakdown.
  ///
  /// In en, this message translates to:
  /// **'Score Breakdown'**
  String get scoreBreakdown;

  /// No description provided for @questionNumber.
  ///
  /// In en, this message translates to:
  /// **'Question {number}'**
  String questionNumber(int number);

  /// No description provided for @exerciseTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise {name}'**
  String exerciseTitle(String name);

  /// No description provided for @exerciseDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get exerciseDescription;

  /// No description provided for @exerciseDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get exerciseDuration;

  /// No description provided for @exerciseReps.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get exerciseReps;

  /// No description provided for @exerciseSets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get exerciseSets;

  /// No description provided for @exerciseLevel.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get exerciseLevel;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @startExercise.
  ///
  /// In en, this message translates to:
  /// **'Start Exercise'**
  String get startExercise;

  /// No description provided for @completeExercise.
  ///
  /// In en, this message translates to:
  /// **'Complete Exercise'**
  String get completeExercise;

  /// No description provided for @pauseExercise.
  ///
  /// In en, this message translates to:
  /// **'Pause Exercise'**
  String get pauseExercise;

  /// No description provided for @resumeExercise.
  ///
  /// In en, this message translates to:
  /// **'Resume Exercise'**
  String get resumeExercise;

  /// No description provided for @exerciseCompleted.
  ///
  /// In en, this message translates to:
  /// **'Exercise Completed'**
  String get exerciseCompleted;

  /// No description provided for @exerciseProgress.
  ///
  /// In en, this message translates to:
  /// **'Exercise Progress'**
  String get exerciseProgress;

  /// No description provided for @progressChart.
  ///
  /// In en, this message translates to:
  /// **'Progress Chart'**
  String get progressChart;

  /// No description provided for @weeklyProgress.
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// No description provided for @monthlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Monthly Progress'**
  String get monthlyProgress;

  /// No description provided for @yearlyProgress.
  ///
  /// In en, this message translates to:
  /// **'Yearly Progress'**
  String get yearlyProgress;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// No description provided for @totalExercises.
  ///
  /// In en, this message translates to:
  /// **'Total Exercises'**
  String get totalExercises;

  /// No description provided for @completedExercises.
  ///
  /// In en, this message translates to:
  /// **'Completed Exercises'**
  String get completedExercises;

  /// No description provided for @remainingExercises.
  ///
  /// In en, this message translates to:
  /// **'Remaining Exercises'**
  String get remainingExercises;

  /// No description provided for @exerciseStats.
  ///
  /// In en, this message translates to:
  /// **'Exercise Statistics'**
  String get exerciseStats;

  /// No description provided for @medicationReminder.
  ///
  /// In en, this message translates to:
  /// **'Medication Reminder'**
  String get medicationReminder;

  /// No description provided for @appointmentReminder.
  ///
  /// In en, this message translates to:
  /// **'Appointment Reminder'**
  String get appointmentReminder;

  /// No description provided for @appointmentSchedule.
  ///
  /// In en, this message translates to:
  /// **'Appointment Schedule'**
  String get appointmentSchedule;

  /// No description provided for @upcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointments'**
  String get upcomingAppointments;

  /// No description provided for @pastAppointments.
  ///
  /// In en, this message translates to:
  /// **'Past Appointments'**
  String get pastAppointments;

  /// No description provided for @appointmentDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get appointmentDate;

  /// No description provided for @appointmentTime.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get appointmentTime;

  /// No description provided for @appointmentLocation.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get appointmentLocation;

  /// No description provided for @appointmentDoctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get appointmentDoctor;

  /// No description provided for @appointmentNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get appointmentNotes;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @cancelAppointment.
  ///
  /// In en, this message translates to:
  /// **'Cancel Appointment'**
  String get cancelAppointment;

  /// No description provided for @rescheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Appointment'**
  String get rescheduleAppointment;

  /// No description provided for @appointmentConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Appointment Confirmed'**
  String get appointmentConfirmed;

  /// No description provided for @appointmentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Appointment Cancelled'**
  String get appointmentCancelled;

  /// No description provided for @appointmentRescheduled.
  ///
  /// In en, this message translates to:
  /// **'Appointment Rescheduled'**
  String get appointmentRescheduled;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'Specialization'**
  String get specialization;

  /// No description provided for @contactDoctor.
  ///
  /// In en, this message translates to:
  /// **'Contact Doctor'**
  String get contactDoctor;

  /// No description provided for @callDoctor.
  ///
  /// In en, this message translates to:
  /// **'Call Doctor'**
  String get callDoctor;

  /// No description provided for @messageDoctor.
  ///
  /// In en, this message translates to:
  /// **'Message Doctor'**
  String get messageDoctor;

  /// No description provided for @emailDoctor.
  ///
  /// In en, this message translates to:
  /// **'Email Doctor'**
  String get emailDoctor;

  /// No description provided for @patientHistory.
  ///
  /// In en, this message translates to:
  /// **'Patient History'**
  String get patientHistory;

  /// No description provided for @medicalHistory.
  ///
  /// In en, this message translates to:
  /// **'Medical History'**
  String get medicalHistory;

  /// No description provided for @medications.
  ///
  /// In en, this message translates to:
  /// **'Medications'**
  String get medications;

  /// No description provided for @allergies.
  ///
  /// In en, this message translates to:
  /// **'Allergies'**
  String get allergies;

  /// No description provided for @surgeries.
  ///
  /// In en, this message translates to:
  /// **'Surgeries'**
  String get surgeries;

  /// No description provided for @familyHistory.
  ///
  /// In en, this message translates to:
  /// **'Family History'**
  String get familyHistory;

  /// No description provided for @lifestyleHabits.
  ///
  /// In en, this message translates to:
  /// **'Lifestyle Habits'**
  String get lifestyleHabits;

  /// No description provided for @smoker.
  ///
  /// In en, this message translates to:
  /// **'Smoker'**
  String get smoker;

  /// No description provided for @drinker.
  ///
  /// In en, this message translates to:
  /// **'Drinker'**
  String get drinker;

  /// No description provided for @exerciseFrequency.
  ///
  /// In en, this message translates to:
  /// **'Exercise Frequency'**
  String get exerciseFrequency;

  /// No description provided for @diet.
  ///
  /// In en, this message translates to:
  /// **'Diet'**
  String get diet;

  /// No description provided for @sleepPattern.
  ///
  /// In en, this message translates to:
  /// **'Sleep Pattern'**
  String get sleepPattern;

  /// No description provided for @stressLevel.
  ///
  /// In en, this message translates to:
  /// **'Stress Level'**
  String get stressLevel;

  /// No description provided for @bloodPressure.
  ///
  /// In en, this message translates to:
  /// **'Blood Pressure'**
  String get bloodPressure;

  /// No description provided for @cholesterol.
  ///
  /// In en, this message translates to:
  /// **'Cholesterol'**
  String get cholesterol;

  /// No description provided for @bloodSugar.
  ///
  /// In en, this message translates to:
  /// **'Blood Sugar'**
  String get bloodSugar;

  /// No description provided for @heartRate.
  ///
  /// In en, this message translates to:
  /// **'Heart Rate'**
  String get heartRate;

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @height.
  ///
  /// In en, this message translates to:
  /// **'Height'**
  String get height;

  /// No description provided for @bmi.
  ///
  /// In en, this message translates to:
  /// **'BMI'**
  String get bmi;

  /// No description provided for @vitalSigns.
  ///
  /// In en, this message translates to:
  /// **'Vital Signs'**
  String get vitalSigns;

  /// No description provided for @recentVitals.
  ///
  /// In en, this message translates to:
  /// **'Recent Vitals'**
  String get recentVitals;

  /// No description provided for @vitalsHistory.
  ///
  /// In en, this message translates to:
  /// **'Vitals History'**
  String get vitalsHistory;

  /// No description provided for @addVitals.
  ///
  /// In en, this message translates to:
  /// **'Add Vitals'**
  String get addVitals;

  /// No description provided for @editVitals.
  ///
  /// In en, this message translates to:
  /// **'Edit Vitals'**
  String get editVitals;

  /// No description provided for @deleteVitals.
  ///
  /// In en, this message translates to:
  /// **'Delete Vitals'**
  String get deleteVitals;

  /// No description provided for @vitalsUpdated.
  ///
  /// In en, this message translates to:
  /// **'Vitals Updated'**
  String get vitalsUpdated;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @abnormal.
  ///
  /// In en, this message translates to:
  /// **'Abnormal'**
  String get abnormal;

  /// No description provided for @critical.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get critical;

  /// No description provided for @warning_message.
  ///
  /// In en, this message translates to:
  /// **'Warning: Your vitals are abnormal'**
  String get warning_message;

  /// No description provided for @contact_doctor_message.
  ///
  /// In en, this message translates to:
  /// **'Please contact your doctor immediately'**
  String get contact_doctor_message;

  /// No description provided for @recovery_tips.
  ///
  /// In en, this message translates to:
  /// **'Recovery Tips'**
  String get recovery_tips;

  /// No description provided for @daily_tips.
  ///
  /// In en, this message translates to:
  /// **'Daily Tips'**
  String get daily_tips;

  /// No description provided for @weekly_tips.
  ///
  /// In en, this message translates to:
  /// **'Weekly Tips'**
  String get weekly_tips;

  /// No description provided for @tip_of_the_day.
  ///
  /// In en, this message translates to:
  /// **'Tip of the Day'**
  String get tip_of_the_day;

  /// No description provided for @recovery_milestone.
  ///
  /// In en, this message translates to:
  /// **'Recovery Milestone'**
  String get recovery_milestone;

  /// No description provided for @achieved_milestone.
  ///
  /// In en, this message translates to:
  /// **'You achieved a new milestone!'**
  String get achieved_milestone;

  /// No description provided for @share_achievement.
  ///
  /// In en, this message translates to:
  /// **'Share Achievement'**
  String get share_achievement;

  /// No description provided for @badges.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get badges;

  /// No description provided for @achievements.
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievements;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @enable_notifications.
  ///
  /// In en, this message translates to:
  /// **'Enable Notifications'**
  String get enable_notifications;

  /// No description provided for @notification_settings.
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notification_settings;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @vibration.
  ///
  /// In en, this message translates to:
  /// **'Vibration'**
  String get vibration;

  /// No description provided for @push_notifications.
  ///
  /// In en, this message translates to:
  /// **'Push Notifications'**
  String get push_notifications;

  /// No description provided for @email_notifications.
  ///
  /// In en, this message translates to:
  /// **'Email Notifications'**
  String get email_notifications;

  /// No description provided for @sms_notifications.
  ///
  /// In en, this message translates to:
  /// **'SMS Notifications'**
  String get sms_notifications;

  /// No description provided for @reminder_frequency.
  ///
  /// In en, this message translates to:
  /// **'Reminder Frequency'**
  String get reminder_frequency;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark_mode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get dark_mode;

  /// No description provided for @light_mode.
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get light_mode;

  /// No description provided for @font_size.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get font_size;

  /// No description provided for @small.
  ///
  /// In en, this message translates to:
  /// **'Small'**
  String get small;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @large.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get large;

  /// No description provided for @extra_large.
  ///
  /// In en, this message translates to:
  /// **'Extra Large'**
  String get extra_large;

  /// No description provided for @accessibility.
  ///
  /// In en, this message translates to:
  /// **'Accessibility'**
  String get accessibility;

  /// No description provided for @text_to_speech.
  ///
  /// In en, this message translates to:
  /// **'Text to Speech'**
  String get text_to_speech;

  /// No description provided for @screen_reader.
  ///
  /// In en, this message translates to:
  /// **'Screen Reader'**
  String get screen_reader;

  /// No description provided for @high_contrast.
  ///
  /// In en, this message translates to:
  /// **'High Contrast'**
  String get high_contrast;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @terms_of_service.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get terms_of_service;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @build_number.
  ///
  /// In en, this message translates to:
  /// **'Build Number'**
  String get build_number;

  /// No description provided for @last_sync.
  ///
  /// In en, this message translates to:
  /// **'Last Sync'**
  String get last_sync;

  /// No description provided for @account_settings.
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get account_settings;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @change_email.
  ///
  /// In en, this message translates to:
  /// **'Change Email'**
  String get change_email;

  /// No description provided for @two_factor_authentication.
  ///
  /// In en, this message translates to:
  /// **'Two Factor Authentication'**
  String get two_factor_authentication;

  /// No description provided for @enable_2fa.
  ///
  /// In en, this message translates to:
  /// **'Enable 2FA'**
  String get enable_2fa;

  /// No description provided for @disable_2fa.
  ///
  /// In en, this message translates to:
  /// **'Disable 2FA'**
  String get disable_2fa;

  /// No description provided for @backup_codes.
  ///
  /// In en, this message translates to:
  /// **'Backup Codes'**
  String get backup_codes;

  /// No description provided for @export_data.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get export_data;

  /// No description provided for @import_data.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get import_data;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @confirm_delete_account.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete your account? This action cannot be undone.'**
  String get confirm_delete_account;

  /// No description provided for @account_deleted.
  ///
  /// In en, this message translates to:
  /// **'Account Deleted Successfully'**
  String get account_deleted;

  /// No description provided for @export_successful.
  ///
  /// In en, this message translates to:
  /// **'Export Successful'**
  String get export_successful;

  /// No description provided for @import_successful.
  ///
  /// In en, this message translates to:
  /// **'Import Successful'**
  String get import_successful;

  /// No description provided for @sync_in_progress.
  ///
  /// In en, this message translates to:
  /// **'Sync in Progress'**
  String get sync_in_progress;

  /// No description provided for @sync_complete.
  ///
  /// In en, this message translates to:
  /// **'Sync Complete'**
  String get sync_complete;

  /// No description provided for @sync_failed.
  ///
  /// In en, this message translates to:
  /// **'Sync Failed'**
  String get sync_failed;

  /// No description provided for @retry_sync.
  ///
  /// In en, this message translates to:
  /// **'Retry Sync'**
  String get retry_sync;

  /// No description provided for @offline_mode.
  ///
  /// In en, this message translates to:
  /// **'Offline Mode'**
  String get offline_mode;

  /// No description provided for @online_mode.
  ///
  /// In en, this message translates to:
  /// **'Online Mode'**
  String get online_mode;

  /// No description provided for @synchronize.
  ///
  /// In en, this message translates to:
  /// **'Synchronize'**
  String get synchronize;

  /// No description provided for @clear_cache.
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clear_cache;

  /// No description provided for @cache_cleared.
  ///
  /// In en, this message translates to:
  /// **'Cache Cleared'**
  String get cache_cleared;

  /// No description provided for @storage_info.
  ///
  /// In en, this message translates to:
  /// **'Storage Information'**
  String get storage_info;

  /// No description provided for @storage_used.
  ///
  /// In en, this message translates to:
  /// **'Storage Used'**
  String get storage_used;

  /// No description provided for @storage_available.
  ///
  /// In en, this message translates to:
  /// **'Storage Available'**
  String get storage_available;

  /// No description provided for @consent.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions'**
  String get consent;

  /// No description provided for @medical_disclaimer.
  ///
  /// In en, this message translates to:
  /// **'Medical Disclaimer'**
  String get medical_disclaimer;

  /// No description provided for @emergency_contact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergency_contact;

  /// No description provided for @emergency_number.
  ///
  /// In en, this message translates to:
  /// **'Emergency Number'**
  String get emergency_number;

  /// No description provided for @call_emergency.
  ///
  /// In en, this message translates to:
  /// **'Call Emergency'**
  String get call_emergency;

  /// No description provided for @sos.
  ///
  /// In en, this message translates to:
  /// **'SOS'**
  String get sos;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
