import 'package:flutter/material.dart';
import 'package:learn_lao_app/pages/navigation_page.dart';
import 'package:learn_lao_app/pages/lesson_wrapper.dart';
import 'package:learn_lao_app/utilities/app_data.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:provider/provider.dart';

class LessonNavButton extends StatelessWidget {
  const LessonNavButton({
    super.key,
    required this.index,
    required this.lessonStatus,
  });

  final int index;
  final LessonStatus lessonStatus;

  void _navigateToLesson(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider(
            create: (context) => LessonProvider(),
            child: LessonWrapper(
              exercises: AppData.consonantLessons.elementAtOrNull(index),
              lessonIndex: index,
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
