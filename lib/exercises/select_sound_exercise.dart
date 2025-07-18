import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/select_blank_exercise.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';

enum BottomButtonState { incorrect, correct }

class SelectSoundExercise extends SelectBlankExercise {
  SelectSoundExercise({
    required super.correctLetter,
    required super.allLetters,
    required super.sectionType,
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
            Expanded(
              flex: 2,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.correctLetter,
                  style: laoStyle.copyWith(fontSize: 10000),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: AbsorbPointer(
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
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                speechPlayer.playLetter(
                                  letter,
                                  widget.sectionType,
                                );
                                setState(() {
                                  selectedButton = index;
                                });
                              },
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: index == selectedButton
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.secondary,
                              ),
                              child: Icon(
                                Icons.volume_up_rounded,
                                size: theme.textTheme.displayMedium?.fontSize,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: checkButton(),
            ),
          ],
        ),
      ),
    );
  }
}
