import 'package:flutter/material.dart';
import 'package:learn_lao_app/exercises/stateful_exercise.dart';
import 'package:learn_lao_app/utilities/sounds_utility.dart';

enum CardState { on, off }

class SpellingExercise extends StatefulExercise {
  final String word;

  SpellingExercise({super.key, required this.word});

  @override
  StatefulExerciseState<SpellingExercise> createState() =>
      _SpellingExerciseState();
}

class _SpellingExerciseState extends StatefulExerciseState<SpellingExercise> {
  late final List<int> tray;
  late final List<CardState> states;
  final List<int> clickOrder = [];
  final SoundsUtility soundsUtility = SoundsUtility();

  @override
  initState() {
    super.initState();
    tray = widget.word.runes.toList();
    states = List.filled(tray.length, CardState.on);
  }

  String get _displayText {
    return String.fromCharCodes(
      clickOrder.expand(
        (index) => states[index] == CardState.off ? [tray[index]] : <int>[],
      ),
    );
  }

  void _onCardTap(int index) {
    setState(() {
      if (states[index] == CardState.on) {
        states[index] = CardState.off;
        clickOrder.add(index);
      } else {
        states[index] = CardState.on;
        clickOrder.remove(index);
      }
    });
  }

  Future<void> _playWord() async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  onPressed: _playWord,
                  style: ElevatedButton.styleFrom(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    side: BorderSide(
                      color: theme.colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  child: Icon(Icons.volume_up_rounded, size: 48),
                ),
              ),
            ),
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
                            String.fromCharCode(tray[i]),
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
