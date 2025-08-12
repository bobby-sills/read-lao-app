import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';

enum CardState { on, off }

class SpellingExercise extends StatefulExercise {
  final String word;

  SpellingExercise({super.key, required this.word});

  @override
  StatefulExerciseState<SpellingExercise> createState() =>
      _SpellingExerciseState();
}

class _SpellingExerciseState extends StatefulExerciseState<SpellingExercise> {
  late final Iterable<Runes> letters;
  late final List<String> tray;
  late final List<CardState> states;

  @override
  initState() {
    super.initState();
    letters = widget.word.runes;
    tray = widget.letters;
    states = List.filled(tray.length, CardState.on);
  }

  String get _displayText {
    List<String> selectedLetters = [];
    for (int i = 0; i < tray.length; i++) {
      if (states[i] == CardState.off) {
        selectedLetters.add(tray[i]);
      }
    }
    return selectedLetters.isEmpty ? 'Text box' : selectedLetters.join('');
  }

  void _onCardTap(int index) {
    setState(() {
      states[index] = states[index] == CardState.on
          ? CardState.off
          : CardState.on;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    padding: EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        _displayText,
                        style: TextStyle(
                          fontFamily: "NotoSansLaoLooped",
                          fontSize: 36,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  for (int i = 0; i < tray.length; i++)
                    GestureDetector(
                      onTap: () => _onCardTap(i),
                      child: Card(
                        elevation: states[i] == CardState.on ? 4.0 : 0.0,
                        color: states[i] == CardState.on
                            ? Theme.of(context).colorScheme.surface
                            : Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHighest,
                        child: Center(
                          child: Text(
                            tray[i],
                            style: TextStyle(
                              fontFamily: "NotoSansLaoLooped",
                              fontWeight: FontWeight.w500,
                              fontSize: 36,
                              color: states[i] == CardState.on
                                  ? Theme.of(context).colorScheme.onSurface
                                  : Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }

  @override
  Widget bottomSheetContent(BuildContext context) {
    return Placeholder();
  }
}
