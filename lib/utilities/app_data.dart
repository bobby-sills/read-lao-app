// ignore_for_file: unused_import

import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/learn_vowel_exercise.dart';
import 'package:learn_lao_app/exercises/matching_exercise.dart';
import 'package:learn_lao_app/exercises/select_letter_exercise.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/lesson_generators/vowel_lesson_generator.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/lesson_generators/consonant_lesson_generator.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';

ConsonantLessonGenerator lessonGenerator = ConsonantLessonGenerator();

class AppData {
  // static final List<List<StatefulExercise>> consonantLessons = lessonGenerator
  //     .generateCompleteCurriculum(consonantOrder);
  static final List<List<StatefulExercise>> consonantLessons = [];
  static final List<List<StatefulExercise>> vowelLessons =
      VowelLessonGenerator.generateAllLessons(LetterData.vowelOrder);
}
