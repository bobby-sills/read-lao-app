import 'package:read_lao/enums/letter_type.dart';
import 'package:read_lao/exercises/stateful_exercise.dart';
import 'package:read_lao/lesson_generators/lesson_generator.dart';

class LessonData {
  static final List<List<StatefulExercise>> consonantLessons =
      LessonGenerator.generateLessonsForLetterType(
        letterType: LetterType.consonant,
      );
  static final List<List<StatefulExercise>> vowelLessons =
      LessonGenerator.generateLessonsForLetterType(
        letterType: LetterType.consonant,
      );
  static final List<List<StatefulExercise>> allLessons =
      consonantLessons + vowelLessons;
}
