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
}
