import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_lao_app/enums/section_type.dart';

class HiveUtility {
  static const String consonantCompletionBox = 'consonant_completion';
  static const String vowelCompletionBox = 'vowel_completion';

  static Future<void> initializeBoxes() async {
    await Hive.openBox<bool>(consonantCompletionBox);
    await Hive.openBox<bool>(vowelCompletionBox);
  }

  static bool isLessonCompleted(int lessonIndex, SectionType sectionType) {
    return Hive.box<bool>(
          sectionType == SectionType.consonant
              ? consonantCompletionBox
              : vowelCompletionBox,
        ).get(lessonIndex) ??
        false;
  }

  static void setLessonCompleted(
    int lessonIndex,
    bool value,
    SectionType sectionType,
  ) {
    Hive.box<bool>(
      sectionType == SectionType.consonant
          ? consonantCompletionBox
          : vowelCompletionBox,
    ).put(lessonIndex, value);
  }

  static String boxName(SectionType sectionType) {
    return sectionType == SectionType.consonant
        ? consonantCompletionBox
        : vowelCompletionBox;
  }

  static int getLastLessonComplete(SectionType sectionType) {
    int lastLessonIndex = 0;
    while (isLessonCompleted(lastLessonIndex, sectionType)) {
      lastLessonIndex++;
    }
    return lastLessonIndex;
  }
}
