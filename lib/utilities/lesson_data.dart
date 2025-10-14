import 'package:read_lao/exercises/stateful_exercise.dart';
import 'package:read_lao/lesson_generators/lesson_generator.dart';

class LessonData {
  static final List<List<StatefulExercise>> allLessons =
      LessonGenerator.generateLessons();
}
