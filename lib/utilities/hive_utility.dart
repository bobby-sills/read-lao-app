import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/utilities/achievement_data.dart';
import 'package:read_lao/utilities/lesson_data.dart';

class HiveUtility {
  static const String lessonCompletionBox = 'lesson_completion';
  static const String streakBox = 'streak';
  static const String achievementsBox = 'achievements';

  static const String _currentStreakKey = 'currentStreak';
  static const String _lastActivityDateKey = 'lastActivityDate';
  static const String _totalActivityCountKey = 'totalActivityCount';
  static const String _activityMinutesSumKey = 'activityMinutesSum';
  static const String _notificationsEnabledKey = 'notificationsEnabled';
  static const String _firstLaunchKey = 'firstLaunch';

  static Future<void> initializeBoxes() async {
    await Hive.openBox<bool>(lessonCompletionBox);
    await Hive.openBox<dynamic>(streakBox);
    await Hive.openBox<dynamic>(achievementsBox);
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
    await Hive.box<dynamic>(achievementsBox).clear();
  }

  // --- Achievement methods ---

  static bool isAchievementUnlocked(String id) {
    return Hive.box<dynamic>(achievementsBox).containsKey(id);
  }

  static void unlockAchievement(String id) {
    Hive.box<dynamic>(achievementsBox).put(id, DateTime.now().toIso8601String());
  }

  static DateTime? getAchievementUnlockDate(String id) {
    final value = Hive.box<dynamic>(achievementsBox).get(id);
    if (value == null) return null;
    return DateTime.tryParse(value as String);
  }

  static List<String> checkAndUnlockAchievements() {
    final streak = getCurrentStreak();
    final lessonsCompleted = getLastLessonComplete();
    final totalLessons = LessonData.allLessons.length;
    final newlyUnlocked = <String>[];

    for (final achievement in AchievementData.streakAchievements) {
      if (streak >= achievement.threshold && !isAchievementUnlocked(achievement.id)) {
        unlockAchievement(achievement.id);
        newlyUnlocked.add(achievement.id);
      }
    }

    for (final achievement in AchievementData.lessonAchievements) {
      final threshold = achievement.id == 'lessons_all' ? totalLessons : achievement.threshold;
      if (lessonsCompleted >= threshold && !isAchievementUnlocked(achievement.id)) {
        unlockAchievement(achievement.id);
        newlyUnlocked.add(achievement.id);
      }
    }

    return newlyUnlocked;
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

  /// Records today's activity and returns true if the streak was incremented
  /// (i.e. this is the first lesson completed today).
  static bool recordActivity() {
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

    bool streakIncremented = false;
    if (lastDate != today) {
      streak = (lastDate == yesterday) ? streak + 1 : 1;
      box.put(_currentStreakKey, streak);
      box.put(_lastActivityDateKey, today);
      streakIncremented = true;
    }

    final int count =
        box.get(_totalActivityCountKey, defaultValue: 0) as int;
    final int sum =
        box.get(_activityMinutesSumKey, defaultValue: 0) as int;
    final int minutesSinceMidnight = now.hour * 60 + now.minute;
    box.put(_totalActivityCountKey, count + 1);
    box.put(_activityMinutesSumKey, sum + minutesSinceMidnight);
    return streakIncremented;
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
