import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:learn_lao_app/enums/letter_type.dart';
import 'package:learn_lao_app/typedefs/letter_type.dart';
import 'package:learn_lao_app/utilities/letter_data.dart';
import 'package:learn_lao_app/utilities/audio_utility.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/exercises/select_sound_exercise.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';


// This new abstract class extends StatefulExercise
abstract class SelectBlankExercise extends StatefulExercise {
  SelectBlankExercise({
    required this.correctLetter,
    required this.incorrectLetters,
    this.usePlaceholders,
    super.key,
  });

  final Letter correctLetter;
  final List<Letter> incorrectLetters;
  final bool? usePlaceholders;

  @override
  State<SelectBlankExercise> createState();
}

// The corresponding State class that extends StatefulExerciseState
abstract class SelectBlankExerciseState<T extends SelectBlankExercise>
    extends StatefulExerciseState<T> {
  final effectPlayer = AudioUtility();
  final speechPlayer = AudioUtility();
  late final List<Letter> shuffledLetters;
  late ThemeData theme;
  late bool isDarkMode;
  late Color svgColor;
  bool bottomButtonIsCorrect = true;
  var selectedButton = -1;

  void checkAnswer() {
    late final bool isCorrect;
    if (shuffledLetters[selectedButton].type == widget.correctLetter.type) {
      if (widget.correctLetter.type == LetterType.vowel) {
        isCorrect =
            LetterData.getVowelIndex(
              shuffledLetters[selectedButton].character,
            ) ==
            LetterData.getVowelIndex(shuffledLetters[selectedButton].character);
      } else {
        isCorrect =
            shuffledLetters[selectedButton].character ==
            widget.correctLetter.character;
      }
    } else {
      isCorrect = false;
    }

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
    final Set<String> uniqueCharacters = {};
    if (this is SelectSoundExerciseState) {
      shuffledLetters =
          [...widget.incorrectLetters, widget.correctLetter]
              .map(
                (letter) => Letter(
                  character: letter.type == LetterType.consonant
                      ? letter.character
                      : LetterData.vowelsIndex[LetterData.getVowelIndex(
                          letter.character,
                        )],
                  type: letter.type,
                ),
              )
              .toList()
            ..retainWhere((letter) => uniqueCharacters.add(letter.character));
    } else {
      shuffledLetters = [...widget.incorrectLetters, widget.correctLetter];
    }
    shuffledLetters.shuffle();

    assert(
      widget.incorrectLetters.length <= 3,
      'There can be a maximum of 3 incorrect letters',
    );

    assert(!widget.incorrectLetters.contains(widget.correctLetter));
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
      child: Padding(
        padding: const EdgeInsets.only(bottom: 0.0),
        child: BottomLessonButton(
          onPressed: (selectedButton < 0) ? null : checkAnswer,
          buttonText: 'Check',
          buttonIcon: const Icon(Icons.check_rounded),
        ),
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
        SizedBox(height: 16),
      ],
    );
  }
}
