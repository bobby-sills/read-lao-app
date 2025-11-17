import 'package:hive_flutter/hive_flutter.dart';

class HiveUtility {
  static const String lessonCompletionBox = 'lesson_completion';

  static Future<void> initializeBoxes() async {
    await Hive.openBox<bool>(lessonCompletionBox);
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
    final box = Hive.box<bool>(lessonCompletionBox);
    await box.clear();
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
}
