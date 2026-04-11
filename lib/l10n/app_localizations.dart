import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_lo.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('lo'),
  ];

  /// The application title
  ///
  /// In en, this message translates to:
  /// **'Learn Lao'**
  String get appTitle;

  /// Section header for vowels on the lessons page
  ///
  /// In en, this message translates to:
  /// **'Vowels'**
  String get vowels;

  /// Section header for consonants on the lessons page
  ///
  /// In en, this message translates to:
  /// **'Consonants'**
  String get consonants;

  /// Title on the practice page
  ///
  /// In en, this message translates to:
  /// **'Practice Spelling'**
  String get practiceSpellingTitle;

  /// Description on the practice page
  ///
  /// In en, this message translates to:
  /// **'Test your spelling skills with random words from all the letters you\'ve learned.'**
  String get practiceSpellingDescription;

  /// Button to start a practice session
  ///
  /// In en, this message translates to:
  /// **'Start Practice'**
  String get startPractice;

  /// AppBar title on the settings page
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// Label for the dark mode toggle
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Subtitle shown when dark mode is on
  ///
  /// In en, this message translates to:
  /// **'Dark theme enabled'**
  String get darkThemeEnabled;

  /// Subtitle shown when dark mode is off
  ///
  /// In en, this message translates to:
  /// **'Light theme enabled'**
  String get lightThemeEnabled;

  /// Label for the daily reminder toggle
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// Subtitle shown when reminder is on
  ///
  /// In en, this message translates to:
  /// **'Reminder enabled'**
  String get reminderEnabled;

  /// Subtitle shown when reminder is off
  ///
  /// In en, this message translates to:
  /// **'Reminder disabled'**
  String get reminderDisabled;

  /// Snackbar when notification permission is denied
  ///
  /// In en, this message translates to:
  /// **'Notification permission denied'**
  String get notificationPermissionDenied;

  /// Label for the about dialog
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get aboutThisApp;

  /// Version string in the about dialog
  ///
  /// In en, this message translates to:
  /// **'Version 2.1.0'**
  String get aboutVersion;

  /// First description line in the about dialog
  ///
  /// In en, this message translates to:
  /// **'An interactive app for learning the Lao language through engaging exercises and lessons.'**
  String get aboutDescription1;

  /// Second description line in the about dialog
  ///
  /// In en, this message translates to:
  /// **'Learn to recognize, pronounce, and write Lao letters at your own pace.'**
  String get aboutDescription2;

  /// Generic close button label
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Label for the reset progress list tile
  ///
  /// In en, this message translates to:
  /// **'Reset Progress'**
  String get resetProgress;

  /// Title of the reset progress confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Reset Progress?'**
  String get resetProgressTitle;

  /// Content of the reset progress confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'This will reset all lesson progress. This action cannot be undone.'**
  String get resetProgressContent;

  /// Generic cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm reset button label
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Snackbar message after progress is reset
  ///
  /// In en, this message translates to:
  /// **'Progress reset successfully'**
  String get progressResetSuccessfully;

  /// Bottom nav bar label for lessons tab
  ///
  /// In en, this message translates to:
  /// **'Lessons'**
  String get lessonsNavLabel;

  /// Bottom nav bar label for practice tab
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get practiceNavLabel;

  /// Bottom nav bar label for achievements tab
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsNavLabel;

  /// Bottom nav bar label for settings tab
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsNavLabel;

  /// Dialog message when user has no streak
  ///
  /// In en, this message translates to:
  /// **'Complete a lesson today to start your streak!'**
  String get streakDialogNoStreak;

  /// Dialog message when user has a 1-day streak
  ///
  /// In en, this message translates to:
  /// **'You have practiced for 1 day in a row!'**
  String get streakDialogOneDay;

  /// Dialog message when user has a multi-day streak
  ///
  /// In en, this message translates to:
  /// **'You have practiced for {count} days in a row!'**
  String streakDialogMultipleDays(int count);

  /// Dialog button when user has no streak
  ///
  /// In en, this message translates to:
  /// **'Let\'s go!'**
  String get streakDialogButtonNoStreak;

  /// Dialog button when user has a streak
  ///
  /// In en, this message translates to:
  /// **'Nice!'**
  String get streakDialogButtonWithStreak;

  /// Title of the exit lesson confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Exit Lesson?'**
  String get exitLessonTitle;

  /// Content of the exit lesson confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want exit the lesson?'**
  String get exitLessonContent;

  /// Title shown when a lesson is complete
  ///
  /// In en, this message translates to:
  /// **'Lesson {number} complete!'**
  String lessonCompleteTitle(int number);

  /// Subtitle shown when a lesson is complete
  ///
  /// In en, this message translates to:
  /// **'Well done! Keep up the great work'**
  String get lessonCompleteSubtitle;

  /// Button to return to the lessons list
  ///
  /// In en, this message translates to:
  /// **'Back to lessons'**
  String get backToLessons;

  /// Title on the achievements page
  ///
  /// In en, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// Section header for streak achievements
  ///
  /// In en, this message translates to:
  /// **'Streak Milestones'**
  String get streakMilestones;

  /// Section header for lesson achievements
  ///
  /// In en, this message translates to:
  /// **'Lesson Milestones'**
  String get lessonMilestones;

  /// Label showing when an achievement was unlocked
  ///
  /// In en, this message translates to:
  /// **'Unlocked {date}'**
  String unlockedOn(String date);

  /// Title when a single achievement is unlocked
  ///
  /// In en, this message translates to:
  /// **'Achievement Unlocked!'**
  String get achievementUnlocked;

  /// Title when multiple achievements are unlocked
  ///
  /// In en, this message translates to:
  /// **'Achievements Unlocked!'**
  String get achievementsUnlocked;

  /// Generic continue button label
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueButton;

  /// Title on the streak updated page
  ///
  /// In en, this message translates to:
  /// **'{count} day streak!'**
  String streakDays(int count);

  /// Message shown when user starts a new streak
  ///
  /// In en, this message translates to:
  /// **'You\'ve started your streak — come back tomorrow!'**
  String get streakStarted;

  /// Message shown when user continues their streak
  ///
  /// In en, this message translates to:
  /// **'Amazing consistency. Keep it going!'**
  String get streakContinue;

  /// Error message when a lesson cannot be found
  ///
  /// In en, this message translates to:
  /// **'Lesson not found'**
  String get lessonNotFound;

  /// Button to navigate back
  ///
  /// In en, this message translates to:
  /// **'Go back'**
  String get goBack;

  /// Title on the mistake review screen
  ///
  /// In en, this message translates to:
  /// **'Time to review!'**
  String get timeToReview;

  /// Subtitle on the mistake review screen
  ///
  /// In en, this message translates to:
  /// **'Let\'s practice the ones you missed'**
  String get practiceOnesYouMissed;

  /// Feedback when the answer is correct
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct;

  /// Feedback when the answer is incorrect
  ///
  /// In en, this message translates to:
  /// **'Incorrect!'**
  String get incorrect;

  /// Feedback when the answer is revealed
  ///
  /// In en, this message translates to:
  /// **'Answer shown'**
  String get answerShown;

  /// Button to reveal the answer after repeated failures
  ///
  /// In en, this message translates to:
  /// **'Show answer'**
  String get showAnswer;

  /// Title of the skip-to-lesson confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Skip to this lesson?'**
  String get skipToThisLesson;

  /// Content of the skip-to-lesson confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to skip to this lesson?'**
  String get skipConfirmContent;

  /// Button to confirm skipping to a lesson
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'lo'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'lo':
      return AppLocalizationsLo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
