import 'package:flutter/material.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:provider/provider.dart';

enum BottomButtonState { incorrect, correct }

// This new abstract class extends StatefulExercise
abstract class SelectBlankExercise extends StatefulExercise {
  final String correctLetter;
  final List<String> allLetters;
  SelectBlankExercise({
    required this.correctLetter,
    required this.allLetters,
    super.key,
  });

  @override
  State<SelectBlankExercise> createState();
}

// The corresponding State class that extends StatefulExerciseState
abstract class SelectBlankExerciseState<T extends SelectBlankExercise>
    extends StatefulExerciseState<T> {
  final effectPlayer = SoundsUtility();
  final speechPlayer = SoundsUtility();
  late final List<String> shuffledLetters;
  late ThemeData theme;
  late bool isDarkMode;
  late Color svgColor;
  bool bottomButtonIsCorrect = true;
  bool bottomLessonButtonPressed = false;
  bool checkButtonPressed = false;
  var selectedButton = -1;

  void checkAnswer() {
    final bool isCorrect =
        shuffledLetters[selectedButton] == widget.correctLetter;

    if (isCorrect) {
      // If the answer is correct
      setState(() => bottomButtonIsCorrect = true);
      effectPlayer.playSoundEffect('correct');
    } else {
      // If the answer is incorrect
      setState(() => bottomButtonIsCorrect = false);
      effectPlayer.playSoundEffect('incorrect');
      context.read<LessonProvider>().markExerciseAsMistake?.call();
    }
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

  @override
  void initState() {
    super.initState();
    // Adds the correct letter plus the incorrect letters to the list of options
    shuffledLetters = List.from(widget.allLetters);
    shuffledLetters.shuffle();

    assert(
      (widget.allLetters.length - 1) <= 2,
      'There can be a maximum of 2 incorrect letters',
    );

    assert(
      widget.allLetters.contains(widget.correctLetter),
      'allLetters must contain correctLetter',
    );
  }

  @override
  void dispose() {
    effectPlayer.dispose();
    speechPlayer.dispose();
    super.dispose();
  }

  void calibrateThemeColors(BuildContext context) {
    theme = Theme.of(context);
    isDarkMode = theme.brightness == Brightness.dark;
    svgColor = isDarkMode ? Colors.white : Colors.black;
  }

  bool get areButtonsDisabled =>
      context.watch<LessonProvider>().isBottomSheetVisible;

  // The build method is still required (inherited from StatefulExerciseState)
  @override
  Widget build(BuildContext context);

  Widget checkButton() {
    return SafeArea(
      child: BottomLessonButton(
        onPressed: (selectedButton == -1)
            ? null
            : (checkButtonPressed) // Stop the user from pressing it twice
            ? () {} // If it has been pressed, stop it from being pressed again
            : () {
                setState(() {
                  checkButtonPressed = true;
                });
                checkAnswer();
              },
        buttonText: 'Check',
        buttonIcon: const Icon(Icons.check_rounded),
      ),
    ); // The bottom button
  }

  @override
  Widget bottomSheetContent(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 8),
        Text(
          bottomButtonIsCorrect ? 'Correct!' : 'Incorrect!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        BottomLessonButton(
          onPressed: bottomButtonIsCorrect
              ? context.read<LessonProvider>().nextExercise
              : Navigator.of(
                  context,
                ).pop, // Close the bottom sheet no matter what,
          buttonIcon: bottomButtonIsCorrect
              ? const Icon(Icons.arrow_forward_rounded)
              : const Icon(Icons.refresh_rounded),
          buttonText: bottomButtonIsCorrect ? 'Continue' : 'Try Again',
          buttonColor: bottomButtonIsCorrect ? Colors.green : Colors.red,
        ),
      ],
    );
  }
}
