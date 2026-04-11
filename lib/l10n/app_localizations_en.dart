// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Learn Lao';

  @override
  String get vowels => 'Vowels';

  @override
  String get consonants => 'Consonants';

  @override
  String get practiceSpellingTitle => 'Practice Spelling';

  @override
  String get practiceSpellingDescription =>
      'Test your spelling skills with random words from all the letters you\'ve learned.';

  @override
  String get startPractice => 'Start Practice';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get darkThemeEnabled => 'Dark theme enabled';

  @override
  String get lightThemeEnabled => 'Light theme enabled';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get reminderEnabled => 'Reminder enabled';

  @override
  String get reminderDisabled => 'Reminder disabled';

  @override
  String get notificationPermissionDenied => 'Notification permission denied';

  @override
  String get aboutThisApp => 'About this app';

  @override
  String get aboutVersion => 'Version 2.1.0';

  @override
  String get aboutDescription1 =>
      'An interactive app for learning the Lao language through engaging exercises and lessons.';

  @override
  String get aboutDescription2 =>
      'Learn to recognize, pronounce, and write Lao letters at your own pace.';

  @override
  String get close => 'Close';

  @override
  String get resetProgress => 'Reset Progress';

  @override
  String get resetProgressTitle => 'Reset Progress?';

  @override
  String get resetProgressContent =>
      'This will reset all lesson progress. This action cannot be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get reset => 'Reset';

  @override
  String get progressResetSuccessfully => 'Progress reset successfully';

  @override
  String get lessonsNavLabel => 'Lessons';

  @override
  String get practiceNavLabel => 'Practice';

  @override
  String get achievementsNavLabel => 'Achievements';

  @override
  String get settingsNavLabel => 'Settings';

  @override
  String get streakDialogNoStreak =>
      'Complete a lesson today to start your streak!';

  @override
  String get streakDialogOneDay => 'You have practiced for 1 day in a row!';

  @override
  String streakDialogMultipleDays(int count) {
    return 'You have practiced for $count days in a row!';
  }

  @override
  String get streakDialogButtonNoStreak => 'Let\'s go!';

  @override
  String get streakDialogButtonWithStreak => 'Nice!';

  @override
  String get exitLessonTitle => 'Exit Lesson?';

  @override
  String get exitLessonContent => 'Are you sure you want exit the lesson?';

  @override
  String lessonCompleteTitle(int number) {
    return 'Lesson $number complete!';
  }

  @override
  String get lessonCompleteSubtitle => 'Well done! Keep up the great work';

  @override
  String get backToLessons => 'Back to lessons';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get streakMilestones => 'Streak Milestones';

  @override
  String get lessonMilestones => 'Lesson Milestones';

  @override
  String unlockedOn(String date) {
    return 'Unlocked $date';
  }

  @override
  String get achievementUnlocked => 'Achievement Unlocked!';

  @override
  String get achievementsUnlocked => 'Achievements Unlocked!';

  @override
  String get continueButton => 'Continue';

  @override
  String streakDays(int count) {
    return '$count day streak!';
  }

  @override
  String get streakStarted =>
      'You\'ve started your streak — come back tomorrow!';

  @override
  String get streakContinue => 'Amazing consistency. Keep it going!';

  @override
  String get lessonNotFound => 'Lesson not found';

  @override
  String get goBack => 'Go back';

  @override
  String get timeToReview => 'Time to review!';

  @override
  String get practiceOnesYouMissed => 'Let\'s practice the ones you missed';

  @override
  String get correct => 'Correct!';

  @override
  String get incorrect => 'Incorrect!';

  @override
  String get answerShown => 'Answer shown';

  @override
  String get showAnswer => 'Show answer';

  @override
  String get skipToThisLesson => 'Skip to this lesson?';

  @override
  String get skipConfirmContent =>
      'Are you sure you want to skip to this lesson?';

  @override
  String get skip => 'Skip';
}
