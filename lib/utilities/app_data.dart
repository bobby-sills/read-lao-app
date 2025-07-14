import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/utilities/lesson_generator.dart';

LessonGenerator lessonGenerator = LessonGenerator();

class AppData {
  static final List<List<StatefulExercise>> consonantLessons = lessonGenerator
      .generateCompleteCurriculum(teachingOrder);
  static final List<List<StatefulExercise>> vowelLessons = [];
}
