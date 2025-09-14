import 'package:hive_flutter/hive_flutter.dart';
import 'package:learn_lao_app/enums/letter_type.dart';

class HiveUtility {
  static const String consonantCompletionBox = 'consonant_completion';
  static const String vowelCompletionBox = 'vowel_completion';

  static Future<void> initializeBoxes() async {
    await Hive.openBox<bool>(consonantCompletionBox);
    await Hive.openBox<bool>(vowelCompletionBox);
  }

  static bool isLessonCompleted(int lessonIndex, LetterType sectionType) {
    return Hive.box<bool>(
          sectionType == LetterType.consonant
              ? consonantCompletionBox
              : vowelCompletionBox,
        ).get(lessonIndex) ??
        false;
  }

  static void setLessonCompleted(
    int lessonIndex,
    bool value,
    LetterType sectionType,
  ) {
    Hive.box<bool>(
      sectionType == LetterType.consonant
          ? consonantCompletionBox
          : vowelCompletionBox,
    ).put(lessonIndex, value);
  }

  static String boxName(LetterType sectionType) {
    return sectionType == LetterType.consonant
        ? consonantCompletionBox
        : vowelCompletionBox;
  }

  static int getLastLessonComplete(LetterType sectionType) {
    int lastLessonIndex = 0;
    while (isLessonCompleted(lastLessonIndex, sectionType)) {
      lastLessonIndex++;
    }
    return lastLessonIndex;
  }
}
