import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn_lao_app/enums/letter_type.dart';
import 'package:learn_lao_app/typedefs/letter_type.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';
import 'package:learn_lao_app/utilities/audio_utility.dart';
import 'package:learn_lao_app/utilities/helper_functions.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';

class LearnVowelExercise extends StatefulExercise {
  LearnVowelExercise({required this.vowel, this.consonant, super.key});

  final String vowel;
  final String? consonant;

  @override
  LearnVowelExerciseState createState() => LearnVowelExerciseState();
}

class LearnVowelExerciseState
    extends StatefulExerciseState<LearnVowelExercise> {
  final _speechPlayer = AudioUtility();
  final _effectPlayer = AudioUtility();
  late final String letter;

  @override
  void initState() {
    super.initState();
    letter = widget.consonant == null
        ? widget.vowel
        : addConsonantToVowel(widget.vowel, widget.consonant!);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    // This is needed for generating a unique key

    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(letter, style: laoStyle.copyWith(fontSize: 200)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 256,
                width: 256,
                child: ElevatedButton(
                  onPressed: () {
                    _speechPlayer.playLetter(
                      Letter(character: widget.vowel, type: LetterType.vowel),
                    );

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
                    padding: EdgeInsets.all(24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Icon(Icons.volume_up_rounded, size: 48),
                  ),
                ),
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: ElevatedButton(
            //     onPressed: () {
            //       _speechPlayer.playLetter(
            //         Letter(character: widget.vowel, type: LetterType.vowel),
            //       );
            //
            //       if (!Provider.of<LessonProvider>(
            //         context,
            //         listen: false,
            //       ).isBottomSheetVisible) {
            //         showBottomBar(
            //           context: context,
            //           onShow: () {
            //             Provider.of<LessonProvider>(
            //               context,
            //               listen: false,
            //             ).setBottomSheetVisible(true);
            //           },
            //           onHide: () {
            //             Provider.of<LessonProvider>(
            //               context,
            //               listen: false,
            //             ).setBottomSheetVisible(false);
            //           },
            //         );
            //       }
            //     },
            //     style: ElevatedButton.styleFrom(
            //       padding: EdgeInsets.symmetric(vertical: 10, horizontal: 100),
            //     ),
            //     child: Icon(
            //       Icons.volume_up_rounded,
            //       size: theme.textTheme.displayMedium?.fontSize,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
