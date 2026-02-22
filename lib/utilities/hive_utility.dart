import 'package:hive_flutter/hive_flutter.dart';

class HiveUtility {
  static const String lessonCompletionBox = 'lesson_completion';
  static const String streakBox = 'streak';

  static const String _currentStreakKey = 'currentStreak';
  static const String _lastActivityDateKey = 'lastActivityDate';
  static const String _totalActivityCountKey = 'totalActivityCount';
  static const String _activityMinutesSumKey = 'activityMinutesSum';
  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _firstLaunchKey = 'firstLaunch';

  static Future<void> initializeBoxes() async {
    await Hive.openBox<bool>(lessonCompletionBox);
    await Hive.openBox<dynamic>(streakBox);
  }

  static bool isLessonCompleted(int lessonIndex) {
    return Hive.box<bool>(lessonCompletionBox).get(lessonIndex) ?? false;
  }

  static void setLessonCompleted(int lessonIndex, bool value) {
    Hive.box<bool>(lessonCompletionBox).put(lessonIndex, value);
  }

  static int getLastLessonComplete() {
    int lastLessonIndex = 0;
    while (isLessonCompleted(lastLessonIndex)) {
      lastLessonIndex++;
    }
    return lastLessonIndex;
  }

  static Future<void> clearAllData() async {
    await Hive.box<bool>(lessonCompletionBox).clear();
    await Hive.box<dynamic>(streakBox).clear();
  }

  static Future<void> markAllLessonsComplete(int totalLessons) async {
    final box = Hive.box<bool>(lessonCompletionBox);
    for (int i = 0; i < totalLessons; i++) {
      await box.put(i, true);
    }
  }

  static Future<void> skipToLesson(int lessonIndex) async {
    final box = Hive.box<bool>(lessonCompletionBox);
    // Mark all lessons before the target lesson as complete
    for (int i = 0; i < lessonIndex; i++) {
      await box.put(i, true);
    }
    // Mark the target lesson and all lessons after as incomplete
    for (int i = lessonIndex; i < 1000; i++) {
      // 1000 is a safe upper bound for total lessons
      if (box.containsKey(i)) {
        await box.put(i, false);
      }
    }
  }

  // --- Streak methods ---

  static int getCurrentStreak() {
    return Hive.box<dynamic>(streakBox).get(_currentStreakKey, defaultValue: 0)
        as int;
  }

  static void recordActivity() {
    final box = Hive.box<dynamic>(streakBox);
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final yesterdayDate = now.subtract(const Duration(days: 1));
    final yesterday =
        '${yesterdayDate.year}-${yesterdayDate.month.toString().padLeft(2, '0')}-${yesterdayDate.day.toString().padLeft(2, '0')}';

    final String lastDate =
        box.get(_lastActivityDateKey, defaultValue: '') as String;
    int streak =
        box.get(_currentStreakKey, defaultValue: 0) as int;

    if (lastDate != today) {
      streak = (lastDate == yesterday) ? streak + 1 : 1;
      box.put(_currentStreakKey, streak);
      box.put(_lastActivityDateKey, today);
    }

    final int count =
        box.get(_totalActivityCountKey, defaultValue: 0) as int;
    final int sum =
        box.get(_activityMinutesSumKey, defaultValue: 0) as int;
    final int minutesSinceMidnight = now.hour * 60 + now.minute;
    box.put(_totalActivityCountKey, count + 1);
    box.put(_activityMinutesSumKey, sum + minutesSinceMidnight);
  }

  static int getNotificationMinutes() {
    final box = Hive.box<dynamic>(streakBox);
    final int count =
        box.get(_totalActivityCountKey, defaultValue: 0) as int;
    if (count == 0) return 1200; // default: 8:00 PM
    final int sum = box.get(_activityMinutesSumKey, defaultValue: 0) as int;
    final int computed = (sum / count).round() - 30;
    return computed.clamp(0, 1439);
  }

  static bool getNotificationsEnabled() {
    return Hive.box<dynamic>(streakBox)
            .get(_notificationsEnabledKey, defaultValue: false) as bool;
  }

  static void setNotificationsEnabled(bool value) {
    Hive.box<dynamic>(streakBox).put(_notificationsEnabledKey, value);
  }

  static bool isFirstLaunch() {
    return !Hive.box<dynamic>(streakBox).containsKey(_firstLaunchKey);
  }

  static void markFirstLaunchDone() {
    Hive.box<dynamic>(streakBox).put(_firstLaunchKey, true);
  }
}
