import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/lesson_generators/lesson_generator.dart';

class LessonData {
  // static final List<List<StatefulExercise>> consonantLessons =
  //     ConsonantLessonGenerator.generateAllLessons(LetterData.consonantOrder);

  // static final List<List<StatefulExercise>> consonantLessons = [
  //   LetterData.consonantOrder
  //       .map((letter) => LearnConsonantExercise(consonant: letter))
  //       .toList(),
  // ];
  static final List<List<StatefulExercise>> consonantLessons =
      LessonGenerator.generateLessons();
  static final List<List<StatefulExercise>> vowelLessons = [];
}
