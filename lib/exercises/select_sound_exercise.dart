import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/select_blank_exercise.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';

enum BottomButtonState { incorrect, correct }

class SelectSoundExercise extends SelectBlankExercise {
  SelectSoundExercise({
    required super.correctLetter,
    required super.incorrectLetters,
    required super.sectionType,
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.correctLetter,
                style: laoStyle.copyWith(fontSize: 256),
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
                            speechPlayer.playLetter(letter, widget.sectionType);
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
