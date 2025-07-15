import 'package:flutter/material.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/components/dynamic_bold_text.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:provider/provider.dart';

class LearnVowelExercise extends StatefulExercise {
  final String letter;
  final int letterIndex;
  final String? placeholder;

  LearnVowelExercise({
    required this.letter,
    required this.letterIndex,
    this.placeholder,
    super.key,
  });

  @override
  LearnVowelExerciseState createState() => LearnVowelExerciseState();
}

class LearnVowelExerciseState
    extends StatefulExerciseState<LearnVowelExercise> {
  final _speechPlayer = SoundsUtility();
  final _effectPlayer = SoundsUtility();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget bottomSheetContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        BottomLessonButton(
          onPressed: () {
            _effectPlayer.playSoundEffect('correct');
            context.read<LessonProvider>().nextExercise?.call();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _speechPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: DynamicBoldText(
                  text: widget.letter,
                  targetCharacter: vowelPlaceholder,
                  fontSize: 200,
                  boldColor: isDarkMode ? Colors.white : Colors.black,
                  outlineColor: isDarkMode ? Colors.white : Colors.black,
                  strokeWidth: 2.5,
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.letter,
                  style: laoStyle.copyWith(fontSize: 10000),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {
                  _speechPlayer.playVowel(widget.letterIndex);

                  if (!Provider.of<LessonProvider>(
                    context,
                    listen: false,
                  ).isBottomSheetVisible) {
                    showBottomBar(
                      context: context,
                      onShow: () {
                        Provider.of<LessonProvider>(
                          context,
                          listen: false,
                        ).setBottomSheetVisible(true);
                      },
                      onHide: () {
                        Provider.of<LessonProvider>(
                          context,
                          listen: false,
                        ).setBottomSheetVisible(false);
                      },
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
                ),
                child: Icon(
                  Icons.volume_up_rounded,
                  size: theme.textTheme.displayMedium?.fontSize,
                ),
              ),
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
