import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:read_lao/enums/letter_type.dart';
import 'package:read_lao/typedefs/letter_type.dart';
import 'package:read_lao/utilities/letter_data.dart';
import 'package:read_lao/utilities/shared_styles.dart';
import 'package:read_lao/utilities/audio_utility.dart';
import 'package:read_lao/exercises/stateful_exercise.dart';
import 'package:read_lao/components/dynamic_bold_text.dart';
import 'package:read_lao/components/bottom_lesson_button.dart';
import 'package:read_lao/utilities/provider/lesson_provider.dart';

class LearnConsonantExercise extends StatefulExercise {
  final String consonant;

  LearnConsonantExercise({required this.consonant, super.key});

  @override
  LearningExerciseState createState() => LearningExerciseState();
}

class LearningExerciseState
    extends StatefulExerciseState<LearnConsonantExercise> {
  final _speechPlayer = AudioUtility();
  final _effectPlayer = AudioUtility();

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
        SizedBox(height: 16),
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
                    'assets/consonants/images/${LetterData.laoToRomanization[widget.consonant]}.jpg',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.consonant,
                  style: laoStyle.copyWith(fontSize: 10000),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.contain,
                child: DynamicBoldText(
                  text: LetterData.lettersToWords[widget.consonant]!,
                  targetCharacter: widget.consonant,
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
                    Letter(widget.consonant, LetterType.consonant),
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
