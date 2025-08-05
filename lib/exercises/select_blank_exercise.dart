import 'package:flutter/material.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/enums/section_type.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:provider/provider.dart';

enum BottomButtonState { incorrect, correct }

// This new abstract class extends StatefulExercise
abstract class SelectBlankExercise extends StatefulExercise {
  SelectBlankExercise({
    required this.correctLetter,
    required this.incorrectLetters,
    required this.sectionType,
    this.usePlaceholders,
    super.key,
  });

  final String correctLetter;
  final List<String> incorrectLetters;
  final SectionType sectionType;
  final bool? usePlaceholders;

  @override
  State<SelectBlankExercise> createState();
}

// The corresponding State class that extends StatefulExerciseState
abstract class SelectBlankExerciseState<T extends SelectBlankExercise>
    extends StatefulExerciseState<T> {
  final effectPlayer = SoundsUtility();
  final speechPlayer = SoundsUtility();
  late final List<String> shuffledLetters;
  late final List<String> allLetters;
  late ThemeData theme;
  late bool isDarkMode;
  late Color svgColor;
  bool bottomButtonIsCorrect = true;
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
    shuffledLetters = List.from(
      widget.incorrectLetters + [widget.correctLetter],
    );
    shuffledLetters.shuffle();

    assert(
      (widget.incorrectLetters.length) <= 3,
      'There can be a maximum of 4 incorrect letters',
    );

    assert(
      !widget.incorrectLetters.contains(widget.correctLetter),
      'incorrectLetters must not contain correctLetter',
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
        onPressed: (selectedButton < 0) ? null : checkAnswer,
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
              ? context.read<LessonProvider>().nextExercise!
              : Navigator.of(context).pop,
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
