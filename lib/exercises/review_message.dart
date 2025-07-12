import 'package:flutter/material.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:provider/provider.dart';

class ReviewMessage extends StatefulExercise {
  ReviewMessage({super.key});

  @override
  ReviewMessageState createState() => ReviewMessageState();
}

class ReviewMessageState extends StatefulExerciseState<ReviewMessage> {
  final _effectPlayer = SoundsUtility();
  @override
  Widget bottomSheetContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        BottomLessonButton(
          onPressed: () {
            context.read<LessonProvider>().nextExercise?.call();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showBottomBar(
        context: context,
        onShow: () {
          context.read<LessonProvider>().setBottomSheetVisible(true);
        },
        onHide: () {
          context.read<LessonProvider>().setBottomSheetVisible(false);
        },
      );
    });
    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.refresh_rounded,
                size: 80,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 32),
            Text(
              "Time to review!",
              style: theme.textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "Let's practice the ones you missed",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
