import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/lesson_generator.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';

LessonGenerator lessonGenerator = LessonGenerator();

class AppData {
  static final List<List<StatefulExercise>> lessons = lessonGenerator
      .generateCompleteCurriculum(teachingOrder);
}
