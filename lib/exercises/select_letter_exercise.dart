import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/select_blank_exercise.dart';

enum BottomButtonState { incorrect, correct }

class SelectLetterExercise extends SelectBlankExercise {
  SelectLetterExercise({
    required super.correctLetter,
    required super.allLetters,
    required super.sectionType,
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
      speechPlayer.playLetter(widget.correctLetter, widget.sectionType);
    });
  }

  @override
  Widget build(BuildContext context) {
    calibrateThemeColors(context);

    // This is needed for generating a unique key

    return Expanded(
      child: Center(
        child: Column(
          children: [
            // Main sound button
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: ElevatedButton(
                    onPressed: () => speechPlayer.playLetter(
                      widget.correctLetter,
                      widget.sectionType,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.all(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(Icons.volume_up_rounded, size: 64),
                    ),
                  ),
                ),
              ),
            ),
            // The options
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
                    children: [
                      for (
                        int index = 0;
                        index < shuffledLetters.length;
                        index++
                      ) ...[
                        Expanded(
                          flex: 3,
                          child: FilledButton(
                            onPressed: () {
                              setState(() {
                                selectedButton = index;
                              });
                            },
                            style: FilledButton.styleFrom(
                              // Changes background color based on whether the button is selected
                              backgroundColor: index == selectedButton
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.secondary,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              child: Center(
                                child: AutoSizeText(
                                  shuffledLetters[index],
                                  style: TextStyle(
                                    fontFamily: 'NotoSansLaoLooped',
                                    fontSize:
                                        theme.textTheme.displayLarge!.fontSize!,
                                  ),
                                  maxFontSize:
                                      theme.textTheme.displayLarge!.fontSize!,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (index < shuffledLetters.length - 1) Spacer(),
                      ],
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ),
            // Check button area
            checkButton(),
          ],
        ),
      ),
    );
  }
}
