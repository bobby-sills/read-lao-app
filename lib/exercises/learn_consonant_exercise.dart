import 'package:flutter/material.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/components/dynamic_bold_text.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:provider/provider.dart';

class LearnConsonantExercise extends StatefulExercise {
  final String letter;
  final String word;

  LearnConsonantExercise({required this.letter, required this.word, super.key});

  @override
  LearningExerciseState createState() => LearningExerciseState();
}

class LearningExerciseState
    extends StatefulExerciseState<LearnConsonantExercise> {
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
    //_effectPlayer.dispose(); // idk why it causes an error if I dispose it because then the
                               // bottom sheet content can't play the correct sound effect
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // This is needed for generating a unique key

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
                    'assets/letters/images/jpgs/${LetterData.laoToRomanization[widget.letter]}.jpg',
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
              child: FittedBox(
                fit: BoxFit.contain,
                child: DynamicBoldText(
                  text: widget.word,
                  targetCharacter: widget.letter,
                  textStyle: theme.textTheme.headlineLarge!.copyWith(
                    fontFamily: "NotoSansLaoLooped",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: () {
                  _speechPlayer.playLetter(
                    widget.letter,
                    SectionType.consonant,
                  );

                  if (!context.read<LessonProvider>().isBottomSheetVisible) {
                    showBottomBar(
                      context: context,
                      onShow: () {
                        context.read<LessonProvider>().setBottomSheetVisible(
                          true,
                        );
                      },
                      onHide: () {
                        context.read<LessonProvider>().setBottomSheetVisible(
                          false,
                        );
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
