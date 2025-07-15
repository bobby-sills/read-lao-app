import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/select_blank_exercise.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';

enum BottomButtonState { incorrect, correct }

class SelectSoundExercise extends SelectBlankExercise {
  SelectSoundExercise({
    required super.correctLetter,
    required super.allLetters,
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
          mainAxisSize: MainAxisSize.min,
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
            Spacer(),
            AbsorbPointer(
              absorbing: areButtonsDisabled,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  spacing: 8.0,
                  children: List<Widget>.generate(shuffledLetters.length, (
                    index,
                  ) {
                    final letter = shuffledLetters[index];
                    return FilledButton(
                      onPressed: () {
                        speechPlayer.playLetter(letter);
                        setState(() {
                          selectedButton = index;
                        });
                      },
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          vertical: 25,
                          horizontal: 100,
                        ),
                        backgroundColor: index == selectedButton
                            ? theme.colorScheme.primary
                            : theme.colorScheme.secondary,
                      ),
                      child: Icon(
                        Icons.volume_up_rounded,
                        size: theme.textTheme.displayMedium?.fontSize,
                      ),
                    );
                  }),
                ),
              ),
            ),
            checkButton(),
          ],
        ),
      ),
    );
  }
}
