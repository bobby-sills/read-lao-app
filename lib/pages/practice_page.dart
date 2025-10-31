import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/lesson_data.dart';

class PracticePage extends StatelessWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: Hive.box<bool>(
        HiveUtility.lessonCompletionBox,
      ).listenable(),
      builder: (BuildContext context, Box<bool> box, Widget? child) {
        final allLessonsCompleted = HiveUtility.isLessonCompleted(
          LessonData.allLessons.length - 1,
        );

        if (!allLessonsCompleted) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Please complete all lessons before practicing spelling',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Finish all the lessons in the Lessons tab to unlock spelling practice.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        // TODO: Add practice exercises here when all lessons are completed
        return Scaffold(
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                'Practice exercises coming soon!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        );
      },
    );
  }
}
