import 'package:flutter/material.dart';
import 'package:learn_lao_app/utilities/shared_styles.dart';
import 'package:learn_lao_app/exercises/select_blank_exercise.dart';


class SelectLetterExercise extends SelectBlankExercise {
  SelectLetterExercise({
    required super.correctLetter,
    required super.incorrectLetters,
    super.usePlaceholders,
    super.key,
  });

  @override
  SelectLetterExerciseState createState() => SelectLetterExerciseState();
}

class SelectLetterExerciseState
    extends SelectBlankExerciseState<SelectLetterExercise> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      speechPlayer.playLetter(widget.correctLetter);
    });
  }

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
                child: ElevatedButton(
                  onPressed: () =>
                      speechPlayer.playLetter(widget.correctLetter),
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
                          child: Text(
                            letter.character,
                            style: laoStyle.copyWith(
                              fontSize: theme.textTheme.displayMedium?.fontSize,
                              // color: selectedButton == index
                              //     ? Theme.of(
                              //         context,
                              //       ).colorScheme.onSurfaceVariant
                              //     : Theme.of(context).colorScheme.onSurface,
                            ),
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
