import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/utilities/lesson_generator.dart';

LessonGenerator lessonGenerator = LessonGenerator();

class AppData {
  static final List<List<StatefulExercise>> consonantLessons = lessonGenerator
      .generateCompleteCurriculum(consonantOrder);
  static final List<List<StatefulExercise>> vowelLessons = [
    [
      for (int i = 0; i < vowelsIndices.length; i++)
        LearnVowelExercise(letter: vowelsIndices[i], letterIndex: i),
    ],
  ];
}
