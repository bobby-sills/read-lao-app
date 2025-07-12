import 'package:flutter/material.dart';
import 'package:learn_lao_app/components/matching_button.dart';
import 'package:learn_lao_app/enums/button_type.dart';
import 'package:provider/provider.dart';
import 'package:learn_lao_app/components/bottom_lesson_button.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/provider/lesson_provider.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';
import 'package:learn_lao_app/enums/button_state.dart';

class MatchingExercise extends StatefulExercise {
  final List<String> lettersToMatch;

  MatchingExercise({required this.lettersToMatch, super.key});

  @override
  State<MatchingExercise> createState() => _MatchingExerciseState();
}

class _MatchingExerciseState extends StatefulExerciseState<MatchingExercise>
    with SingleTickerProviderStateMixin {
  // These are seperate players for the sound and effect, so that they can be played at the same time
  final SoundsUtility _speechPlayer = SoundsUtility();
  final SoundsUtility _effectPlayer = SoundsUtility();

  late final Map<ButtonType, List<String>> positions;
  late final Map<ButtonType, List<ButtonState>> states;
  late final int numOfPaires;
  late final ThemeData theme;

  List<ButtonState> get deselectedStates {
    return List.filled(numOfPaires, ButtonState.deselected);
  }

  @override
  void initState() {
    super.initState();

    numOfPaires = widget.lettersToMatch.length;
    // Copy the lettersToMatch list to the soundPositions and characterPositions lists
    // This is done so that the original list is not modified when shuffling
    positions = {
      ButtonType.sound: widget.lettersToMatch.toList(),
      ButtonType.letter: widget.lettersToMatch.toList(),
    };

    // Shuffle the soundPositions and characterPositions lists
    positions[ButtonType.letter]!.shuffle();
    positions[ButtonType.sound]!.shuffle();

    // Creates a list of button states keeping track of the state of each button
    // They are all originally set to deselected
    states = {
      ButtonType.letter: deselectedStates,
      ButtonType.sound: deselectedStates,
    };
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  void _selectButton(int index, buttonType) {
    final i = index;
    setState(() {
      // If the button is already selected, deselect it
      if (states[buttonType]![i] == ButtonState.selected) {
        states[buttonType]![i] = ButtonState.deselected;
        return;
      }

      // If the button is deselected, deselect the previous selected button, and select the current button
      if (states[buttonType]![i] == ButtonState.deselected) {
        int selectedIndex = states[buttonType]!.indexOf(
          ButtonState.selected,
        ); // Get previous selected index
        if (selectedIndex != -1) {
          states[buttonType]![selectedIndex] = ButtonState.deselected;
        } // Deselect it
        states[buttonType]![i] = ButtonState.selected;
        return;
      }
    });
    _checkForMatches();
  }

  void _checkForMatches() {
    int soundIndex = states[ButtonType.sound]!.indexOf(ButtonState.selected);
    int letterIndex = states[ButtonType.letter]!.indexOf(ButtonState.selected);

    if (soundIndex != -1 && letterIndex != -1) {
      bool isMatch =
          positions[ButtonType.sound]![soundIndex] ==
          positions[ButtonType.letter]![letterIndex];

      if (isMatch) {
        setState(() {
          states[ButtonType.sound]![soundIndex] = ButtonState.complete;
          states[ButtonType.letter]![letterIndex] = ButtonState.complete;
        });
        // Set time until disabled if correct
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            states[ButtonType.sound]![soundIndex] = ButtonState.disabled;
            states[ButtonType.letter]![letterIndex] = ButtonState.disabled;
          });
        });

        // If everything is matched, then show the bottom bar
        if (states[ButtonType.sound]!.every(
              (state) =>
                  state == ButtonState.disabled ||
                  state == ButtonState.complete,
            ) &&
            states[ButtonType.letter]!.every(
              (state) =>
                  state == ButtonState.disabled ||
                  state == ButtonState.complete,
            )) {
          showBottomBar(
            context: context,
            onShow: () {
              context.read<LessonProvider>().setBottomSheetVisible(true);
            },
            onHide: () {
              context.read<LessonProvider>().setBottomSheetVisible(false);
            },
          );
        }
        // Correct sound effect
        _effectPlayer.playSoundEffect("correct");
      } else {
        setState(() {
          states[ButtonType.sound]![soundIndex] = ButtonState.incorrect;
          states[ButtonType.letter]![letterIndex] = ButtonState.incorrect;
        });
        _effectPlayer.playSoundEffect("incorrect");
        context.read<LessonProvider>().markExerciseAsMistake?.call();
        // Set time until deselected if incorrect
        Future.delayed(Duration(milliseconds: 800), () {
          setState(() {
            states[ButtonType.sound]![soundIndex] = ButtonState.deselected;
            states[ButtonType.letter]![letterIndex] = ButtonState.deselected;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _speechPlayer.dispose();
    _effectPlayer.dispose();
    super.dispose();
  }

  @override
  Widget bottomSheetContent(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        BottomLessonButton(
          onPressed: () {
            context.read<LessonProvider>().nextExercise?.call();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Dynamically generates a row for each matching pair, with a sound button and a character button
          Expanded(
            child: Center(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: numOfPaires,
                itemBuilder: (context, i) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Sound button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 16.0,
                            right: 8.0,
                          ),
                          child: SizedBox(
                            height: 100,
                            child: MatchingButton(
                              buttonType: ButtonType.sound,
                              index: i,
                              states: states,
                              letter: positions[ButtonType.sound]![i],
                              selectButtonCallback: _selectButton,
                              player: _speechPlayer,
                            ),
                          ),
                        ),
                      ),

                      // Character button
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                            bottom: 8.0,
                            left: 8.0,
                            right: 16.0,
                          ),
                          child: SizedBox(
                            height: 100,
                            child: MatchingButton(
                              buttonType: ButtonType.letter,
                              index: i,
                              states: states,
                              letter: positions[ButtonType.letter]![i],
                              selectButtonCallback: _selectButton,
                              player: _speechPlayer,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
