import 'package:flutter/material.dart';
import 'package:learn_lao_app/enums/letter_type.dart';
import 'package:learn_lao_app/pages/navigation_page.dart';
import 'package:learn_lao_app/pages/lesson_wrapper.dart';
import 'package:learn_lao_app/utilities/lesson_data.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:provider/provider.dart';

class LessonNavButton extends StatelessWidget {
  const LessonNavButton({
    super.key,
    required this.index,
    required this.lessonStatus,
    required this.sectionType,
  });

  final int index;
  final LessonStatus lessonStatus;
  final LetterType sectionType;

  void _navigateToLesson(BuildContext context) {
    final lessons = sectionType == LetterType.consonant
        ? LessonData.consonantLessons
        : LessonData.vowelLessons;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider(
            create: (context) => LessonProvider(),
            child: LessonWrapper(
              exercises: lessons.elementAtOrNull(index),
              lessonIndex: index,
              sectionType: sectionType,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final child = Text(
      (index + 1).toString(),
      style: TextStyle(fontSize: theme.textTheme.displayMedium?.fontSize),
    );

    if (lessonStatus == LessonStatus.nextUp) {
      return ElevatedButton(
        onPressed: () => _navigateToLesson(context),
        child: child,
      );
    } else if (lessonStatus == LessonStatus.completed) {
      return OutlinedButton(
        onPressed: () => _navigateToLesson(context),
        child: child,
      );
    } else {
      // lessonStatus == LessonStatus.notStarted
      return TextButton(onPressed: null, child: child);
    }
  }
}
