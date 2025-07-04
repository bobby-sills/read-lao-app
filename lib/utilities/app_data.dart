import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/lesson_generator.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';

class AppData {
  static final List<List<StatefulExercise>> lessons = [
    ...LessonGenerator.generateLessonTriplet(['ບ', 'ດ', 'ຟ'], ['ບ', 'ດ', 'ຟ']),
    [LearnVowelExercise(letter: vowelsIndices[0], letterIndex: 0)],
  ];
}
