import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/select_blank_exercise.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';

enum BottomButtonState { incorrect, correct }

class SelectSoundExercise extends SelectBlankExercise {
  SelectSoundExercise({
    required super.correctLetter,
    required super.incorrectLetters,
    super.usePlaceholders,
    super.key,
  });

  @override
  SelectSoundExerciseState createState() => SelectSoundExerciseState();
}

class SelectSoundExerciseState
    extends SelectBlankExerciseState<SelectSoundExercise> {
  @override
  Widget build(BuildContext context) {
    calibrateThemeColors(context);

    return Expanded(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: SizedBox(
                height: 256,
                width: 256,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    widget.correctLetter.character,
                    style: laoStyle.copyWith(fontSize: 256),
                  ),
                ),
              ),
            ),

            AbsorbPointer(
              absorbing: areButtonsDisabled,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  children: List<Widget>.generate(shuffledLetters.length, (
                    index,
                  ) {
                    final letter = shuffledLetters[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        height: 80,
                        child: ElevatedButton(
                          onPressed: () {
                            // Find the letter type from the incorrectLetters or use sectionType for correct letter
                            speechPlayer.playLetter(letter);
                            setState(() {
                              selectedButton = index;
                            });
                          },
                          style: selectedButton == index
                              ? ElevatedButton.styleFrom(
                                  backgroundColor:
                                      theme.colorScheme.surfaceContainerHighest,
                                )
                              : null,
                          child: Icon(
                            Icons.volume_up_rounded,
                            size: theme.textTheme.displayMedium?.fontSize,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Spacer(),
            checkButton(),
          ],
        ),
      ),
    );
  }
}
