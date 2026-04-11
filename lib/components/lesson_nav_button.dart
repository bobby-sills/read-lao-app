import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:read_lao/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:read_lao/pages/lesson_wrapper.dart';
import 'package:read_lao/pages/lessons_page.dart';
import 'package:read_lao/utilities/lesson_data.dart';
import 'package:read_lao/utilities/hive_utility.dart';
import 'package:read_lao/utilities/provider/lesson_provider.dart';
import 'package:read_lao/utilities/shared_styles.dart';

class LessonNavButton extends StatelessWidget {
  const LessonNavButton({
    super.key,
    required this.index,
    required this.character,
    required this.lessonStatus,
  });

  final int index;
  final String character;
  final LessonStatus lessonStatus;

  void _navigateToLesson(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return ChangeNotifierProvider(
            create: (context) => LessonProvider(),
            child: LessonWrapper(
              exercises: LessonData.allLessons.elementAtOrNull(index),
              lessonIndex: index,
            ),
          );
        },
      ),
    );
  }

  void _showSkipConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final innerL10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(innerL10n.skipToThisLesson),
          content: Text(innerL10n.skipConfirmContent),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(innerL10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                await HiveUtility.skipToLesson(index);
                if (context.mounted) {
                  Navigator.pop(context);
                  _navigateToLesson(context);
                }
              },
              child: Text(innerL10n.skip),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(character, style: laoStyle.copyWith(fontSize: 30)),
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
      return GestureDetector(
        onTap: () => _showSkipConfirmation(context),
        child: TextButton(onPressed: null, child: child),
      );
    }
  }
}
