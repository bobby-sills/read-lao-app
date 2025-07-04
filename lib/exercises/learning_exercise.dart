import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:provider/provider.dart';

class LearningExercise extends StatefulExercise {
  final String letter;

  LearningExercise({required this.letter, super.key});

  @override
  LearningExerciseState createState() => LearningExerciseState();
}

class LearningExerciseState extends StatefulExerciseState<LearningExercise> {
  final _speechPlayer = SoundsUtility();
  final _effectPlayer = SoundsUtility();
  @override
  Widget bottomSheetContent() {
    return Column(
      children: [
        SizedBox(height: 16),
        BottomLessonButton(
          onPressed: () {
            _effectPlayer.playSoundEffect('correct');
            Provider.of<LessonProvider>(
              context,
              listen: false,
            ).nextExerciseCallback!();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _speechPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDarkMode = theme.brightness == Brightness.dark;
    final Color svgColor = isDarkMode ? Colors.white : Colors.black;

    return Expanded(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image(
                  image: AssetImage(
                    'assets/letters/images/${laoToRomanization[widget.letter]}.png',
                  ),
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
            Expanded(
              flex: 2,
              child: SvgPicture.asset(
                'assets/letters/${laoToRomanization[widget.letter]}-word.svg',
                colorFilter: ColorFilter.mode(svgColor, BlendMode.srcIn),
                allowDrawingOutsideViewBox: true,
                fit: BoxFit.contain,
              ),
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {
                  _speechPlayer.playLetter(widget.letter);

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
