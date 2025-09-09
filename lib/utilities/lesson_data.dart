import 'package:learn_lao_app/exercises/learn_consonant_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/lesson_generators/vowel_lesson_generator.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';

class LessonData {
  // static final List<List<StatefulExercise>> consonantLessons =
  //     ConsonantLessonGenerator.generateAllLessons(LetterData.consonantOrder);

  static final List<List<StatefulExercise>> consonantLessons = [
    LetterData.consonantOrder
        .map((letter) => LearnConsonantExercise(consonant: letter))
        .toList(),
  ];
  static final List<List<StatefulExercise>> vowelLessons =
      VowelLessonGenerator.generateAllLessons(LetterData.vowelOrder);
}
