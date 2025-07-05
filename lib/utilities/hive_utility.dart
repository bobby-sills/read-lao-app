import 'package:hive_flutter/hive_flutter.dart';

class HiveUtility {
  static const String lessonCompletionBox = 'lesson_completion';

  static initializeBoxes() async {
    await Hive.openBox<bool>(lessonCompletionBox);
  }

  static bool isLessonCompleted(int lessonIndex) {
    return Hive.box<bool>(lessonCompletionBox).get(lessonIndex) ??
        false; // set this to false when finished debugging
  }

  static void setLessonCompleted(int lessonIndex, bool value) {
    Hive.box<bool>(lessonCompletionBox).put(lessonIndex, value);
  }

  bool get lessonComplete =>
      Hive.box<bool>(lessonCompletionBox).get(0) ?? false;
  set lessonComplete(bool value) =>
      Hive.box<bool>(lessonCompletionBox).put(0, value);
}
